import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/network/api_client.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class ApiAuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;
  final FlutterSecureStorage secureStorage;

  ApiAuthRepositoryImpl(this.apiClient, this.secureStorage);

  Future<void> _saveUser(User user) async {
    await secureStorage.write(key: 'current_user_email', value: user.email);
    await secureStorage.write(key: 'current_user_name', value: user.name);
  }

  bool _isOffline(DioException exception) =>
      exception.type == DioExceptionType.connectionError ||
      exception.type == DioExceptionType.connectionTimeout ||
      exception.type == DioExceptionType.receiveTimeout ||
      exception.type == DioExceptionType.sendTimeout;

  String _extractErrorMessage(DioException e) {
    if (e.response?.data != null) {
      if (e.response!.data is Map<String, dynamic>) {
        final responseData = e.response!.data as Map<String, dynamic>;
        if (responseData.containsKey('error')) {
          return responseData['error'].toString();
        }
      }
      return 'API: ${e.response!.data}';
    }
    return e.message ?? 'Erro de conexão HTTP';
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await apiClient.dio.post(
        '/users/sign-in',
        data: {'email': email, 'password': password},
      );

      final responseData = response.data as Map<String, dynamic>;
      final dataObj = responseData['data'] as Map<String, dynamic>;

      final token = dataObj['token'] as String;
      final userJson = dataObj['user'] as Map<String, dynamic>;

      await secureStorage.write(key: 'jwt_token', value: token);

      final user = User.fromJson(userJson);
      await _saveUser(user);
      return user;
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e));
    }
  }

  @override
  Future<User> register(String name, String email, String password) async {
    try {
      final response = await apiClient.dio.post(
        '/users/sign-up',
        data: {'name': name, 'email': email, 'password': password},
      );

      final responseData = response.data as Map<String, dynamic>;
      final dataObj = responseData['data'] as Map<String, dynamic>;

      final token = dataObj['token'] as String;
      final userJson = dataObj['user'] as Map<String, dynamic>;

      await secureStorage.write(key: 'jwt_token', value: token);

      final user = User.fromJson(userJson);
      await _saveUser(user);
      return user;
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e));
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    final token = await secureStorage.read(key: 'jwt_token');
    if (token == null) return null;

    try {
      final response = await apiClient.dio.get('/users/me');

      final responseData = response.data as Map<String, dynamic>;
      final dataObj = responseData['data'] as Map<String, dynamic>;
      final userJson = dataObj['user'] as Map<String, dynamic>;

      return User.fromJson(userJson);
    } on DioException catch (exception) {
      if (_isOffline(exception)) {
        final email = await secureStorage.read(key: 'current_user_email');
        final name = await secureStorage.read(key: 'current_user_name');
        if (email != null && name != null) {
          return User(id: email, name: name, email: email);
        }
      }
      await secureStorage.delete(key: 'jwt_token');
      return null;
    }
  }

  @override
  Future<void> logout() async {
    await secureStorage.delete(key: 'jwt_token');
    await secureStorage.delete(key: 'current_user_email');
    await secureStorage.delete(key: 'current_user_name');
  }
}
