import 'package:flutter/material.dart';

import '../../core/utils/app_state.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _repo;

  AuthController(this._repo);

  AppState<User> authState = StateInitial();

  Future<void> checkAuth() async {
    authState = StateLoading();
    notifyListeners();

    final user = await _repo.getCurrentUser();
    if (user != null) {
      authState = StateSuccess(user);
    } else {
      authState = StateEmpty();
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    authState = StateLoading();
    notifyListeners();
    try {
      final user = await _repo.login(email, password);
      authState = StateSuccess(user);
      notifyListeners();
      return true;
    } catch (e) {
      authState = StateError(e.toString().replaceAll('Exception: ', ''));
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    authState = StateLoading();
    notifyListeners();
    try {
      final user = await _repo.register(name, email, password);
      authState = StateSuccess(user);
      notifyListeners();
      return true;
    } catch (e) {
      authState = StateError(e.toString().replaceAll('Exception: ', ''));
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    authState = StateEmpty();
    notifyListeners();
  }
}
