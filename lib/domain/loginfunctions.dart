import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:tu_electricity_app/external/authfunctions.dart';
import 'package:tu_electricity_app/external/sheet_services.dart';
import 'package:tu_electricity_app/external/sheetauth.dart';

Future<void> loginFunction(BuildContext context) async {
  try {
    // final authService = GoogleAuthService();
    // final authClient = await authService.getAuthenticatedClient();
    
    // if (authClient == null) {
    //   _showMessage(context, "Google Sign-In Failed");
    //   return;
    // }

    // String? email = await authService.getGoogleEmail();
    // if (email == null) {
    //   _showMessage(context, "Failed to retrieve email");
    //   return;
    // }

    // Ensure Sheets API is initialized
    await AuthFunctions().initializeSheetsApi();

    final sheetsService = SheetsService();

    // // final isAuthorized = await sheetsService.isAuthorizedUser(email);
    // // if (isAuthorized) {
    //   final prefs = await SharedPreferences.getInstance();
    //   await prefs.setBool('isLoggedIn', true);
    //   // await prefs.setString('email', email);

      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: sheetsService,
      );
    // } else {
    //   _showMessage(context, "Unauthorized User");
    // }
  } catch (e) {
    _showMessage(context, "Login Error: $e");
  }
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
