import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'webview_manager.dart';
import 'widgets/loading_provider.dart';

class SplashScreen extends StatefulWidget {
  final Widget nextPage; // Widget to navigate to after loading

  SplashScreen({required this.nextPage});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Initialize the WebViewManager when the app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WebViewManager>(context, listen: false).initialize(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<LoadingProvider>(
          builder: (context, loadingProvider, child) {
            // Check loading state and navigate to the provided nextPage when done
            if (!loadingProvider.isLoading) {
              Future.microtask(() {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => widget.nextPage),
                );
              });
            }

            return CircularProgressIndicator(); // Show loading indicator
          },
        ),
      ),
    );
  }
}
