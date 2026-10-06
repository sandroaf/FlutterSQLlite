import 'package:flutter/material.dart';
import 'package:fluttersqllite/db/db_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.user, super.key});

  final Map<String, dynamic> user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> _user;

  @override
  void initState() {
    super.initState();
    _user = Map<String, dynamic>.from(widget.user);
  }

  Future<void> _editUser() async {
    final usernameController =
        TextEditingController(text: _user['username'] as String);
    final emailController =
        TextEditingController(text: _user['email'] as String);
    final passwordController =
        TextEditingController(text: _user['password'] as String);
    final ageController = TextEditingController(text: _user['age'].toString());
    final jobController = TextEditingController(text: _user['job'] as String);

    try {
      final updatedUser = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Edit user'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(usernameController, 'Username'),
                  _buildTextField(emailController, 'Email'),
                  _buildTextField(
                    passwordController,
                    'Password',
                    obscureText: true,
                  ),
                  _buildTextField(
                    ageController,
                    'Age',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || int.tryParse(value) == null) {
                        return 'Enter a valid age';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(jobController, 'Job'),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                Navigator.pop(dialogContext, {
                  'username': usernameController.text.trim(),
                  'email': emailController.text.trim(),
                  'password': passwordController.text,
                  'age': int.parse(ageController.text),
                  'job': jobController.text.trim(),
                });
              },
              child: const Text('Save'),
            ),
          ],
        ),
      );

      if (updatedUser == null || !mounted) return;
      final rowsUpdated =
          await _dbHelper.updateUser(_user['id'] as int, updatedUser);
      if (!mounted) return;
      if (rowsUpdated == 0) {
        _showMessage('User was not found.', isError: true);
        return;
      }

      setState(() => _user = {..._user, ...updatedUser});
      _showMessage('User updated successfully.');
    } catch (e) {
      if (mounted) _showMessage('Could not update user: $e', isError: true);
    } finally {
      usernameController.dispose();
      emailController.dispose();
      passwordController.dispose();
      ageController.dispose();
      jobController.dispose();
    }
  }

  Future<void> _deleteUser() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete user'),
        content: Text('Are you sure you want to delete ${_user['username']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !mounted) return;

    try {
      final rowsDeleted = await _dbHelper.deleteUser(_user['id'] as int);
      if (!mounted) return;
      if (rowsDeleted == 0) {
        _showMessage('User was not found.', isError: true);
        return;
      }

      final messenger = ScaffoldMessenger.of(context);
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      messenger.showSnackBar(
        const SnackBar(content: Text('User deleted successfully.')),
      );
    } catch (e) {
      if (mounted) _showMessage('Could not delete user: $e', isError: true);
    }
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: validator ??
            (value) {
              if (value == null || value.trim().isEmpty) {
                return '$label is required';
              }
              return null;
            },
      ),
    );
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            tooltip: 'Edit user',
            icon: const Icon(Icons.edit),
            onPressed: _editUser,
          ),
          IconButton(
            tooltip: 'Delete user',
            icon: const Icon(Icons.delete),
            onPressed: _deleteUser,
          ),
          IconButton(
            tooltip: 'Log out',
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Username: ${_user['username']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Email: ${_user['email']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Age: ${_user['age']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Job: ${_user['job']}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
