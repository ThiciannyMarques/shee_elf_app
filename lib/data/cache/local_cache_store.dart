import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalCacheStore {
  final SharedPreferences _preferences;
  String? _email;

  LocalCacheStore(this._preferences);

  void setSession(String? email) => _email = email;

  String? get _prefix =>
      _email == null ? null : 'cache:${Uri.encodeComponent(_email!)}:';

  String? _key(String suffix) {
    final prefix = _prefix;
    return prefix == null ? null : '$prefix$suffix';
  }

  Future<void> writeList(
    String suffix,
    List<Map<String, Object?>> values,
  ) async {
    final key = _key(suffix);
    if (key == null) return;
    await _preferences.setString(key, jsonEncode(values));
  }

  List<Map<String, Object?>> readList(String suffix) {
    final key = _key(suffix);
    if (key == null) return [];
    final value = _preferences.getString(key);
    if (value == null) return [];
    final decoded = _decode(value);
    if (decoded is! List) return [];
    return decoded
        .whereType<Map<String, dynamic>>()
        .map(Map<String, Object?>.from)
        .toList();
  }

  Object? _decode(String value) {
    try {
      return jsonDecode(value);
    } on FormatException {
      return null;
    }
  }
}
