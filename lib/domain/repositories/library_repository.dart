import '../entities/models.dart';

abstract class LibraryRepository {
  // Inicializa os dados (usado apenas no mock local)
  Future<void> initMockData();

  // Coleções
  Future<List<Collection>> getCollections();
  Future<Collection> createCollection(String name);
  Future<Collection> joinCollection(String code);

  // Localizações
  Future<List<Location>> getLocations(String collectionId);
  Future<Location> createLocation(String collectionId, String name);

  // Livros
  Future<List<Book>> getBooks(String collectionId);
  Future<Book?> getBookDetailsFromMockBackend(
    String isbn,
  ); // Finge ir no Google Books
  Future<Book?> findBookInCollection(String collectionId, String isbn);
  Future<void> addBookToCollection(Book book);
  Future<void> removeBook(String bookId);
}
