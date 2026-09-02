import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/models.dart';
import '../../domain/repositories/library_repository.dart';

class LocalLibraryRepositoryImpl implements LibraryRepository {
  final SharedPreferences prefs;
  final _uuid = const Uuid();

  LocalLibraryRepositoryImpl(this.prefs);

  // --- Helpers para ler e salvar JSON ---
  List<dynamic> _readList(String key) {
    final str = prefs.getString(key);
    return str != null ? jsonDecode(str) : [];
  }

  Future<void> _saveList(String key, List<dynamic> list) async {
    await prefs.setString(key, jsonEncode(list));
  }

  @override
  Future<void> initMockData() async {
    // Se for o primeiro acesso, cria dados iniciais (Seed)
    if (_readList('collections').isEmpty) {
      final col = {
        'id': 'col_1',
        'name': 'Minha Biblioteca',
        'joinCode': '123456',
      };
      final loc = {
        'id': 'loc_1',
        'collectionId': 'col_1',
        'name': 'Estante da Sala',
      };
      final book = {
        'id': 'book_1',
        'isbn': '9780001',
        'title': 'Livro Semente',
        'author': 'Autor Semente',
        'collectionId': 'col_1',
        'locationId': 'loc_1',
      };

      await _saveList('collections', [col]);
      await _saveList('locations', [loc]);
      await _saveList('books', [book]);
    }
  }

  // --- Coleções ---
  @override
  Future<List<Collection>> getCollections() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final data = _readList('collections');
    return data
        .map(
          (e) =>
              Collection(id: e['id'], name: e['name'], joinCode: e['joinCode']),
        )
        .toList();
  }

  @override
  Future<Collection> createCollection(String name) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final collections = _readList('collections');
    final newCol = {
      'id': _uuid.v4(),
      'name': name,
      'joinCode': _uuid.v4().substring(0, 6),
    };
    collections.add(newCol);
    await _saveList('collections', collections);
    return Collection(
      id: newCol['id']!,
      name: newCol['name']!,
      joinCode: newCol['joinCode']!,
    );
  }

  @override
  Future<Collection> joinCollection(String code) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final collections = _readList('collections');
    final found = collections.firstWhere(
      (c) => c['joinCode'] == code,
      orElse: () => null,
    );
    if (found == null) throw Exception('Código de coleção inválido.');
    return Collection(
      id: found['id'],
      name: found['name'],
      joinCode: found['joinCode'],
    );
  }

  // --- Localizações ---
  @override
  Future<List<Location>> getLocations(String collectionId) async {
    final data = _readList('locations')
        .where((e) => e['collectionId'] == collectionId);
    return data
        .map(
          (e) => Location(
            id: e['id'],
            collectionId: e['collectionId'],
            name: e['name'],
          ),
        )
        .toList();
  }

  @override
  Future<Location> createLocation(String collectionId, String name) async {
    final locs = _readList('locations');
    final newLoc = {
      'id': _uuid.v4(),
      'collectionId': collectionId,
      'name': name,
    };
    locs.add(newLoc);
    await _saveList('locations', locs);
    return Location(
      id: newLoc['id']!,
      collectionId: newLoc['collectionId']!,
      name: newLoc['name']!,
    );
  }

  // --- Livros ---
  @override
  Future<Book?> getBookDetailsFromMockBackend(String isbn) async {
    await Future.delayed(
      const Duration(seconds: 1),
    ); // Finge chamada ao Google Books
    if (isbn == '978_INVALIDO')
      throw Exception('ISBN não encontrado no banco global.');

    // Retorna um "Draft" (Livro sem ID de banco ainda)
    return Book(
      id: '',
      isbn: isbn,
      title: 'Livro Exemplo (Mock API)',
      author: 'Autor Mockado',
      collectionId: '',
      locationId: '',
    );
  }

  @override
  Future<Book?> findBookInCollection(String collectionId, String isbn) async {
    final books = _readList('books')
        .where((e) => e['collectionId'] == collectionId);
    final found = books.firstWhere(
      (e) => e['isbn'] == isbn,
      orElse: () => null,
    );
    if (found == null) return null;
    return Book(
      id: found['id'],
      isbn: found['isbn'],
      title: found['title'],
      author: found['author'],
      collectionId: found['collectionId'],
      locationId: found['locationId'],
    );
  }

  @override
  Future<List<Book>> getBooks(String collectionId) async {
    final data = _readList('books')
        .where((e) => e['collectionId'] == collectionId);
    return data
        .map(
          (e) => Book(
            id: e['id'],
            isbn: e['isbn'],
            title: e['title'],
            author: e['author'],
            collectionId: e['collectionId'],
            locationId: e['locationId'],
          ),
        )
        .toList();
  }

  @override
  Future<void> addBookToCollection(Book book) async {
    final books = _readList('books');
    books.add({
      'id': _uuid.v4(),
      'isbn': book.isbn,
      'title': book.title,
      'author': book.author,
      'collectionId': book.collectionId,
      'locationId': book.locationId,
    });
    await _saveList('books', books);
  }

  @override
  Future<void> removeBook(String bookId) async {
    final books = _readList('books');
    books.removeWhere((e) => e['id'] == bookId);
    await _saveList('books', books);
  }
}
