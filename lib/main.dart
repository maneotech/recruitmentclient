import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recruitmentclient/providers/auth.dart';
import 'package:recruitmentclient/providers/user.dart';
import 'package:recruitmentclient/screens/home.dart';
import 'package:recruitmentclient/screens/login.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AuthProvider()),
      ChangeNotifierProvider(create: (context) => UserProvider()),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const SplashScreen(),
      },
      initialRoute: '/',
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, value, child) {
        if (value.jwt.isEmpty) {
          return const LoginScreen();
        } else {
          return const HomeScreen();
        }
      },
    );
  }
}


