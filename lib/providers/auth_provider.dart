import 'dart:async';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../models/app_category.dart';
import '../models/password_entry.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final StorageService _storageService;

  bool _isAuthenticated = false;
  bool _isFirstLaunch = true;
  Timer? _inactivityTimer;

  bool get isAuthenticated => _isAuthenticated;
  bool get isFirstLaunch => _isFirstLaunch;

  AuthProvider(this._authService, this._storageService) {
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    _isFirstLaunch = await _authService.isFirstLaunch();
    notifyListeners();
  }

  Future<void> setMasterPassword(String password) async {
    await _authService.setMasterPassword(password);
    _isFirstLaunch = false;
    _isAuthenticated = true;
    _startInactivityTimer();
    notifyListeners();
  }

  Future<bool> login(String password) async {
    final success = await _authService.login(password);
    if (success) {
      _isAuthenticated = true;
      _startInactivityTimer();
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _authService.logout();
    _isAuthenticated = false;
    _cancelInactivityTimer();
    notifyListeners();
  }

  Future<bool> changeMasterPassword(
    String oldPassword,
    String newPassword,
  ) async {
    if (!await _authService.login(oldPassword)) {
      return false; // Old password incorrect
    }

    final Map<String, List<PasswordEntry>> allData = {};
    for (var cat in AppCategory.values) {
      allData[cat.id] = await _storageService.loadEntries(cat.id);
    }

    await _authService.setMasterPassword(newPassword);

    for (var cat in AppCategory.values) {
      await _storageService.saveEntries(cat.id, allData[cat.id]!);
    }

    userActivityDetected();
    return true;
  }

  void userActivityDetected() {
    if (_isAuthenticated) {
      _startInactivityTimer();
    }
  }

  void _startInactivityTimer() {
    _cancelInactivityTimer();
    _inactivityTimer = Timer(const Duration(minutes: 5), () {
      logout();
    });
  }

  void _cancelInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = null;
  }
}
