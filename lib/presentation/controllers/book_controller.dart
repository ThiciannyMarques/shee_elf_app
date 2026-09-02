import 'package:flutter/material.dart';

import '../../core/utils/app_state.dart';
import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';

class BookController extends ChangeNotifier {
  final BookRepository _bookRepository;

  // Removido o scanner service daqui, ele só precisa do repositório agora
  BookController(this._bookRepository);

  AppState<Book> state = StateInitial<Book>();

  // Agora ele recebe o ISBN pronto que veio da UI
  Future<void> addBookByIsbn(String collectionId, String isbn) async {
    state = StateLoading<Book>();
    notifyListeners();

    try {
      // 1. Consulta o backend (Mock)
      final book = await _bookRepository.getBookByIsbn(isbn);

      // 2. Cadastra na coleção local
      await _bookRepository.addBookToCollection(collectionId, book);

      // 3. Sucesso!
      state = StateSuccess<Book>(book);
    } catch (e) {
      state = StateError<Book>('Erro ao cadastrar: ${e.toString()}');
    }

    notifyListeners();
  }

  void resetState() {
    state = StateInitial<Book>();
    notifyListeners();
  }
}
