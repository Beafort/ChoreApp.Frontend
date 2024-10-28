import 'package:choreapp_frontend/pages/group_select.dart';
import 'package:choreapp_frontend/pages/group_view.dart';
import 'package:choreapp_frontend/pages/home.dart';
import 'package:choreapp_frontend/pages/login.dart'; // Import your login page
import 'package:choreapp_frontend/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'clients/chore_client.dart';

AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );
WebOptions _getWebOptions() => const WebOptions(
      
);
final storage = FlutterSecureStorage(aOptions: _getAndroidOptions(), webOptions: WebOptions.defaultOptions);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? token = await storage.read(key: 'accessToken'); 
  runApp(
    MultiProvider(
      providers: [
        Provider<ChoreClient>(create: (_) => ChoreClient()),
      ],
      child: MainApp(isLoggedIn: token != null),
    ),
  );
}

class SnackbarGlobal {
  static GlobalKey<ScaffoldMessengerState> key = GlobalKey<ScaffoldMessengerState>();

  static void show(String message) {
    key.currentState!
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class MainApp extends StatelessWidget {
  final bool isLoggedIn;

  const MainApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chore App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: isLoggedIn ? '/home' : '/login',
      routes: {
        '/login': (context) => const LoginForm(),
        '/home': (context) => const Home(),
        '/register': (context) => const RegisterForm(),
        '/group': (context) => const GroupSelect(),
        '/group/view': (context) => const GroupView()
      }, 
      scaffoldMessengerKey: SnackbarGlobal.key,
      debugShowCheckedModeBanner: false,
    );
  }
}
