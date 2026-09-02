import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final String id;
  final String isbn;
  final String title;
  final String author;

  const Book({
    required this.id,
    required this.isbn,
    required this.title,
    required this.author,
  });

  @override
  List<Object?> get props => [id, isbn, title, author];
}
