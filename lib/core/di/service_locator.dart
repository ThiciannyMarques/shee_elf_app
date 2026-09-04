import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/localization/app_locale_controller.dart';
import '../../core/network/api_client.dart';
import '../../data/repositories/api_auth_repository_impl.dart';
import '../../data/repositories/api_library_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/library_repository.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../../presentation/controllers/library_controller.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  final preferences = await SharedPreferences.getInstance();
  const secureStorage = FlutterSecureStorage();
  final apiClient = ApiClient(secureStorage);

  getIt.registerLazySingleton<AuthRepository>(
    () => ApiAuthRepositoryImpl(apiClient, secureStorage),
  );

  getIt.registerLazySingleton<LibraryRepository>(
    () => ApiLibraryRepository(apiClient, preferences),
  );
  getIt.registerSingleton(AppLocaleController(preferences));

  getIt.registerLazySingleton(() => AuthController(getIt()));
  getIt.registerLazySingleton(() => LibraryController(getIt()));
}
