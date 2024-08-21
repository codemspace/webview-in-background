import 'package:ecomzed/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:ecomzed/webview_manager.dart';

class WebViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var webViewManager = Provider.of<WebViewManager>(context);

    return Scaffold(
      body: WebViewWidget(
        controller: webViewManager.controller
          ..setNavigationDelegate(NavigationDelegate(
            onPageFinished: (String url) async {
              if (url.contains('dashboard')) {
                webViewManager.scrapeDashboard().then((scrapedData) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreen(scrapedData: scrapedData)),
                    );
                });
              } 
            }
          ))
      )
    );
  }
}