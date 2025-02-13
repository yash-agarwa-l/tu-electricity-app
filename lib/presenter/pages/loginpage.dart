import 'package:flutter/material.dart';
import 'package:tu_electricity_app/domain/loginfunctions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  Future<void> handleLogin(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await loginFunction(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(76.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Login to TU Electricity App',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: 200.0,
                    child: ElevatedButton(
                      onPressed: () async {
                        await handleLogin(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                        textStyle: const TextStyle(fontSize: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      child: const Text('Login'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
