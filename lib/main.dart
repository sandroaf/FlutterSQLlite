import 'package:flutter/material.dart';
import 'package:fluttersqllite/screens/home_screen.dart';
import 'package:fluttersqllite/screens/login_screen.dart';
import 'package:fluttersqllite/screens/signup_page.dart';
import 'package:fluttersqllite/db/db_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Teste de conexão com o banco de dados
  try {
    final dbHelper = DatabaseHelper();
    bool connected = await dbHelper.testConnection();
    print('Database connection: ${connected ? 'SUCCESS' : 'FAILED'}');
  } catch (e) {
    print('Database initialization error: $e');
  }

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
