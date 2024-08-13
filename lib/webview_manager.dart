import 'dart:convert';

import 'package:ecomzed/screens/home_screen.dart';
import 'package:ecomzed/screens/profile_screen.dart';
import 'package:ecomzed/screens/transfer/zelle_send_screen.dart';
import 'package:ecomzed/screens/verify_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import 'loading_provider.dart';

class WebViewManager with ChangeNotifier {
  WebViewController? _controller;

  // Initialize WebViewController
  void initialize(BuildContext context) {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (String url) {
          print('>>>>> Page started loading: $url');
          Provider.of<LoadingProvider>(context, listen: false).startLoading();
        },
        onPageFinished: (String url) {
          print('>>>>> Page finished loading: $url');
          Provider.of<LoadingProvider>(context, listen: false).stopLoading();
        },
        onWebResourceError: (WebResourceError error) {
          print('>>>>> Page resource error: ${error.description}');
          Provider.of<LoadingProvider>(context, listen: false).stopLoading();
        },
      ))
      ..loadRequest(Uri.parse('https://www.ally.com'));
  }

  // Prepare the WebView for login page
  void prepareLoginPage() async {
    try {
      print('----- Login button click start -----');
      await _controller?.runJavaScript('document.getElementById("login").click();');
      print('----- Login button click end -----');
    } catch (e) {
      print('----- Failed to prepare login page: $e -----');
    }
  }

  // Use provided credentials to log in
  Future<int> login(String email, String password) async {
    print('----- Login handle start -----');
    await _controller?.runJavaScript(
        'document.getElementById("allysf-login-v2-username-367761b575af35f6ccb5b53e96b2fa2d").value="$email";');
    await _controller?.runJavaScript(
        'document.getElementById("allysf-login-v2-password-367761b575af35f6ccb5b53e96b2fa2d").value="$password";');
    await _controller?.runJavaScript('document.querySelector(".allysf-login-v2-button").click();');
    print('----- Login handle end, wait for 20 -----');

    await Future.delayed(Duration(seconds: 50));

    String currentUrl = await _controller?.currentUrl() ?? '';
    print('----- Login result: ${currentUrl} -----');
    if (currentUrl.contains('dashboard')) {
      print('----- Contain dashboard in link -----');
      return 1; // Successfully logged in
    } else if (currentUrl.contains('send-code')) {
      print('----- Contain send-code in link -----');
      // https://secure.ally.com/security/send-code?focus=heading
      return 2;
    } else {
      return 0;
    }
  }

  void scrapeAndNavigateProfile(BuildContext context) async {
    print('----- ScrapeAndNavigateProfile -----');
    await _controller?.runJavaScript('''
      if (!document.querySelector('[aria-label="Open profile and settings menu"]')) {
        window.location.href = "/profile";
      } else {
        document.querySelector('[aria-label="Open profile and settings menu"]').click();
        setTimeout(function() {
          document.querySelector('a[data-allytmln="profile-panel - Personal Information"]').click();
        }, 2000);
      }
    ''');
    print('----- Profile setting button clicked, wait 10s -----');

    await Future.delayed(Duration(seconds: 20));

    String currentUrl = await _controller?.currentUrl() ?? '';

    if (currentUrl.contains('profile')) {

      await Future.delayed(Duration(seconds: 10));

      print('----- Profile page scraping start -----');

      final scrapedData = await scrapeProfileInfo();

      print('----- Profile page scraping end : ${scrapedData} -----');
    
      // Navigate to DashboardPage with the scraped data
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ProfileScreen(scrapedData: scrapedData)),
      );

    } else {
      await _controller?.runJavaScript('window.location.href = "/profile"');
    }
  }

  Future<Map<String, String>> scrapeProfileInfo() async {
    print('----- Profile page scraping start -----');
    final userInfoJson = await _controller?.runJavaScriptReturningResult('''
      (function() {
        var userInfo = {};

        // Extracting name
        userInfo.name = userInfo.name = document.querySelector('[data-dd-action-name="Users Full Name"]').innerText;

        // Extracting email
        userInfo.email = document.querySelector('[data-testid="primary-email-item"] [data-testid="private-wrapper"]').innerText;


        userInfo.phone = document.querySelector('[data-testid="card-phone"] [data-testid="private-wrapper"]').innerText;

        var primaryAddressParts = document.querySelectorAll('[data-testid="card-address"] .fhBGkE:first-child [data-testid="private-wrapper"]');
        userInfo.primaryAddress = Array.from(primaryAddressParts).map(part => {
          if (part.firstChild.children.length === 0) 
            return part.innerText;
          else {
            return part.firstChild.firstChild.innerText;
          }
        }).join(", ");

        var mailingAddressParts = document.querySelectorAll('[data-testid="card-address"] .fhBGkE:nth-child(2) [data-testid="private-wrapper"]');
        userInfo.mailingAddress = Array.from(primaryAddressParts).map(part => {
          if (part.firstChild.children.length === 0) 
            return part.innerText;
          else {
            return part.firstChild.firstChild.innerText;
          }
        }).join(", ");

        // Returning as a JSON string
        return JSON.stringify(userInfo);
      })();
    ''');
    final userInfoStr = jsonDecode(userInfoJson as String);
    final userInfoMap = jsonDecode(userInfoStr);
    print('----- Profile page scraping end  -----');
    print(userInfoMap);

    print('----------------- name: ${userInfoMap.name} --------------');
    print('----------------- email: ${userInfoMap.email} --------------');
    print('----------------- phone: ${userInfoMap.phone} --------------');
    print('----------------- availableBalance: ${userInfoMap.primaryAddress} --------------');
    print('----------------- mailingAddress: ${userInfoMap.mailingAddress} --------------');

    return {
      'name': userInfoMap.name?.toString() ?? 'N/A',
      'email': userInfoMap.email?.toString() ?? 'N/A',
      'phone': userInfoMap.phone?.toString() ?? 'N/A',
      'primaryAddress': userInfoMap.primaryAddress?.toString() ?? 'N/A',
      'mailingAddress': userInfoMap.mailingAddress?.toString() ?? 'N/A',
    };
  }

  // Function to scrape data and navigate after the dashboard is fully loaded
  void scrapeAndNavigateDashboard(BuildContext context) async {
    // Wait until loading is fully stopped
    bool loaded = false;

    do {
      final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);

      loaded = !loadingProvider.isLoading;
      print('----- loaded: ${loaded} -----');
    } while(!loaded);
    
    
    final scrapedData = await scrapeUserInfo();
    print('----- scrapedData: ${scrapedData} -----');
    
    // Navigate to DashboardPage with the scraped data
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomeScreen(scrapedData: scrapedData)),
    );
  }

  void sendCodeAndNavigate(BuildContext context) async {
    print('----- SendCodeAndNavigate -----');
    print('----- Wait 10s -----');

    await Future.delayed(Duration(seconds: 10));

    print('----- Send code button click start -----');
    // Wait until loading is fully stopped
    // await _controller?.runJavaScript('document.getElementById("primary-button-23dc3177-64c9-4231-b18d-b5f59d9d308a").click();');
    await _controller?.runJavaScript('document.querySelector("button[type=submit]").click();');
    print('----- Send code button click end -----');

    print('----- Wait 10s -----');
    await Future.delayed(Duration(seconds: 10));
    
    // Navigate to DashboardPage with the scraped data
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => VerifyCodeScreen()),
    );
  }

  void verifyCodeAndNavigate(String code, BuildContext context) async {
    try {
      print('----- VerifyCodeAndNavigate -----');

      await _controller?.runJavaScript(
          'document.getElementById("otpCode").value="$code";');

      print('----- Verify code button click start -----');
      await _controller?.runJavaScript('document.querySelector("button[type=submit]").click();');
      print('----- Verify code button click end -----');


      print('----- Wait 20 sec -----');
      await Future.delayed(Duration(seconds: 40));

      String currentUrl = await _controller?.currentUrl() ?? '';

      print('----- Arrived at: ${currentUrl} -----');
      if (currentUrl.contains('register-device')) {
        // https://secure.ally.com/security/register-device?focus=heading
        print('----- Register Device Page -----');
        // await Future.delayed(Duration(seconds: 10));
        print('----- Register device button click start, wait 30 sec -----');
        await _controller?.runJavaScript('document.querySelector("button[type=submit]").click();');
        print('----- Register device button click end, wait 30 sec -----');

        await Future.delayed(Duration(seconds: 50));

        currentUrl = await _controller?.currentUrl() ?? '';

        if (currentUrl.contains('dashboard')) {
          print('----- Contains dashboard -----');
          // await Future.delayed(Duration(seconds: 10));
          final scrapedData = await scrapeUserInfo();
          print('----- Dashboard Scraped: ${scrapedData}  -----');
      
          // Navigate to DashboardPage with the scraped data
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen(scrapedData: scrapedData)),
          );
        }
      } else if (currentUrl.contains('dashboard')) {
        print('----- Contains dashboard -----');
        // await Future.delayed(Duration(seconds: 10));
        final scrapedData = await scrapeUserInfo();
        print('----- Dashboard Scraped: ${scrapedData}  -----');
    
        // Navigate to DashboardPage with the scraped data
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen(scrapedData: scrapedData)),
        );
      }
    } catch (e) {
      print('Login failed: $e');
    }
  }

  // Scrape user info post-login
  Future<Map<String, String>> scrapeUserInfo() async {
    try {
      await Future.delayed(Duration(seconds: 10));
      
      print('----- Scrape UserInfo Start -----');
      // Use JavaScript to retrieve elements by their specific classes
      // final totalBalance = await _controller?.runJavaScriptReturningResult(
      //     'document.querySelector(".sc-bkEOxz.khXxoz").innerText;');
      // final totalBalance = await _controller?.runJavaScriptReturningResult(
      //     'document.querySelector(".sc-gpaZuh.cRBbhG").innerText;');
      final totalBalance = await _controller?.runJavaScriptReturningResult('''
        var element = document.querySelector(".sc-gpaZuh.cRBbhG").innerText;
        if (element) {
          element.innerText();
          return 'Element exists and was clicked.';
        } else {
          return document.querySelector(".sc-bkEOxz.khXxoz").innerText;
        }
      ''') ?? 'Failed to run JavaScript';
      // final userName = await _controller?.runJavaScriptReturningResult(
      //     'document.querySelector(".sc-bkEOxz.kVASZv").innerText;');
      // final userName = await _controller?.runJavaScriptReturningResult(
      //     'document.querySelector(".sc-gpaZuh.iMHXtv").innerText;');
      final userName = await _controller?.runJavaScriptReturningResult('''
        var element = document.querySelector(".sc-gpaZuh.iMHXtv").innerText;
        if (element) {
          element.innerText();
          return 'Element exists and was clicked.';
        } else {
          return document.querySelector(".sc-bkEOxz.kVASZv").innerText;
        }
      ''') ?? 'Failed to run JavaScript';
      final accountNumber = await _controller?.runJavaScriptReturningResult(
          'document.querySelector(".sc-eTTeRg.fsHrML .sc-gpaZuh.fEiiTJ").innerText;');
      final availableBalance = await _controller?.runJavaScriptReturningResult(
          'document.querySelector(".sc-gpaZuh.iMHXtv.jodnDw").innerText;');

      print('----- Scrape UserInfo End -----');

      print('----------------- totalBalance: ${totalBalance} --------------');
      print('----------------- userName: ${userName} --------------');
      print('----------------- accountNumber: ${accountNumber} --------------');
      print('----------------- availableBalance: ${availableBalance} --------------');

      return {
        'totalBalance': totalBalance.toString(),
        'userName': userName.toString(),
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

  void navigateZelle(BuildContext context) async {
    await _controller?.runJavaScript('window.location.href = "/payments/pay-people"');

    const zelleUrl = "https://secure.ally.com/payments/pay-people";
    await _controller?.loadRequest(Uri.parse(zelleUrl));

    String currentUrl = await _controller?.currentUrl() ?? '';
    while (!currentUrl.contains('pay-people')) {
      await Future.delayed(Duration(seconds: 10));
      currentUrl = await _controller?.currentUrl() ?? '';
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => ZelleSendScreen()),
    );
  }
}

