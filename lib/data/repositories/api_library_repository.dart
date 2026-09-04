import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../core/network/api_client.dart';
import '../cache/local_cache_store.dart';
import '../../domain/entities/models.dart';
import '../../domain/repositories/library_repository.dart';

class ApiLibraryRepository implements LibraryRepository {
  final ApiClient _apiClient;
  final LocalCacheStore _cache;
  final Uuid _uuid = const Uuid();

  ApiLibraryRepository(this._apiClient, SharedPreferences preferences)
    : _cache = LocalCacheStore(preferences);

  @override
  void setSession(String? email) => _cache.setSession(email);

  Dio get _dio => _apiClient.dio;

  Map<String, Object?> _map(Object? value) {
    if (value is Map<String, dynamic>) return Map<String, Object?>.from(value);
    if (value is Map<String, Object?>) return value;
    throw const FormatException('Resposta inválida da API');
  }

  Map<String, Object?> _data(Response<Object?> response) =>
      _map(_map(response.data)['data']);

  String _requiredString(Map<String, Object?> value, String key) {
    final field = value[key];
    if (field is String && field.isNotEmpty) return field;
    throw FormatException('Campo obrigatório ausente: $key');
  }

  String _error(DioException exception) {
    final responseData = exception.response?.data;
    if (responseData is Map<String, dynamic>) {
      final message = responseData['error'];
      if (message is String && message.isNotEmpty) return message;
    }
    return exception.message ?? 'Erro de comunicação com a API';
  }

  Future<T> _request<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (exception) {
      throw Exception(_error(exception));
    }
  }

  bool _isOffline(DioException exception) =>
      exception.type == DioExceptionType.connectionError ||
      exception.type == DioExceptionType.connectionTimeout ||
      exception.type == DioExceptionType.receiveTimeout ||
      exception.type == DioExceptionType.sendTimeout;

  Collection _collection(Object? value) {
    final map = _map(value);
    return Collection(
      id: _requiredString(map, 'id'),
      name: _requiredString(map, 'name'),
      joinCode: map['joinCode'] as String?,
    );
  }

  Location _location(Object? value) {
    final map = _map(value);
    return Location(
      id: _requiredString(map, 'id'),
      collectionId: _requiredString(map, 'collectionId'),
      name: _requiredString(map, 'name'),
    );
  }

  String _author(Map<String, Object?> map) {
    final contributors = map['contributors'];
    if (contributors is List<Object?>) {
      return contributors
          .map(
            (contributor) => contributor is Map<String, dynamic>
                ? contributor['name']
                : contributor,
          )
          .whereType<String>()
          .join(', ');
    }
    if (contributors is String) return contributors;
    final author = map['author'];
    if (author is String && author.isNotEmpty) return author;
    return 'Autor não informado';
  }

  Book _book(Object? value) {
    final map = _map(value);
    final id = map['id'];
    final localId = map['localId'];
    final bookId = id is String && id.isNotEmpty
        ? id
        : localId is String && localId.isNotEmpty
        ? ''
        : _requiredString(map, 'id');
    return Book(
      id: bookId,
      localId: localId as String?,
      isPending: map['isPending'] == true,
      isbn: map['isbn'] as String?,
      title: _requiredString(map, 'title'),
      author: _author(map),
      collectionId: _requiredString(map, 'collectionId'),
    );
  }

  List<Object?> _list(Map<String, Object?> responseData) {
    final data = responseData['data'];
    if (data is List<Object?>) return data;
    throw const FormatException('Lista inválida da API');
  }

  @override
  Future<List<Collection>> getCollections() => _request(() async {
    try {
      final response = await _dio.get<Object?>('/collections');
      final collections = _list(_map(response.data)).map(_collection).toList();
      await _cache.writeList(
        'collections',
        collections
            .map(
              (item) => {
                'id': item.id,
                'name': item.name,
                'joinCode': item.joinCode,
              },
            )
            .toList(),
      );
      return collections;
    } on DioException catch (exception) {
      if (!_isOffline(exception)) rethrow;
      return _cache.readList('collections').map(_collection).toList();
    }
  });

  @override
  Future<Collection> createCollection(String name) => _request(() async {
    final response = await _dio.post<Object?>(
      '/collections',
      data: {'name': name},
    );
    return _collection(_data(response));
  });

  @override
  Future<Collection> updateCollection(String collectionId, String name) =>
      _request(() async {
        final response = await _dio.patch<Object?>(
          '/collections/$collectionId',
          data: {'name': name},
        );
        return _collection(_data(response));
      });

  @override
  Future<void> deleteCollection(String collectionId) => _request(() async {
    await _dio.delete<Object?>('/collections/$collectionId');
  });

  @override
  Future<List<Location>> getLocations(String collectionId) =>
      _request(() async {
        try {
          final response = await _dio.get<Object?>(
            '/collections/$collectionId/locations',
          );
          final locations = _list(_map(response.data)).map(_location).toList();
          await _cache.writeList(
            'locations:$collectionId',
            locations
                .map(
                  (item) => {
                    'id': item.id,
                    'collectionId': item.collectionId,
                    'name': item.name,
                  },
                )
                .toList(),
          );
          return locations;
        } on DioException catch (exception) {
          if (!_isOffline(exception)) rethrow;
          return _cache
              .readList('locations:$collectionId')
              .map(_location)
              .toList();
        }
      });

  @override
  Future<Location> createLocation(String collectionId, String name) =>
      _request(() async {
        final response = await _dio.post<Object?>(
          '/collections/$collectionId/locations',
          data: {'name': name},
        );
        return _location(_data(response));
      });

  @override
  Future<Location> updateLocation(String locationId, String name) =>
      _request(() async {
        final response = await _dio.patch<Object?>(
          '/locations/$locationId',
          data: {'name': name},
        );
        return _location(_data(response));
      });

  @override
  Future<void> deleteLocation(String locationId) => _request(() async {
    await _dio.delete<Object?>('/locations/$locationId');
  });

  @override
  Future<List<Book>> getBooks(String collectionId) => _request(() async {
    try {
      await _syncPending(collectionId);
      final response = await _dio.get<Object?>(
        '/collections/$collectionId/books',
      );
      final books = _list(_map(response.data)).map(_book).toList();
      await _saveBooks(collectionId, books);
      return books;
    } on DioException catch (exception) {
      if (!_isOffline(exception)) rethrow;
      return _cachedBooks(collectionId);
    }
  });

  Future<void> _saveBooks(String collectionId, List<Book> books) async {
    final pending = _cache.readList('pendingBooks:$collectionId');
    final savedBooks = <String, Map<String, Object?>>{};
    for (final book in [...books.map(_encodeBook), ...pending]) {
      final key = book['localId'] as String? ?? book['id'] as String? ?? '';
      savedBooks[key] = book;
    }
    await _cache.writeList('books:$collectionId', [...savedBooks.values]);
  }

  List<Book> _cachedBooks(String collectionId) =>
      _cache.readList('books:$collectionId').map(_book).toList();

  Map<String, Object?> _encodeBook(Book book) => {
    'id': book.id,
    'localId': book.localId,
    'isPending': book.isPending,
    'isbn': book.isbn,
    'title': book.title,
    'author': book.author,
    'collectionId': book.collectionId,
  };

  Future<void> _syncPending(String collectionId) async {
    final pending = _cache.readList('pendingBooks:$collectionId');
    if (pending.isEmpty) return;
    final remaining = <Map<String, Object?>>[];
    for (final item in pending) {
      try {
        final response = await _dio.post<Object?>(
          '/collections/$collectionId/books',
          data: {
            if (item['isbn'] is String && (item['isbn']! as String).isNotEmpty)
              'isbn': item['isbn'],
            'metadata': {
              'title': item['title'],
              if (item['author'] is String &&
                  (item['author']! as String).isNotEmpty)
                'contributors': [
                  {'name': item['author']},
                ],
            },
          },
        );
        final synced = _book(_data(response));
        final books = _cachedBooks(collectionId)
            .where((book) => book.localId != item['localId'])
            .toList();
        await _saveBooks(collectionId, [...books, synced]);
      } on DioException catch (exception) {
        if (!_isOffline(exception)) rethrow;
        remaining.add(item);
      }
    }
    await _cache.writeList('pendingBooks:$collectionId', remaining);
  }

  @override
  Future<Book> lookupBook(String isbn) => _request(() async {
    try {
      final response = await _dio.get<Object?>('/books/lookup/$isbn');
      final draft = _bookForDraft(_data(response));
      await _cache.writeList('lookups:$isbn', [_encodeBook(draft)]);
      return draft;
    } on DioException catch (exception) {
      if (!_isOffline(exception)) rethrow;
      final cached = _cache.readList('lookups:$isbn');
      if (cached.isEmpty) rethrow;
      return _cachedDraft(cached.first);
    }
  });

  Book _bookForDraft(Map<String, Object?> map) => Book(
    id: '',
    isbn: map['isbn'] as String?,
    title: _requiredString(map, 'title'),
    author: _author(map),
    collectionId: '',
  );

  Book _cachedDraft(Map<String, Object?> map) => Book(
    id: '',
    isbn: map['isbn'] as String?,
    title: _requiredString(map, 'title'),
    author: _author(map),
    collectionId: '',
  );

  @override
  Future<Book?> findBookInCollection(String collectionId, String isbn) =>
      _request(() async {
        try {
          final response = await _dio.get<Object?>(
            '/collections/$collectionId/books/check/$isbn',
          );
          final data = _data(response);
          final book = data['book'];
          return data['alreadyPresent'] == true && book != null
              ? _book(book)
              : null;
        } on DioException catch (exception) {
          if (!_isOffline(exception)) rethrow;
          final cached = _cachedBooks(collectionId)
              .where((book) => book.isbn == isbn)
              .toList();
          return cached.isEmpty ? null : cached.first;
        }
      });

  @override
  Future<Book> addBookToCollection(
    String collectionId,
    String? isbn, {
    String? title,
    String? author,
  }) => _request(() async {
    final metadata = <String, Object?>{};
    if (title != null && title.trim().isNotEmpty)
      metadata['title'] = title.trim();
    if (author != null && author.trim().isNotEmpty) {
      metadata['contributors'] = [
        {'name': author.trim()},
      ];
    }
    try {
      final response = await _dio.post<Object?>(
        '/collections/$collectionId/books',
        data: {
          if (isbn != null && isbn.isNotEmpty) 'isbn': isbn,
          if (metadata.isNotEmpty) 'metadata': metadata,
        },
      );
      return _book(_data(response));
    } on DioException catch (exception) {
      if (!_isOffline(exception)) rethrow;
      final pending = Book(
        id: '',
        localId: _uuid.v4(),
        isPending: true,
        isbn: isbn,
        title: title ?? 'Livro sem título',
        author: author ?? '',
        collectionId: collectionId,
      );
      final pendingItems = _cache.readList('pendingBooks:$collectionId')
        ..add(_encodeBook(pending));
      await _cache.writeList('pendingBooks:$collectionId', pendingItems);
      await _saveBooks(collectionId, _cachedBooks(collectionId)..add(pending));
      return pending;
    }
  });

  @override
  Future<Book> updateBook(
    String collectionId,
    Book book, {
    String? title,
    String? author,
  }) => _request(() async {
    final data = <String, Object?>{};
    if (title != null && title.trim().isNotEmpty) data['title'] = title.trim();
    if (author != null && author.trim().isNotEmpty) {
      data['contributors'] = [
        {'name': author.trim()},
      ];
    }
    final response = await _dio.patch<Object?>(
      '/collections/$collectionId/books/id/${book.id}',
      data: data,
    );
    return _book(_data(response));
  });

  @override
  Future<void> removeBook(String collectionId, Book book) => _request(() async {
    await _dio.delete<Object?>(
      '/collections/$collectionId/books/id/${book.id}',
    );
  });
}
