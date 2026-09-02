import 'package:flutter/material.dart';

import '../../core/utils/app_state.dart';
import '../../domain/entities/models.dart';
import '../../domain/repositories/library_repository.dart';

class LibraryController extends ChangeNotifier {
  final LibraryRepository _repo;

  LibraryController(this._repo); // Removido o ScannerService

  // Estados Globais
  Collection? currentCollection;
  List<Collection> myCollections = [];
  List<Location> currentLocations = [];
  List<Book> currentBooks = [];

  // Estados locais
  AppState<void> screenState = StateInitial();
  AppState<Book> bookFlowState = StateInitial();

  Future<void> initializeApp() async {
    screenState = StateLoading();
    notifyListeners();

    await _repo.initMockData();
    myCollections = await _repo.getCollections();

    if (myCollections.isNotEmpty) {
      await selectCollection(myCollections.first);
    } else {
      screenState = StateEmpty();
      notifyListeners();
    }
  }

  Future<void> selectCollection(Collection col) async {
    screenState = StateLoading();
    notifyListeners();

    currentCollection = col;
    currentLocations = await _repo.getLocations(col.id);
    currentBooks = await _repo.getBooks(col.id);

    screenState = StateSuccess(null);
    notifyListeners();
  }

  // Recebe o ISBN real da câmera
  Future<void> scanAndDraftBook(String isbn) async {
    if (currentCollection == null) return;

    bookFlowState = StateLoading<Book>();
    notifyListeners();

    try {
      final existingBook = await _repo.findBookInCollection(
        currentCollection!.id,
        isbn,
      );
      if (existingBook != null) {
        bookFlowState = StateError<Book>('Este livro já está na sua coleção!');
        notifyListeners();
        return;
      }

      // Consulta o mock passando o ISBN real que a câmera leu
      final draftBook = await _repo.getBookDetailsFromMockBackend(isbn);
      bookFlowState = StateSuccess<Book>(draftBook!);
    } catch (e) {
      bookFlowState = StateError<Book>(e.toString());
    }
    notifyListeners();
  }

  Future<void> confirmAddBook(Book draftBook, String locationId) async {
    bookFlowState = StateLoading<Book>();
    notifyListeners();

    try {
      final finalBook = Book(
        id: '',
        isbn: draftBook.isbn,
        title: draftBook.title,
        author: draftBook.author,
        collectionId: currentCollection!.id,
        locationId: locationId,
      );
      await _repo.addBookToCollection(finalBook);
      await selectCollection(currentCollection!);

      bookFlowState = StateComplete<Book>();
    } catch (e) {
      bookFlowState = StateError<Book>('Erro ao salvar livro.');
    }
    notifyListeners();
  }

  Future<void> removeBook(String bookId) async {
    await _repo.removeBook(bookId);
    await selectCollection(currentCollection!);
  }

  void resetBookFlow() {
    bookFlowState = StateInitial();
    notifyListeners();
  }
}
