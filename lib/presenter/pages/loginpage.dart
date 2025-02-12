import 'package:flutter/material.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:tu_electricity_app/external/authfunctions.dart';
import 'package:tu_electricity_app/external/sheet_services.dart';

class LoginPage extends StatefulWidget {
  // final GoogleAuthService authService;
  // final SheetsService sheetsService;

  const LoginPage({
    super.key,
    // required this.authService,
    // required this.sheetsService,
  });

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> _handleLogin(BuildContext context) async {
    try {
      final authService = GoogleAuthService();
      final authClient = await authService.getAuthenticatedClient();
      // final sheetsService = authClient != null ? SheetsService(SheetsApi(authClient)) : null;
      if (authClient == null) {
        _showMessage(context, "Google Sign-In Failed");
        return;
      }

      final email = authService.getSignedInUserEmail();
      if (email == null || email.isEmpty) {
        _showMessage(context, "Failed to retrieve email");
        return;
      }

      final sheetsService = SheetsService(SheetsApi(authClient));

      final isAuthorized = await sheetsService.isAuthorizedUser(email);
      if (isAuthorized) {
        Navigator.pushReplacementNamed(
          context,
          '/home',
          arguments: sheetsService,
        );
      } else {
        _showMessage(context, "Unauthorized User");
      }
    } catch (e) {
      _showMessage(context, "Login Error: $e");
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _handleLogin(context);
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}
