import 'package:ecomzed/widgets/loading_provider.dart';
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

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecomzed App',
      theme: ThemeData(),
      navigatorKey: navigatorKey,
      home: SplashScreen(nextPage: LandingScreen()), // Start with the SplashScreen
    );
  }
}
