import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../login/login_page.dart';
import '../home/home_shell.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  String? _error;

  void _register() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    final errorMessage = await authViewModel.register(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      _nameController.text.trim()
    );

    if (errorMessage != null) {
      setState(() => _error = errorMessage);
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
        Text("Register", style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        if (_error != null) ...[
          const SizedBox(height: 8),
          Text(_error!, style: const TextStyle(color: Colors.red)),
        ],
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _register,
          child: const Text("Create Account"),
        ),
        TextButton(
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
          ),
          child: const Text("Already have an account? Login"),
        )
      ],
    );
  }
}
