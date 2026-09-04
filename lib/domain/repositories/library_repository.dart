import '../entities/models.dart';

abstract class LibraryRepository {
  void setSession(String? email);
  Future<List<Collection>> getCollections();
  Future<Collection> createCollection(String name);
  Future<Collection> updateCollection(String collectionId, String name);
  Future<void> deleteCollection(String collectionId);

  Future<List<Location>> getLocations(String collectionId);
  Future<Location> createLocation(String collectionId, String name);
  Future<Location> updateLocation(String locationId, String name);
  Future<void> deleteLocation(String locationId);

  Future<List<Book>> getBooks(String collectionId);
  Future<Book> lookupBook(String isbn);
  Future<Book?> findBookInCollection(String collectionId, String isbn);
  Future<Book> addBookToCollection(
    String collectionId,
    String? isbn, {
    String? title,
    String? author,
  });
  Future<Book> updateBook(
    String collectionId,
    Book book, {
    String? title,
    String? author,
  });
  Future<void> removeBook(String collectionId, Book book);
}
