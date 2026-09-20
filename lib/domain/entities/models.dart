import 'package:equatable/equatable.dart';

class Collection extends Equatable {
  final String id;
  final String name;
  final String? joinCode;

  const Collection({required this.id, required this.name, this.joinCode});

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['id'] as String,
      name: json['name'] as String,
      joinCode: json['joinCode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'joinCode': joinCode};
  }

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

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] as String,
      collectionId: json['collectionId'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'collectionId': collectionId, 'name': name};
  }

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

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      localId: json['localId'] as String?,
      isPending: json['isPending'] as bool? ?? false,
      isbn: json['isbn'] as String?,
      title: json['title'] as String,
      author: json['author'] as String,
      collectionId: json['collectionId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'localId': localId,
      'isPending': isPending,
      'isbn': isbn,
      'title': title,
      'author': author,
      'collectionId': collectionId,
    };
  }

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
