import 'dart:convert';
import 'dart:ffi';

import 'package:ecomzed/screens/home_screen.dart';
import 'package:ecomzed/screens/profile_screen.dart';
import 'package:ecomzed/screens/transfer/review_send_screen.dart';
import 'package:ecomzed/screens/transfer/select_recipient_screen.dart';
import 'package:ecomzed/screens/transfer/send_money_screen.dart';
import 'package:ecomzed/screens/transfer/zelle_send_screen.dart';
// import 'package:ecomzed/screens/verify_code_screen.dart';
import 'package:ecomzed/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import 'widgets/loading_provider.dart';
import 'package:ecomzed/main.dart';

class WebViewManager with ChangeNotifier {
  late WebViewController _controller;

 // Public getter for the controller
  WebViewController get controller => _controller;
  
  static const zelleUrl = "https://secure.ally.com/payments/pay-people";
  static const dashboardUrl = "https://secure.ally.com/dashboard";
  // static const dashboardUrl = "https://secure.ally.com/dashboard?sfts=true";

  // Initialize WebViewController
  void initialize(BuildContext context) {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (String url) {
          print('>>>>> Page started loading: $url');
          Provider.of<LoadingProvider>(context, listen: false).startLoading();
        },
        onPageFinished: (String url) async {
          print('>>>>> Page finished loading: $url');

          // await Future.delayed(Duration(seconds: 20));

          if (url.contains('dashboard')) {
            // https://secure.ally.com/dashboard?sfts=true 
            print('----- dashboardScrape Start -----');
            final scrapedData = await scrapeDashboard();
            print('----- dashboardScrape: ${scrapedData} -----');
            // Navigator.of(context).pushReplacement(
            //   MaterialPageRoute(builder: (context) => HomeScreen(scrapedData: scrapedData)),
            // );
            navigate(HomeScreen(scrapedData: scrapedData));
          } 
          // else if (url.contains('send-code')) {
          //   // https://secure.ally.com/security/send-code?focus=heading
          //   print('----- Send Code Start -----');
          //   await _controller?.runJavaScript('document.querySelector("button[type=submit]").click();');
          //   print('----- Send Code End -----');
          // } 
          // else if (url.contains('verify-code')) {
          //   // https://secure.ally.com/security/verify-code?focus=heading
          //   print('----- Verify code page -----');
          //   Navigator.of(context).pushReplacement(
          //     MaterialPageRoute(builder: (context) => VerifyCodeScreen()),
          //   );
          // } 
          else if (url.contains('register-device')) {
            // https://secure.ally.com/security/register-device?focus=heading
            print('----- Register device button click start -----');
            await _controller?.runJavaScript('document.querySelector("button[type=submit]").click();');
            print('----- Register device button click end -----');
          } else if (url.contains('pay-people')) {
            print('----- Pay page -----');
            // https://secure.ally.com/payments/pay-people
            // scrape
            // Navigator.of(context).pushReplacement(
            //   MaterialPageRoute(builder: (context) => ZelleSendScreen()),
            // );
            // navigate(ZelleSendScreen());
            navigate(WebViewScreen());
          } else if (url.contains('profile')) {
            print('----- Profile page -----');
            final scrapedData = await scrapeProfile();
            print('----- Profile page scraping end : ${scrapedData} -----');
            // Navigate to DashboardPage with the scraped data
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => ProfileScreen(scrapedData: scrapedData)),
            );
          } else if (url.contains('secure.ally.com/?sfts=true&ticketID=')) {
            print('----- Here is the issue place -----');
            await _controller?.loadRequest(Uri.parse(dashboardUrl));
          } else {
            print('----- Where is here? -----');
            // https://secure.ally.com/dashboard?sfts=true
          }
            // https://secure.ally.com/dashboard?sfts=true&ticketID=sf-agc8e4e42d-43e3-42f4-ba8a-c3e9cd0de3be
            // https://secure.ally.com/?sfts=true&ticketID=sf-nmc88326e6-61df-43b7-a66b-76a39969cf43
          Provider.of<LoadingProvider>(context, listen: false).stopLoading();
        },
        onWebResourceError: (WebResourceError error) {
          print('>>>>> Page resource error: ${error.description}');
          Provider.of<LoadingProvider>(context, listen: false).stopLoading();
        },
      ))
      ..loadRequest(Uri.parse('https://www.ally.com'));
  }

  void navigate(Widget screen) {
    navigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: (_) => screen));
  }

  // Use provided credentials to log in
  // void login(String email, String password) async {
  //   print('----- Login handle start -----');
  //   await _controller?.runJavaScript(
  //       'document.getElementById("login").click();');
  //   await Future.delayed(Duration(seconds: 5));
  //   await _controller?.runJavaScript(
  //       'document.getElementById("allysf-login-v2-username-367761b575af35f6ccb5b53e96b2fa2d").value="$email";');
  //   await _controller?.runJavaScript(
  //       'document.getElementById("allysf-login-v2-password-367761b575af35f6ccb5b53e96b2fa2d").value="$password";');
  //   await _controller?.runJavaScript('document.querySelector(".allysf-login-v2-button").click();');
  //   print('----- Login handle end -----');
  // }

  Future<int> login(String email, String password) async {
    try {
      await _controller?.runJavaScript(
        'document.getElementById("login").click();');
      await Future.delayed(Duration(seconds: 5));
      print('----- Login handle start -----');
      await _controller?.runJavaScript(
          'document.getElementById("allysf-login-v2-username-367761b575af35f6ccb5b53e96b2fa2d").value="$email";');
      await _controller?.runJavaScript(
          'document.getElementById("allysf-login-v2-password-367761b575af35f6ccb5b53e96b2fa2d").value="$password";');
      await _controller?.runJavaScript('document.querySelector(".allysf-login-v2-button").click();');
      print('----- Login handle end, wait for 20 -----');

      await Future.delayed(Duration(seconds: 120));

      String currentUrl = await _controller?.currentUrl() ?? '';
      print('----- Login result: ${currentUrl} -----');
      if (currentUrl.contains('dashboard')) {
        print('----- Contain dashboard in link -----');
        return 1; // Successfully logged in
      } else if (currentUrl.contains('send-code')) {
        print('----- Contain send-code in link -----');
        // https://secure.ally.com/security/send-code?focus=heading
        return 2;
      }

    } catch (e) {
      print('Login failed: $e');
    }
    return 0;
  }

  void scrapeAndNavigateDashboard(BuildContext context) async {
    // Wait until loading is fully stopped
    bool loaded = false;

    do {
      final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);

      loaded = !loadingProvider.isLoading;
      print('----- loaded: ${loaded} -----');
    } while(!loaded);
    
    
    final scrapedData = await scrapeDashboard();
    print('----- scrapedData: ${scrapedData} -----');
    
    // Navigate to DashboardPage with the scraped data
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomeScreen(scrapedData: scrapedData)),
    );
  }

  void sendCodeAndNavigate(BuildContext context) async {
    print('----- SendCodeAndNavigate -----');
    print('----- Wait 10s -----');

    await Future.delayed(Duration(seconds: 30));

    print('----- Send code button click start -----');
    // Wait until loading is fully stopped
    // await _controller?.runJavaScript('document.getElementById("primary-button-23dc3177-64c9-4231-b18d-b5f59d9d308a").click();');
    await _controller?.runJavaScript('document.querySelector("button[type=submit]").click();');
    print('----- Send code button click end -----');

    print('----- Wait 10s -----');
    await Future.delayed(Duration(seconds: 30));
    
    // Navigate to DashboardPage with the scraped data
    Navigator.of(context).pushReplacement(
      // MaterialPageRoute(builder: (context) => VerifyCodeScreen()),
      MaterialPageRoute(builder: (context) => WebViewScreen()),
    );
  }

  void verifyCode(String code, BuildContext context) async {
    // JavaScript code to simulate pressing the Tab key and entering the code
    print('----- verifyCode start -----');
    String jsCode = """
      function simulateKeyPress(character) {
        var evt = new KeyboardEvent('keydown', {'key': character, 'code': character, 'keyCode': character.charCodeAt(0)});
        document.dispatchEvent(evt);
      }

      function simulateTabAndInputNumbers(code) {
        // Simulate pressing the Tab key
        simulateKeyPress('Tab');

        // Simulate entering the code, digit by digit
        for (var i = 0; i < code.length; i++) {
          simulateKeyPress(code[i]);
        }
      }

      simulateTabAndInputNumbers('$code');
    """;

    // Inject the JS code to perform the actions
    await _controller?.runJavaScript(jsCode);

    // Submit the form by clicking the submit button
    await _controller?.runJavaScript('document.querySelector("button[type=submit]").click();');
    print('----- verifyCode end -----');
  }

  Future<Map<String, String>> scrapeProfile() async {
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

    return {
      'name': userInfoMap.name?.toString() ?? 'N/A',
      'email': userInfoMap.email?.toString() ?? 'N/A',
      'phone': userInfoMap.phone?.toString() ?? 'N/A',
      'primaryAddress': userInfoMap.primaryAddress?.toString() ?? 'N/A',
      'mailingAddress': userInfoMap.mailingAddress?.toString() ?? 'N/A',
    };
  }

  // Scrape user info post-login
  Future<Map<String, String>> scrapeDashboard() async {
    try {
      await Future.delayed(Duration(seconds: 30));
      
      print('----- Scrape dashboard start -----');
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

  
  void toProfile(BuildContext context) async {
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
  }

  
  void toZelle(BuildContext context) async {
    // await _controller?.runJavaScript('window.location.href = "/payments/pay-people"');
    await _controller?.loadRequest(Uri.parse(zelleUrl));
  }

  void toSend(BuildContext context) async {
    print('----- toSend button start -----');
    await _controller?.runJavaScript('document.getElementById("lnkSend").click();');
    print('----- toSend button end -----');

    Provider.of<LoadingProvider>(context, listen: false).startLoading();
    await Future.delayed(Duration(seconds: 5));
    final scrapedData = await scrapeRecentRecipients();
    print('----- dashboardScrape: ${scrapedData} -----');
    Provider.of<LoadingProvider>(context, listen: false).stopLoading();
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => SelectRecipientScreen(scrapedData: scrapedData)),
    );
  }

  Future<List<Map<String, String>>> scrapeRecentRecipients() async {
      await Future.delayed(Duration(seconds: 10));
      
      print('----- Scrape UserInfo Start -----');
      final jsonString = await _controller?.runJavaScriptReturningResult('''
        var elements = document.querySelector('.recently-recipients.ng-scope').children;
        var result = [];
        if (elements.length) {
            for (var element of elements) {
                var details = element.innerText.split('\n').filter(line => line.trim() !== '');
                result.push({
                    // 'contactInitial': details[0].trim(),
                    'countryCode': details[1].trim(),
                    // 'contactName': details[2].trim(),
                    'companyName': details[3].trim(),
                    // 'emailToken': details[5].trim(),
                    'email': details[6].trim()
                });

                // ['CONTACT INITIAL ', 'DE', 'Contact name ', 'DecCompany001', '', 'Email token ', 'company001@thedeccompany.com']
            }
        }
        return JSON.stringify(result);  // Convert the array to JSON string to parse in Dart
      ''');

      final temp = jsonDecode(jsonString as String);

      print('----- scraped result1: ${temp} -----');
      final result = jsonDecode(temp);

      print('----- scraped result2: ${result} -----');
      
      return result;
  }

  
  void clickOneRecipient(BuildContext context, int i) async {
    print('----- toSend button start -----');
    await _controller?.runJavaScript("document.querySelector('.recently-recipients.ng-scope').children[$i].click();");
    print('----- toSend button end -----');
    await Future.delayed(Duration(seconds: 20));
    print('----- Continue button end -----');
    await _controller?.runJavaScript("document.getElementById('yesConsent').click();");
    print('----- Continue button end -----');
    await Future.delayed(Duration(seconds: 20));
    
    final scrapedData = await scrapeBeforeSend();
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => SendMoneyScreen(scrapedData: scrapedData)),
    );
  }

  
  Future<Map<String, String>> scrapeBeforeSend() async {
    final availableBalance = await _controller?.runJavaScriptReturningResult('document.getElementById("accountSelect").innerText');

    print('----------------- availableBalance: ${availableBalance} --------------');

    return {
      'availableBalance': availableBalance?.toString() ?? 'N/A',
    };
  }

  void reviewBeforeSend(BuildContext context, Double amount) async {
    print('----- Review handle start -----');
    await _controller?.runJavaScript(
        'document.getElementById("dollarAmountInput").value="$amount";');
    await _controller?.runJavaScript('document.getElementById("sendmoneyamount_nextbutton").click();');
    await Future.delayed(Duration(seconds: 20));
  
    final scrapedData = await scrapeBeforeSend();
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => ReviewSendScreen(scrapedData: scrapedData)),
    );
    print('----- Review handle end -----');
  }

  Future<Map<String, String>> scrapeOnReview() async {
    final result = await _controller?.runJavaScriptReturningResult(
      'document.getElementById("sendMoneyReviewPage")?.querySelector("h3")?.innerText || "N/A";'
    );

    print('----------------- availableBalance: $result --------------');

    return {
      'availableBalance': result?.toString() ?? 'N/A',
    };
  }

  void clickSend() async {
    print('----- Review handle start -----');
    await _controller?.runJavaScript('document.getElementById("sendmoneyreview_nextbutton").click();');
  }

  void clickSendAgain() async {
    print('----- Review handle start -----');
    // await _controller?.runJavaScript('document.getElementById("confirmationCheckbox").checked = true;');
    await _controller?.runJavaScript('document.getElementById("confirmationCheckbox").click();');
    await Future.delayed(Duration(seconds: 1));
    await _controller?.runJavaScript('document.getElementById("safeUseAlertPageId").querySelectorAll(".btn-primary")[0].click();');
    await Future.delayed(Duration(seconds: 5));

    // Duplicate Payment checking
    await _controller?.runJavaScript('document.getElementById("yesDuplicatePayment").click();');
    await Future.delayed(Duration(seconds: 20));
    // All done
    await _controller?.runJavaScript('document.getElementById("sendmoneyconfirm_nextbutton").click();');
  }


  void toRequest(BuildContext context) async {
    await _controller?.runJavaScript('document.getElementById("lnkRequest").click();');
  }

}
