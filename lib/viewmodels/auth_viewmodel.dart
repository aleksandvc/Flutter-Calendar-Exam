import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel with ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;

  UserModel? get user => _user;

  AuthViewModel() {
    loadUserState();
  }

  Future<void> loadUserState() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (loggedIn) {
      _authService.user.first.then((userModel) {
        _user = userModel;
        notifyListeners();
      });
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      _user = await _authService.loginWithEmail(email, password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
    
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> register(String email, String password, String name) async {
    try {
      _user = await _authService.registerWithEmail(email, password, name);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  void logout() async {
    await _authService.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    _user = null;
    notifyListeners();
  }
}
