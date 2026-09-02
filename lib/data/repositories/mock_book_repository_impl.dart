import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';

class MockBookRepositoryImpl implements BookRepository {
  // Banco de dados em memória para testes
  final List<Book> _mockDatabase = [];

  @override
  Future<Book> getBookByIsbn(String isbn) async {
    await Future.delayed(const Duration(seconds: 2)); // Simula latência de rede

    // Simulando retorno do Google Books via backend
    if (isbn.isEmpty) throw Exception('ISBN inválido');

    return Book(
      id: 'book_001',
      isbn: isbn,
      title: 'One Piece - Volume 1: Romance Dawn',
      author: 'Eiichiro Oda',
    );
  }

  @override
  Future<void> addBookToCollection(String collectionId, Book book) async {
    await Future.delayed(const Duration(seconds: 1));
    if (_mockDatabase.any((b) => b.isbn == book.isbn)) {
      throw Exception('Livro já existe nesta coleção.');
    }
    _mockDatabase.add(book);
  }

  @override
  Future<bool> checkBookInCollection(String collectionId, String isbn) async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockDatabase.any((b) => b.isbn == isbn);
  }

  @override
  Future<void> removeBookFromCollection(
    String collectionId,
    String bookId,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    _mockDatabase.removeWhere((b) => b.id == bookId);
  }
}
