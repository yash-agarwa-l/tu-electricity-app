import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:http/http.dart' as http;

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // scopes: ['https://www.googleapis.com/auth/spreadsheets'],
  );

  Future<String?> getGoogleEmail() async {
    try {
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        String? googleId = googleUser.email;
        debugPrint("Google ID: $googleId");
        return googleId;
      } else {
        debugPrint("Sign-in aborted by user.");
        return null;
      }
    } catch (e) {
      debugPrint("Error during Google Sign-In: $e");
      return null;
    }
  }

  // Future<auth.AuthClient?> getAuthenticatedClient() async {
  //   try {
  //     final GoogleSignInAccount? account = await _googleSignIn.signIn();
  //     if (account == null) return null;

  //     final GoogleSignInAuthentication authData = await account.authentication;
  //     final auth.AccessCredentials credentials = auth.AccessCredentials(
  //       auth.AccessToken(
  //         'Bearer',
  //         authData.accessToken!,
  //         DateTime.now().toUtc().add(Duration(seconds: 3600)),
  //       ),
  //       authData.idToken,
  //       ['https://www.googleapis.com/auth/spreadsheets'],
  //     );

  //     return auth.authenticatedClient(http.Client(), credentials);
  //   } catch (e) {
  //     print("Google Sign-In Error: $e");
  //     return null;
  //   }
  // }

  String? getSignedInUserEmail() {
    return _googleSignIn.currentUser?.email;
  }

  
}
