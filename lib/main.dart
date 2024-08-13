import 'package:ecomzed/loading_provider.dart';
import 'package:ecomzed/screens/landing_screen.dart';
import 'package:ecomzed/splash_screen.dart';
import 'package:ecomzed/webview_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WebViewManager()),
        ChangeNotifierProvider(create: (_) => LoadingProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Map<String, String> userData = {
    'name': 'Ryan Williams',
    'email': 'DecUser002@gmail.com',
    'phone': '725-696-9382',
    'primaryAddress': '946 Stockton St, 10A, San Francisco, CA 94108',
    'mailingAddress': '946 Stockton St, 10A, San Francisco, CA 94108',
  };

  final Map<String, String> accountData = {
    'name': 'DecUser002',
    'phone': 'AnAppleADayKeepsTheDoctorAway3',
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecomzed App',
      theme: ThemeData(),
      home: SplashScreen(nextPage: LandingScreen()), // Start with the SplashScreen
    );
  }
}


// import 'package:ecomzed/screens/transfer/zelle_send_screen.dart';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(
//       MyApp(),
//   );
// }

// class MyApp extends StatelessWidget {
//   final Map<String, String> userData = {
//     'name': 'Ryan Williams',
//     'email': 'DecUser002@gmail.com',
//     'phone': '725-696-9382',
//     'primaryAddress': '946 Stockton St, 10A, San Francisco, CA 94108',
//     'mailingAddress': '946 Stockton St, 10A, San Francisco, CA 94108',
//   };

//   final Map<String, String> accountData = {
//     'name': 'DecUser002',
//     'phone': 'AnAppleADayKeepsTheDoctorAway3',
//   };

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Ecomzed App',
//       theme: ThemeData(),
//       home: ZelleSendScreen(), // Start with the SplashScreen
//     );
//   }
// }
