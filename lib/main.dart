import 'package:flutter/material.dart';
import 'package:tu_electricity_app/presenter/pages/homepage.dart';
import 'package:tu_electricity_app/presenter/pages/loginpage.dart';

void main() {
  print("App is starting...");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TU Electricity',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => Homepage(), 
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
