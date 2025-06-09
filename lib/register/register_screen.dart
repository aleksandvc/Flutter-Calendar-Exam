import 'package:flutter/material.dart';
import 'package:flutter_calendar_exam/widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: RegisterForm(),
        ),
      ),
    );
  }
}