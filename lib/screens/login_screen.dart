import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // modern login screen
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Welcome to the login screen!'),
            ElevatedButton(
              onPressed: () {
                // Add navigation to the registration screen
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
