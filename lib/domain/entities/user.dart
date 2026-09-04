import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;

  const User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    final email = json['email'] as String;
    return User(
      id: (json['id'] as String?) ?? email,
      name: json['name'] as String,
      email: email,
    );
  }

  @override
  List<Object?> get props => [id, name, email];
}
