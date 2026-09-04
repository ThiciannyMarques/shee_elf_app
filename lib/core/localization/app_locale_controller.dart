import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLocaleController extends ChangeNotifier {
  static const _storageKey = 'preferred_locale';
  final SharedPreferences _preferences;
  Locale _locale;

  AppLocaleController(this._preferences)
    : _locale = Locale(_preferences.getString(_storageKey) ?? 'pt');

  Locale get locale => _locale;

  Future<void> setLocale(Locale locale) async {
    if (locale == _locale) return;
    _locale = locale;
    await _preferences.setString(_storageKey, locale.languageCode);
    notifyListeners();
  }
}

class AppLocalizations {
  final Locale locale;

  const AppLocalizations(this.locale);

  static const delegate = _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  bool get isEnglish => locale.languageCode == 'en';

  String get appName => isEnglish ? 'My Library' : 'Minha Biblioteca';
  String get logout => isEnglish ? 'Sign out' : 'Sair';
  String get retry => isEnglish ? 'Try again' : 'Tentar novamente';
  String get language => isEnglish ? 'Language' : 'Idioma';
  String get portuguese => isEnglish ? 'Portuguese' : 'Português';
  String get english => isEnglish ? 'English' : 'Inglês';
  String get addBook => isEnglish ? 'Add book' : 'Cadastrar livro';
  String get manualBook =>
      isEnglish ? 'Add without ISBN' : 'Cadastrar sem ISBN';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['pt', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
