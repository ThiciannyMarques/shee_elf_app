import 'package:flutter/material.dart';

import '../../core/utils/app_state.dart';
import '../../domain/entities/models.dart';
import '../../domain/repositories/library_repository.dart';

// Classe auxiliar para o resultado da consulta
class ConsultResult {
  final bool isFound;
  final Book? book;
  final Location? location;

  ConsultResult({required this.isFound, this.book, this.location});
}

class LibraryController extends ChangeNotifier {
  final LibraryRepository _repo;

  LibraryController(this._repo);

  // Estados Globais
  Collection? currentCollection;
  List<Collection> myCollections = [];
  List<Location> currentLocations = [];
  List<Book> currentBooks = [];

  // Estados locais
  AppState<void> screenState = StateInitial();
  AppState<Book> bookFlowState = StateInitial();
  AppState<ConsultResult> consultFlowState =
      StateInitial(); // NOVO: Estado da consulta

  void clearSession() {
    currentCollection = null;
    myCollections = [];
    currentLocations = [];
    currentBooks = [];
    screenState = StateInitial();
    bookFlowState = StateInitial();
    consultFlowState = StateInitial();
    notifyListeners();
  }

  Future<void> initializeApp() async {
    screenState = StateLoading();
    notifyListeners();

    try {
      final selectedCollectionId = currentCollection?.id;
      myCollections = await _repo.getCollections();
      if (myCollections.isNotEmpty) {
        final selected = myCollections.where(
          (collection) => collection.id == selectedCollectionId,
        );
        await selectCollection(
          selected.isEmpty ? myCollections.first : selected.first,
        );
      } else {
        screenState = StateEmpty();
        notifyListeners();
      }
    } catch (error) {
      screenState = StateError<void>(
        'Não foi possível carregar as coleções: $error',
      );
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

  // --- FUNÇÕES DOS MODAIS ---

  Future<void> createNewCollection(String name) async {
    screenState = StateLoading();
    notifyListeners();
    try {
      final newCol = await _repo.createCollection(name);
      myCollections.add(newCol);
      await selectCollection(newCol);
    } catch (e) {
      screenState = StateError<void>('Não foi possível criar a coleção: $e');
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateCurrentCollection(String name) async {
    final collection = currentCollection;
    if (collection == null) return;
    screenState = StateLoading();
    notifyListeners();
    try {
      final updated = await _repo.updateCollection(collection.id, name);
      final index = myCollections.indexOf(collection);
      if (index >= 0) myCollections[index] = updated;
      currentCollection = updated;
      screenState = StateSuccess(null);
    } catch (error) {
      screenState = StateError<void>(
        'Não foi possível atualizar a coleção: $error',
      );
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteCurrentCollection() async {
    final collection = currentCollection;
    if (collection == null) return;
    screenState = StateLoading();
    notifyListeners();
    try {
      await _repo.deleteCollection(collection.id);
      myCollections.removeWhere((item) => item.id == collection.id);
      currentCollection = null;
      currentLocations = [];
      currentBooks = [];
      screenState = StateEmpty();
    } catch (error) {
      screenState = StateError<void>(
        'Não foi possível excluir a coleção: $error',
      );
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> createNewLocation(String name) async {
    if (currentCollection == null) return;
    screenState = StateLoading();
    notifyListeners();
    try {
      final newLoc = await _repo.createLocation(currentCollection!.id, name);
      currentLocations.add(newLoc);
      screenState = StateSuccess(null);
      notifyListeners();
    } catch (e) {
      screenState = StateError<void>(
        'Não foi possível criar a localização: $e',
      );
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateLocation(Location location, String name) async {
    try {
      final updated = await _repo.updateLocation(location.id, name);
      final index = currentLocations.indexOf(location);
      if (index >= 0) currentLocations[index] = updated;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteLocation(Location location) async {
    await _repo.deleteLocation(location.id);
    currentLocations.removeWhere((item) => item.id == location.id);
    notifyListeners();
  }

  // --- NOVO: FUNÇÕES DE CONSULTA ---

  Future<void> consultBookByIsbn(String isbn) async {
    if (currentCollection == null) return;

    consultFlowState = StateLoading<ConsultResult>();
    notifyListeners();

    try {
      final book = await _repo.findBookInCollection(
        currentCollection!.id,
        isbn,
      );

      if (book != null) {
        consultFlowState = StateSuccess<ConsultResult>(
          ConsultResult(isFound: true, book: book),
        );
      } else {
        // Não encontrou
        consultFlowState = StateSuccess<ConsultResult>(
          ConsultResult(isFound: false),
        );
      }
    } catch (e) {
      consultFlowState = StateError<ConsultResult>('Erro ao consultar: $e');
    }
    notifyListeners();
  }

  void resetConsultFlow() {
    consultFlowState = StateInitial();
    notifyListeners();
  }

  // --- FUNÇÕES DE CADASTRO DE LIVROS ---

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
      final draftBook = await _repo.lookupBook(isbn);
      bookFlowState = StateSuccess<Book>(draftBook);
    } catch (e) {
      bookFlowState = StateError<Book>(e.toString());
    }
    notifyListeners();
  }

  Future<void> confirmAddBook(Book draftBook) async {
    bookFlowState = StateLoading<Book>();
    notifyListeners();
    try {
      await _repo.addBookToCollection(
        currentCollection!.id,
        draftBook.isbn,
        title: draftBook.title,
        author: draftBook.author,
      );
      await selectCollection(currentCollection!);
      bookFlowState = StateComplete<Book>();
    } catch (e) {
      bookFlowState = StateError<Book>('Erro ao salvar livro: $e');
    }
    notifyListeners();
  }

  Future<void> addManualBook(
    String title,
    String author, {
    String? isbn,
  }) async {
    if (currentCollection == null) return;
    bookFlowState = StateLoading<Book>();
    notifyListeners();
    try {
      final book = await _repo.addBookToCollection(
        currentCollection!.id,
        isbn,
        title: title,
        author: author,
      );
      await selectCollection(currentCollection!);
      bookFlowState = StateComplete<Book>();
      notifyListeners();
      return;
    } catch (error) {
      bookFlowState = StateError<Book>('Erro ao salvar livro: $error');
      notifyListeners();
    }
  }

  Future<void> updateBook(Book book, String title, String author) async {
    final collection = currentCollection;
    if (collection == null) return;
    final updated = await _repo.updateBook(
      collection.id,
      book,
      title: title,
      author: author,
    );
    final index = currentBooks.indexOf(book);
    if (index >= 0) currentBooks[index] = updated;
    notifyListeners();
  }

  Future<void> removeBook(String bookId) async {
    if (currentCollection == null) return;
    final book = currentBooks.firstWhere((item) => item.id == bookId);
    await _repo.removeBook(currentCollection!.id, book);
    await selectCollection(currentCollection!);
  }

  void resetBookFlow() {
    bookFlowState = StateInitial();
    notifyListeners();
  }
}
