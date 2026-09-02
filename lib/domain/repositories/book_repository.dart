import '../entities/book.dart';

// O contrato. A UI só vai conversar com isso.
abstract class BookRepository {
  Future<Book> getBookByIsbn(String isbn);
  Future<void> addBookToCollection(String collectionId, Book book);
  Future<bool> checkBookInCollection(String collectionId, String isbn);
  Future<void> removeBookFromCollection(String collectionId, String bookId);
}
