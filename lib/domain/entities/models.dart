import 'package:equatable/equatable.dart';

class Collection extends Equatable {
  final String id;
  final String name;
  final String joinCode;

  const Collection({
    required this.id,
    required this.name,
    required this.joinCode,
  });
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
  final String isbn;
  final String title;
  final String author;
  final String collectionId;
  final String locationId;

  const Book({
    required this.id,
    required this.isbn,
    required this.title,
    required this.author,
    required this.collectionId,
    required this.locationId,
  });
  @override
  List<Object?> get props => [
    id,
    isbn,
    title,
    author,
    collectionId,
    locationId,
  ];
}
