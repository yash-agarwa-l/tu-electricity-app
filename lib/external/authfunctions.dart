import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthFunctions {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String?> getGoogleId() async {
    try {
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        String googleId = googleUser.id;
        String email = googleUser.email;  
        debugPrint("Email: $email");
        return email;
      } else {
        debugPrint("Sign-in aborted by user.");
        return null;
      }
    } catch (e) {
      debugPrint("Error during Google Sign-In: $e");
      return null;
    }
  }
}