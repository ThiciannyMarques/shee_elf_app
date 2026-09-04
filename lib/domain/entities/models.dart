import 'package:equatable/equatable.dart';

class Collection extends Equatable {
  final String id;
  final String name;
  final String? joinCode;

  const Collection({required this.id, required this.name, this.joinCode});
  @override
  List<Object?> get props => [id, name, joinCode];
}

class Location extends Equatable {
  final String id;
  final String collectionId;
  final String name;

  const Location({
    required this.id,
    required this.collectionId,
    required this.name,
  });
  @override
  List<Object?> get props => [id, collectionId, name];
}

class Book extends Equatable {
  final String id;
  final String? localId;
  final bool isPending;
  final String? isbn;
  final String title;
  final String author;
  final String collectionId;

  const Book({
    required this.id,
    this.localId,
    this.isPending = false,
    required this.isbn,
    required this.title,
    required this.author,
    required this.collectionId,
  });
  @override
  List<Object?> get props => [
    id,
    localId,
    isPending,
    isbn,
    title,
    author,
    collectionId,
  ];
}
