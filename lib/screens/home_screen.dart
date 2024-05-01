import 'package:flutter/material.dart';
import 'package:fluttersqllite/db/db_helper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dbHelper = DatabaseHelper();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
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
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Email: ${user['email']}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Age: ${user['age']}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Job: ${user['job']}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    // Add other UI components as needed
                  ],
                ),
              );
            } else {
              return Center(
                child: Text('No user data found.'),
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
