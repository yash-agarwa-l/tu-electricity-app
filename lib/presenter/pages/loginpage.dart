import 'package:flutter/material.dart';
import 'package:tu_electricity_app/external/authfunctions.dart';
import 'package:tu_electricity_app/external/sheet_services.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            AuthService authService = AuthService();
            String? accessToken = await authService.signInWithGoogle();

            if (accessToken != null) {
              SheetsService().updateSheet(accessToken, "Sheet1!A1", [
                ["Name", "Value"],
                ["Yash", "100"]
              ]);
              String? email = await authService.getUserEmail();
              if (await SheetsService().isAuthorizedUser(accessToken, email!)) {
                Navigator.pushReplacementNamed(context, '/home');
              } else {
                print("Unauthorized User");
              }
            } else {
              print("Google Sign-In Failed");
            }
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}
