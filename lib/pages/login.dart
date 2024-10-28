import 'package:choreapp_frontend/clients/user_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

AndroidOptions _getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
UserClient userClient = UserClient();
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String? _errorMessage;
  Map<String, String>? tokens;
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        tokens = await userClient.login(_email, _password);
        await storage.write(key: 'accessToken', value: tokens?['accessToken']);
        await storage.write(key: 'refreshToken', value: tokens?['refreshToken']);
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      } catch (error) {
        setState(() {
          print(error);
          _errorMessage = "Wrong email or password!"; // Set error message on failure
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    // if (value.length < 6) {
                    //   return 'Password must be at least 6 characters';
                    // }
                    // if (!RegExp(r'[A-Z]').hasMatch(value)) {
                    //   return 'Password must contain at least one uppercase letter';
                    // }
                    // if (!RegExp(r'[a-z]').hasMatch(value)) {
                    //   return 'Password must contain at least one lowercase letter';
                    // }
                    // if (!RegExp(r'[0-9]').hasMatch(value)) {
                    //   return 'Password must contain at least one digit';
                    // }
                    // if (!RegExp(r'[!@#\$%\^&\*]').hasMatch(value)) {
                    //   return 'Password must contain at least one special character';
                    // }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value!;
                  },
                ),
                const SizedBox(height: 20),
                if (_errorMessage != null) 
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  ElevatedButton(
                  onPressed: _login,
                  child: const Text('Submit'),
                  ),
                  ElevatedButton(
                    onPressed: () => {
                      Navigator.pushReplacementNamed(context, '/register')
                    },
                    child: const Text('Register')
                  )
                ],),
                
                
              ],
            ),
          ),
        ),
    );
  }
}
