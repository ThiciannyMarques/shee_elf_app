import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../core/di/service_locator.dart';
import '../../core/network/api_client.dart';
import '../../domain/entities/models.dart';
import '../../domain/repositories/library_repository.dart';
import '../datasources/local_data_source.dart';

class ApiLibraryRepository implements LibraryRepository {
  final ApiClient apiClient;
  final SharedPreferences preferences;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  ApiLibraryRepository(this.apiClient, this.preferences);

  LocalDataSource get _localData => getIt<LocalDataSource>();

  Future<String> _getUserId() async {
    return await _secureStorage.read(key: 'current_user_email') ??
        'offline_user';
  }

  String _extractErrorMessage(DioException e) {
    if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
      final data = e.response!.data as Map<String, dynamic>;
      if (data.containsKey('error')) return data['error'].toString();
    }
    return e.message ?? 'Erro de conexão HTTP';
  }

  @override
  void setSession(String? email) {}

  @override
  Future<List<Collection>> getCollections() async {
    final userId = await _getUserId();
    try {
      final response = await apiClient.dio.get('/collections');
      final rawList = response.data['data'] as List;
      await _localData.cacheData(
        id: 'collections',
        userId: userId,
        data: {'list': rawList},
      );
      return rawList
          .map((e) => Collection.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (ApiClient.isOfflineException(e)) {
        final cached = await _localData.getCachedData(userId);
        try {
          final cacheEntry = cached.firstWhere((c) => c.containsKey('list'));
          final list = cacheEntry['list'] as List;
          return list
              .map((e) => Collection.fromJson(e as Map<String, dynamic>))
              .toList();
        } catch (_) {
          return [];
        }
      }
      throw Exception(_extractErrorMessage(e));
    }
  }

  @override
  Future<Collection> createCollection(String name) async {
    final userId = await _getUserId();
    try {
      final response = await apiClient.dio.post(
        '/collections',
        data: {'name': name},
      );
      return Collection.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      if (ApiClient.isOfflineException(e)) {
        final tempId = const Uuid().v4();
        await _localData.enqueueOperation(
          userId: userId,
          method: 'POST',
          endpoint: '/collections',
          payload: {'name': name},
        );
        return Collection(id: tempId, name: name);
      }
      throw Exception(_extractErrorMessage(e));
    }
  }

  @override
  Future<Collection> updateCollection(String id, String name) async {
    final userId = await _getUserId();
    try {
      final response = await apiClient.dio.put(
        '/collections/$id',
        data: {'name': name},
      );
      return Collection.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      if (ApiClient.isOfflineException(e)) {
        await _localData.enqueueOperation(
          userId: userId,
          method: 'PUT',
          endpoint: '/collections/$id',
          payload: {'name': name},
        );
        return Collection(id: id, name: name);
      }
      throw Exception(_extractErrorMessage(e));
    }
  }

  @override
  Future<void> deleteCollection(String id) async {
    final userId = await _getUserId();
    try {
      await apiClient.dio.delete('/collections/$id');
    } on DioException catch (e) {
      if (ApiClient.isOfflineException(e)) {
        await _localData.enqueueOperation(
          userId: userId,
          method: 'DELETE',
          endpoint: '/collections/$id',
          payload: {},
        );
        return;
      }
      throw Exception(_extractErrorMessage(e));
    }
  }

  @override
  Future<List<Location>> getLocations(String colId) async {
    final userId = await _getUserId();
    try {
      final response = await apiClient.dio.get('/collections/$colId/locations');
      final rawList = response.data['data'] as List;
      await _localData.cacheData(
        id: 'locations_$colId',
        userId: userId,
        data: {'list': rawList},
      );
      return rawList
          .map((e) => Location.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (ApiClient.isOfflineException(e)) {
        final cached = await _localData.getCachedData(userId);
        try {
          final cacheEntry = cached.firstWhere((c) => c.containsKey('list'));
          final list = cacheEntry['list'] as List;
          return list
              .map((e) => Location.fromJson(e as Map<String, dynamic>))
              .toList();
        } catch (_) {
          return [];
        }
      }
      throw Exception(_extractErrorMessage(e));
    }
  }

  @override
  Future<Location> createLocation(String colId, String name) async {
    final userId = await _getUserId();
    try {
      final response = await apiClient.dio.post(
        '/collections/$colId/locations',
        data: {'name': name},
      );
      return Location.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      if (ApiClient.isOfflineException(e)) {
        final tempId = const Uuid().v4();
        await _localData.enqueueOperation(
          userId: userId,
          method: 'POST',
          endpoint: '/collections/$colId/locations',
          payload: {'name': name},
        );
        return Location(id: tempId, collectionId: colId, name: name);
      }
      throw Exception(_extractErrorMessage(e));
    }
  }

  @override
  Future<Location> updateLocation(String id, String name) async {
    final userId = await _getUserId();
    try {
      final response = await apiClient.dio.put(
        '/locations/$id',
        data: {'name': name},
      );
      return Location.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      if (ApiClient.isOfflineException(e)) {
        await _localData.enqueueOperation(
          userId: userId,
          method: 'PUT',
          endpoint: '/locations/$id',
          payload: {'name': name},
        );
        return Location(id: id, collectionId: '', name: name);
      }
      throw Exception(_extractErrorMessage(e));
    }
  }

  @override
  Future<void> deleteLocation(String id) async {
    final userId = await _getUserId();
    try {
      await apiClient.dio.delete('/locations/$id');
    } on DioException catch (e) {
      if (ApiClient.isOfflineException(e)) {
        await _localData.enqueueOperation(
          userId: userId,
          method: 'DELETE',
          endpoint: '/locations/$id',
          payload: {},
        );
        return;
      }
      throw Exception(_extractErrorMessage(e));
    }
  }

  @override
  Future<List<Book>> getBooks(String colId) async {
    final userId = await _getUserId();
    try {
      final response = await apiClient.dio.get('/collections/$colId/books');
      final rawList = response.data['data'] as List;
      await _localData.cacheData(
        id: 'books_$colId',
        userId: userId,
        data: {'list': rawList},
      );
      return rawList
          .map((e) => Book.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (ApiClient.isOfflineException(e)) {
        final cached = await _localData.getCachedData(userId);
        try {
          final cacheEntry = cached.firstWhere((c) => c.containsKey('list'));
          final list = cacheEntry['list'] as List;
          return list
              .map((e) => Book.fromJson(e as Map<String, dynamic>))
              .toList();
        } catch (_) {
          return [];
        }
      }
      throw Exception(_extractErrorMessage(e));
    }
  }

  @override
  Future<Book?> findBookInCollection(String colId, String isbn) async {
    try {
      final response = await apiClient.dio.get(
        '/collections/$colId/books/search?isbn=$isbn',
      );
      if (response.data['data'] != null) {
        return Book.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (e) {
      if (ApiClient.isOfflineException(e)) {
        final cachedBooks = await getBooks(colId);
        try {
          return cachedBooks.firstWhere((book) => book.isbn == isbn);
        } catch (_) {
          return null;
        }
      }
      throw Exception(_extractErrorMessage(e));
    }
  }

  @override
  Future<Book> lookupBook(String isbn) async {
    try {
      final response = await apiClient.dio.get('/books/lookup/$isbn');
      return Book.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      if (ApiClient.isOfflineException(e)) {
        throw Exception(
          'A busca automática de livros via ISBN não está disponível offline.',
        );
      }
      throw Exception(_extractErrorMessage(e));
    }
  }

  @override
  Future<Book> addBookToCollection(
    String colId,
    String? isbn, {
    String? title,
    String? author,
  }) async {
    final userId = await _getUserId();
    final payload = {
      if (isbn != null) 'isbn': isbn,
      if (title != null) 'title': title,
      if (author != null) 'author': author,
    };

    try {
      final response = await apiClient.dio.post(
        '/collections/$colId/books',
        data: payload,
      );
      return Book.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      if (ApiClient.isOfflineException(e)) {
        final tempId = const Uuid().v4();
        await _localData.enqueueOperation(
          userId: userId,
          method: 'POST',
          endpoint: '/collections/$colId/books',
          payload: payload,
        );
        return Book(
          id: tempId,
          isbn: isbn ?? '',
          title: title ?? 'Título desconhecido',
          author: author ?? 'Autor desconhecido',
          collectionId: colId,
          isPending: true,
        );
      }
      throw Exception(_extractErrorMessage(e));
    }
  }

  @override
  Future<Book> updateBook(
    String colId,
    Book book, {
    String? title,
    String? author,
  }) async {
    final userId = await _getUserId();
    final payload = {
      if (title != null) 'title': title,
      if (author != null) 'author': author,
    };

    try {
      final response = await apiClient.dio.put(
        '/books/${book.id}',
        data: payload,
      );
      return Book.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      if (ApiClient.isOfflineException(e)) {
        await _localData.enqueueOperation(
          userId: userId,
          method: 'PUT',
          endpoint: '/books/${book.id}',
          payload: payload,
        );
        return Book(
          id: book.id,
          isbn: book.isbn,
          title: title ?? book.title,
          author: author ?? book.author,
          collectionId: colId,
          isPending: true,
        );
      }
      throw Exception(_extractErrorMessage(e));
    }
  }

  @override
  Future<void> removeBook(String colId, Book book) async {
    final userId = await _getUserId();
    try {
      await apiClient.dio.delete('/books/${book.id}');
    } on DioException catch (e) {
      if (ApiClient.isOfflineException(e)) {
        await _localData.enqueueOperation(
          userId: userId,
          method: 'DELETE',
          endpoint: '/books/${book.id}',
          payload: {},
        );
        return;
      }
      throw Exception(_extractErrorMessage(e));
    }
  }
}
