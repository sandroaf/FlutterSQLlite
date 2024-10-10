import 'package:flutter/material.dart';
import 'package:fluttersqllite/db/db_helper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dbHelper = DatabaseHelper();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbHelper.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Map<String, dynamic>> users = snapshot.data!;
            if (users.isNotEmpty) {
              Map<String, dynamic> user = users.first;
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Username: ${user['username']}',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Email: ${user['email']}',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Age: ${user['age']}',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Job: ${user['job']}',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: Text('No user data found.'),
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
