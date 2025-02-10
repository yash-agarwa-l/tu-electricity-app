import 'package:flutter/material.dart';
import 'package:tu_electricity_app/external/authfunctions.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              String? gmail = await AuthFunctions().getGoogleId();
              
              if (gmail != null) {
                bool isAllowed = await checkUserAccess(gmail); // Check access
                if (isAllowed) {
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Access Denied"),
                      content: const Text("You are not authorized to access this app."),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                }
              } else {
                print('No Gmail account found');
              }
            } catch (e) {
              print("Error during login: $e");
            }
          },
          child: const Text('Login'),
        ),
      ),
    );
  }

  Future<bool> checkUserAccess(String gmail) async {
    // TODO: Replace this with Google Sheets API call
    List<String> allowedUsers = ["yagarwal_be23@thapar.edu", "sbhagat2@thapar.edu"]; // Example
    return allowedUsers.contains(gmail);
  }
}
