import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/service_locator.dart';
import 'data/datasources/local_data_source.dart';
import 'core/network/sync_manager.dart';

export 'app.dart' show MyApp;
export 'core/di/service_locator.dart' show getIt, setupLocator;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await setupLocator();

  await getIt<LocalDataSource>().initDb();

  getIt<SyncManager>().startListening();

  runApp(const MyApp());
}
