import 'package:flutter/material.dart';

import '../core/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<String?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    setLoading(true);

    final result = await _authService.registerUser(
      name: name,
      email: email,
      password: password,
    );

    setLoading(false);

    return result;
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    setLoading(true);

    final result = await _authService.loginUser(
      email: email,
      password: password,
    );

    setLoading(false);

    return result;
  }

  Future<String?> forgotPassword(String email) async {
    setLoading(true);

    final result = await _authService.forgotPassword(email);

    setLoading(false);

    return result;
  }

  Future<void> logout() async {
    await _authService.logout();
  }

  Future<void> updateProfile({
    required String uid,
    required String name,
  }) async {
    setLoading(true);

    await _authService.updateProfile(uid: uid, name: name);

    setLoading(false);
  }
}
