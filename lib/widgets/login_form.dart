import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../home/home_shell.dart';
import '../register/register_page.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? error;

  void _login() async {
    final viewModel = Provider.of<AuthViewModel>(context, listen: false);
    final result = await viewModel.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    if (result != null) {
      setState(() => error = result);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomeShell()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Login", style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email')),
        TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true),
        if (error != null) ...[
          const SizedBox(height: 8),
          Text(error!, style: const TextStyle(color: Colors.red)),
        ],
        const SizedBox(height: 16),
        ElevatedButton(onPressed: _login, child: const Text("Login")),
        TextButton(
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const RegisterPage()),
          ),
          child: const Text("Don't have an account? Register"),
        ),
      ],
    );
  }
}
