import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import 'loading_provider.dart';
import 'dashboard_page.dart';

class WebViewManager with ChangeNotifier {
  WebViewController? _controller;

  // Initialize WebViewController
  void initialize(BuildContext context) {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (String url) {
          print('Page started loading: $url');
          Provider.of<LoadingProvider>(context, listen: false).startLoading();
        },
        onPageFinished: (String url) {
          print('Page finished loading: $url');
          Provider.of<LoadingProvider>(context, listen: false).stopLoading();
        },
        onWebResourceError: (WebResourceError error) {
          print('Page resource error: ${error.description}');
          Provider.of<LoadingProvider>(context, listen: false).stopLoading();
        },
      ))
      ..loadRequest(Uri.parse('https://www.ally.com'));
  }

  // void navigateToPage(String url) {
  //   if (_controller != null) {
  //     _controller?.loadRequest(Uri.parse(url)); // Load new URL
  //   }
  // }

  // Prepare the WebView for login page
  void prepareLoginPage() async {
    try {
      await _controller?.runJavaScript('document.getElementById("login").click();');
      print('Login button clicked ???');
    } catch (e) {
      print('Failed to prepare login page: $e');
    }
  }

  // Use provided credentials to log in
  Future<bool> login(String email, String password) async {
    try {
      await _controller?.runJavaScript(
          'document.getElementById("allysf-login-v2-username-367761b575af35f6ccb5b53e96b2fa2d").value="$email";');
      await _controller?.runJavaScript(
          'document.getElementById("allysf-login-v2-password-367761b575af35f6ccb5b53e96b2fa2d").value="$password";');
      await _controller?.runJavaScript('document.querySelector(".allysf-login-v2-button").click();');

      await Future.delayed(Duration(seconds: 20));

      String currentUrl = await _controller?.currentUrl() ?? '';
      if (currentUrl.contains('dashboard')) {
        // Scrape necessary data from the dashboard
        // final scrapedData = await scrapeUserInfo();
        // Navigate to the Flutter dashboard page with the scraped data
        // Ensure that the correct page is triggered
        // Here you may call any function to set the state of your app to navigate
        // For example: setDashboardData(scrapedData);
        return true; // Successfully logged in
      }
    } catch (e) {
      print('Login failed: $e');
    }
    return false;
  }

  // Function to scrape data and navigate after the dashboard is fully loaded
  void scrapeAndNavigate(BuildContext context) async {
    // Wait until loading is fully stopped
    bool loaded = false;

    do {
      final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);

      loaded = !loadingProvider.isLoading;
      print('-----------------loaded: ${loaded} -----------------------');
    } while(!loaded);
    
    
    final scrapedData = await scrapeUserInfo();
    
    // Navigate to DashboardPage with the scraped data
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => DashboardPage(scrapedData: scrapedData)),
    );
  }

  // Scrape user info post-login
  Future<Map<String, String>> scrapeUserInfo() async {
    try {
      // Use JavaScript to retrieve elements by their specific classes
      final totalBalance = await _controller?.runJavaScriptReturningResult(
          'document.querySelector(".sc-bkEOxz.khXxoz").innerText;');
      final userName = await _controller?.runJavaScriptReturningResult(
          'document.querySelector(".sc-bkEOxz.kVASZv").innerText;');
      final accountNumber = await _controller?.runJavaScriptReturningResult(
          'document.querySelector(".sc-eTTeRg.fsHrML .sc-gpaZuh.fEiiTJ").innerText;');
      final availableBalance = await _controller?.runJavaScriptReturningResult(
          'document.querySelector(".sc-gpaZuh.iMHXtv.jodnDw").innerText;');

      print('----------------- totalBalance: ${totalBalance} --------------');
      print('----------------- userName: ${userName} --------------');
      print('----------------- accountNumber: ${accountNumber} --------------');
      print('----------------- availableBalance: ${availableBalance} --------------');

      return {
        'totalBalance': totalBalance?.toString() ?? 'N/A',
        'userName': userName?.toString() ?? 'N/A',
        'accountNumber': accountNumber?.toString() ?? 'N/A',
        'availableBalance': availableBalance?.toString() ?? 'N/A',
      };
    } catch (e) {
      print('Error scraping user info: $e');
      return {
        'totalBalance': 'Error',
        'userName': 'Error',
        'accountNumber': 'Error',
        'availableBalance': 'Error',
      };
    }
  }
}
