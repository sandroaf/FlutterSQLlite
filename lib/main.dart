import 'package:flutter/material.dart';
import 'package:fluttersqllite/screens/home_screen.dart';
import 'package:fluttersqllite/screens/login_screen.dart';
import 'package:fluttersqllite/screens/signup_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
