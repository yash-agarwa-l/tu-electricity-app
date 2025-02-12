import 'package:flutter/material.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:tu_electricity_app/domain/loginfunctions.dart';
import 'package:tu_electricity_app/external/authfunctions.dart';
import 'package:tu_electricity_app/external/sheet_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await handleLogin(context);
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}
