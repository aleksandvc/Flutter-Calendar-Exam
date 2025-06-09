import 'package:flutter/material.dart';
import 'package:flutter_calendar_exam/home/home_shell.dart';
import 'package:flutter_calendar_exam/login/login_page.dart';
import 'package:flutter_calendar_exam/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (loggedIn) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      await authViewModel.loadUserState();
    }

    setState(() {
      _isLoggedIn = loggedIn;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return _isLoggedIn ? const HomeShell() : const LoginPage();
  }
}
