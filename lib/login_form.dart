import 'package:ecomzed/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'webview_manager.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  int _loginAttempts = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Username',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock),
              suffixIcon: Icon(Icons.visibility),
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  bool loginSuccess = await _handleLogin(context);
                  print('----------------- loginSuccess: ${loginSuccess} ---------------------');
                  if (loginSuccess) {
                    // Go to DashboardPage with scraped values
                    _handleSuccess(context);
                  } else {
                    _loginAttempts++;
                    if (_loginAttempts >= 3) {
                      _showWarningDialog(context);
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Invalid credentials, please try again.')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Color(0xFF9c27b0),
                ),
                child: Text('Log In'),
              ),
              SizedBox(width: 16),
              Checkbox(
                value: true,
                onChanged: (bool? value) {},
              ),
              Text('Save username'),
            ],
          ),
          SizedBox(height: 16),
          Text.rich(
            TextSpan(
              text: 'Forgot ',
              style: TextStyle(color: Colors.black54),
              children: [
                TextSpan(
                  text: 'username',
                  style: TextStyle(color: Color(0xFF9c27b0)),
                ),
                TextSpan(text: ' or '),
                TextSpan(
                  text: 'password',
                  style: TextStyle(color: Color(0xFF9c27b0)),
                ),
                TextSpan(text: '?'),
              ],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Create a profile to manage your account online',
            style: TextStyle(
              color: Color(0xFF9c27b0),
              decoration: TextDecoration.underline,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'More to do',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text.rich(
            TextSpan(
              text: 'Finish a ',
              style: TextStyle(color: Colors.black54),
              children: [
                TextSpan(
                  text: 'mortgage application',
                  style: TextStyle(color: Color(0xFF9c27b0)),
                ),
              ],
            ),
          ),
          SizedBox(height: 4),
          Text.rich(
            TextSpan(
              text: 'Complete a saved auto refinance or lease buyout application',
              style: TextStyle(color: Color(0xFF9c27b0)),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _handleLogin(BuildContext context) async {
    String email = _emailController.text;
    String password = _passwordController.text;
    WebViewManager webViewManager = Provider.of<WebViewManager>(context, listen: false);

    return await webViewManager.login(email, password);
  }

  void _handleSuccess(BuildContext context) async {
    // Retrieve the WebViewManager instance
    WebViewManager webViewManager = Provider.of<WebViewManager>(context, listen: false);

    // Scrape user info after the login is successful
    webViewManager.scrapeAndNavigate(context);
  }

  void _showWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Too many attempts'),
          content: Text('Your credential is not correct, go home!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Close the app after the dialog is closed
                Navigator.of(context).popUntil((route) => route.isFirst);
                // Optionally use exit(0) to close the app entirely (not recommended in iOS)
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
