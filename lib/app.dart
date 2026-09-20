import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/di/service_locator.dart';
import 'core/localization/app_locale_controller.dart';
import 'core/theme/app_theme.dart';
import 'presentation/pages/auth_pages.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: getIt<AppLocaleController>(),
      builder: (context, child) {
        final locale = getIt<AppLocaleController>().locale;
        return MaterialApp(
          title: locale.languageCode == 'en'
              ? 'My Library'
              : 'Minha Biblioteca',
          locale: locale,
          supportedLocales: const [Locale('pt'), Locale('en')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          home: const SplashPage(),
        );
      },
    );
  }
}
