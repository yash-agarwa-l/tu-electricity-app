import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:tu_electricity_app/external/authfunctions.dart';
import 'package:tu_electricity_app/external/sheet_services.dart';
import 'package:tu_electricity_app/presenter/pages/homepagereal.dart';
import 'package:tu_electricity_app/presenter/pages/loginpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bool isLoggedIn = await _checkLoginStatus();
  final String? email = await _getStoredEmail();

  SheetsService? sheetsService;
  if (isLoggedIn && email != null) {
    final authService = GoogleAuthService();
    final authClient = await authService.getAuthenticatedClient();
    if (authClient != null) {
      sheetsService = SheetsService(SheetsApi(authClient));
    }
  }

  runApp(MyApp(isLoggedIn: isLoggedIn, sheetsService: sheetsService));
}

Future<bool> _checkLoginStatus() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
}

Future<String?> _getStoredEmail() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('email');
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final SheetsService? sheetsService;

  const MyApp({super.key, required this.isLoggedIn, this.sheetsService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TU Electricity',
      home: isLoggedIn && sheetsService != null 
          ? HomePageMain(sheetsService: sheetsService!) 
          : LoginPage(),
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          final SheetsService sheetsService = settings.arguments as SheetsService;
          return MaterialPageRoute(
            builder: (context) => HomePageMain(sheetsService: sheetsService),
          );
        }
        return null;
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
    );
  }
}
