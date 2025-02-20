
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenFunctions {
  static const FlutterSecureStorage storage = FlutterSecureStorage();

  static Future<void> storeToken(var token) async {
    await storage.write(key: 'token', value: '$token');
  }

  static Future<String> getToken() async {
    String? token = await storage.read(key: 'token');
    return token ?? "Error";
  }

  static Future<Map<String, String>> getHeader() async {
    String token = await getToken();
    try {
      token = await TokenFunctions.getToken();
      if (token.startsWith('Error')) {
        throw Exception("Login Again");
      }
    } catch (e) {
      debugPrint("Failed to retrieve token: $e");
      return {};
    }

    Map<String, String> headers = {
      "Cookie": token,
      'Content-Type': 'application/json',
    };
    return headers;
  }
}