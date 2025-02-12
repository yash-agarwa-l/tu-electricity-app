// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class AuthFunctions {
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   Future<String?> getGoogleId() async {
//     try {
//       GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser != null) {
//         String googleId = googleUser.id;
//         String email = googleUser.email;  
//         debugPrint("Email: $email");
//         return email;
//       } else {
//         debugPrint("Sign-in aborted by user.");
//         return null;
//       }
//     } catch (e) {
//       debugPrint("Error during Google Sign-In: $e");
//       return null;
//     }
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['https://www.googleapis.com/auth/spreadsheets'],
  );

  Future<String?> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return null;

      final auth = await account.authentication;
      return auth.accessToken;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }
  Future<String?> getUserEmail() async {
    try {
      final account = await _googleSignIn.signInSilently();
      return account?.email;
    } catch (e) {
      print("Error fetching user email: $e");
      return null;
    }
  }
  
}
