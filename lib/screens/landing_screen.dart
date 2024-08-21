import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../webview_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';  // Import flutter_secure_storage

class LandingScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();  // Create an instance of FlutterSecureStorage
  int _loginAttempts = 0;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showAccountModal(context);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 104,4,100),
        title: Container(
          padding: EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => _showMenuModal(context),
                child: Icon(Icons.menu, color: Colors.white, size: 46),
              ),
              Flexible(
                child: Text(
                  'ally',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _showAccountModal(context),
                child: Icon(Icons.account_circle, color: Colors.white, size: 46),
              ),
            ],
          ),
        )
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Set up faster. Get paid sooner with early direct deposit.',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 38,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'With simple digital setup and potential to get paid up to two days earlier, there’s no reason not to use direct deposit.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {_showAccountModal(context);}, // Logic to handle 'Get Started'
                child: Text('Get Started'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.purple,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/early_pay.png', // Place your image in the assets directory
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Early payday is here with direct deposit!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 56,12,68),
    );
  }

  void _showAccountModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: Icon(Icons.visibility_off),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                // onPressed: () async {
                  // print('----- Login button clicked -----');
                  // _handleLogin(context);
                // },
                onPressed: () async {
                  print('----- Login button clicked -----');
                  int loginSuccess = await _handleLogin(context);
                  print('----- Login Status: ${loginSuccess} -----');

                  if (loginSuccess == 1) {
                    // Go to DashboardPage with scraped values
                    await _saveCredentials(_emailController.text, _passwordController.text);
                    _handleSuccess(context);
                  } else if (loginSuccess == 2) {
                    _handleSendCode(context);
                  }else {
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
                child: Text('Log In'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.deepPurple,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(value: false, onChanged: (bool? value) {}),
                  Text('Save username'),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Text('Forgot username or password?'),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Create a profile to manage your account online'),
              ),
              Divider(),
              Text('More to do', style: TextStyle(fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () {},
                child: Text('Finish a mortgage application'),
              ),
              // TextButton(
              //   onPressed: () {},
              //   child: Text('Complete a saved auto refinance or lease buyout application'),
              // ),
            ],
          ),
        );
      }
    );
  }

  void _showMenuModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: [
              ListTile(
                leading: Icon(Icons.monetization_on),
                title: Text('U.S. dollar'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.language),
                title: Text('American English'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.help_outline),
                title: Text('Help and support'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.gavel),
                title: Text('Dispute resolution'),
                onTap: () {},
              ),
            ],
          ).toList(),
        );
      }
    );
  }
  
  // void _handleLogin(BuildContext context) async {
  //   String email = _emailController.text;
  //   String password = _passwordController.text;
  //   WebViewManager webViewManager = Provider.of<WebViewManager>(context, listen: false);

  //   webViewManager.login(email, password);
  // }

  Future<int> _handleLogin(BuildContext context) async {
    String email = _emailController.text;
    String password = _passwordController.text;
    WebViewManager webViewManager = Provider.of<WebViewManager>(context, listen: false);

    return await webViewManager.login(email, password);
  }

  void _handleSuccess(BuildContext context) async {
    // Retrieve the WebViewManager instance
    WebViewManager webViewManager = Provider.of<WebViewManager>(context, listen: false);

    // Scrape user info after the login is successful
    webViewManager.scrapeAndNavigateDashboard(context);
  }

  void _handleSendCode(BuildContext context) async {
    // Retrieve the WebViewManager instance
    WebViewManager webViewManager = Provider.of<WebViewManager>(context, listen: false);

    // Scrape user info after the login is successful
    webViewManager.sendCodeAndNavigate(context);
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

  // Method to save credentials securely using FlutterSecureStorage
  Future<void> _saveCredentials(String email, String password) async {
    await _secureStorage.write(key: 'email', value: email);
    await _secureStorage.write(key: 'password', value: password);
  }
}


