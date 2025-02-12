import 'package:flutter/material.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:tu_electricity_app/external/authfunctions.dart';
import 'package:tu_electricity_app/external/sheet_services.dart';
import 'package:tu_electricity_app/presenter/pages/homepage.dart';
import 'package:tu_electricity_app/presenter/pages/loginpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authService = GoogleAuthService();
  final authClient = await authService.getAuthenticatedClient();
  final sheetsService = authClient != null ? SheetsService(SheetsApi(authClient)) : null;

  runApp(MyApp(authService: authService, sheetsService: sheetsService));
}

class MyApp extends StatelessWidget {
  final GoogleAuthService authService;
  final SheetsService? sheetsService;

  const MyApp({super.key, required this.authService, required this.sheetsService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TU Electricity',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(authService: authService, sheetsService: sheetsService!),
        '/home': (context) => Homepage(sheetsService: sheetsService), // ✅ Pass sheetsService
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter is initialized before async code runs

//   final authService = GoogleAuthService();

//   runApp(MyApp(authService: authService));
// }

// class MyApp extends StatelessWidget {
//   final GoogleAuthService authService;

//   const MyApp({super.key, required this.authService});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'TU Electricity',
//       initialRoute: '/',
//       routes: {
//         '/': (context) => LoginPage(authService: authService, sheetsService: SheetsService(null)), // SheetsService is initialized later after login
//         '/home': (context) => Homepage(sheetsService: SheetsService(null)),
//       },
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:googleapis/sheets/v4.dart';
// import 'package:tu_electricity_app/external/authfunctions.dart';
// import 'package:tu_electricity_app/external/sheet_services.dart';
// import 'package:tu_electricity_app/presenter/pages/homepage.dart';
// import 'package:tu_electricity_app/presenter/pages/loginpage.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   final authService = GoogleAuthService();
//   final authClient = await authService.getAuthenticatedClient();
//   final sheetsService = authClient != null ? SheetsService(SheetsApi(authClient)) : null;

//   runApp(MyApp(authService: authService, sheetsService: sheetsService));
// }

// class MyApp extends StatelessWidget {
//   final GoogleAuthService authService;
//   final SheetsService? sheetsService;

//   const MyApp({super.key, required this.authService, required this.sheetsService});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'TU Electricity',
//       initialRoute: '/',
//       routes: {
//         '/': (context) => LoginPage(authService: authService, sheetsService: sheetsService),
//         '/home': (context) => Homepage(sheetsService: sheetsService), // ✅ Pass sheetsService
//       },
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//     );
//   }
// }

