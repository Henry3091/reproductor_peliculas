import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_tabs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Películas',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeTabs(),
      },
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
