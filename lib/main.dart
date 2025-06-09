import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_calendar_exam/auth_wrapper.dart';
import 'package:flutter_calendar_exam/viewmodels/event_viewmodel.dart';
import 'package:provider/provider.dart';
import 'viewmodels/auth_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(
          create: (_) => AuthViewModel(),
        ),
        ChangeNotifierProvider<EventViewModel>(
          create: (_) => EventViewModel(),
        ),
      ],
      child: MaterialApp(
        title: 'Calendar App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: const AuthWrapper(),
      ),
    );
  }
}