import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/auth_io.dart';

class AuthFunctions {
  static final AuthFunctions _instance = AuthFunctions._internal();
  sheets.SheetsApi? sheetsApi;

  factory AuthFunctions() {
    return _instance;
  }

  AuthFunctions._internal();

  Future<void> initializeSheetsApi() async {
    if (sheetsApi != null) return; // Prevent reinitialization

    try {
      final serviceAccountCredentials =
          await rootBundle.loadString('assets/serviceAccountKey.json');
      final credentials =
          ServiceAccountCredentials.fromJson(serviceAccountCredentials);

      final authClient = await clientViaServiceAccount(
        credentials,
        [sheets.SheetsApi.spreadsheetsScope],
      );

      sheetsApi = sheets.SheetsApi(authClient);
      print('Google Sheets API initialized successfully.');
    } catch (e) {
      debugPrint("Error initializing Google Sheets API: $e");
    }
  }
}
