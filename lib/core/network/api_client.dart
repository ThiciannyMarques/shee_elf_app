import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  ApiClient(this.secureStorage)
    : dio = Dio(
        BaseOptions(
          baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://127.0.0.1:3000',
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          responseType: ResponseType.json,
        ),
      ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await secureStorage.read(key: 'jwt_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await secureStorage.delete(key: 'jwt_token');
            await secureStorage.delete(key: 'current_user_email');
            await secureStorage.delete(key: 'current_user_name');
          }
          return handler.next(error);
        },
      ),
    );
  }
}
