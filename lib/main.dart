import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/service_locator.dart';

export 'app.dart' show MyApp;
export 'core/di/service_locator.dart' show getIt, setupLocator;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await setupLocator();
  runApp(const MyApp());
}
