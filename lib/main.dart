import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'webview_manager.dart';
import 'loading_provider.dart';
import 'splash_screen.dart';
import 'landing_page.dart';

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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecomzed App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(nextPage: LandingPage()), // Start with the SplashScreen
    );
  }
}
