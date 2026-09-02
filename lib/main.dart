import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'domain/repositories/book_repository.dart';
import 'data/repositories/mock_book_repository_impl.dart';
import 'presentation/controllers/book_controller.dart';
import 'presentation/pages/add_book_page.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<BookRepository>(() => MockBookRepositoryImpl());

  getIt.registerFactory(() => BookController(getIt()));
}

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MVP Biblioteca',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const AddBookPage(collectionId: 'col_123'),
    );
  }
}
