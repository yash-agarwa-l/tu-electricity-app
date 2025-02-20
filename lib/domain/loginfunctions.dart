import 'package:flutter/material.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:tu_electricity_app/external/authfunctions.dart';
import 'package:tu_electricity_app/external/sheet_services.dart';

Future<void> loginFunction(BuildContext context) async {
  try {
    final authService = GoogleAuthService();
    final authClient = await authService.getAuthenticatedClient();
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
