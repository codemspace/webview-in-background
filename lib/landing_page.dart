import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'webview_manager.dart';
import 'login_form.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF311b92), // Background color
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(height: 40),
              _buildTitle(),
              SizedBox(height: 16),
              _buildDescription(),
              SizedBox(height: 32),
              _buildGetStartedButton(context),
              SizedBox(height: 32),
              _buildImageWithText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'ally',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () => _showLoginDialog(context),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            textStyle: TextStyle(fontSize: 18),
          ),
          child: Text('Log In'),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      'Set up faster. Get paid sooner with early direct deposit.',
      style: TextStyle(
        fontSize: 28,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        height: 1.2, // Line height
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      'With simple digital setup and potential to get paid up to two days earlier, there’s no reason not to use direct deposit.',
      style: TextStyle(
        fontSize: 18,
        color: Colors.white70,
        height: 1.4,
      ),
    );
  }

  Widget _buildGetStartedButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          foregroundColor: Color(0xFF9c27b0),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          'Get Started',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildImageWithText() {
    return Center(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: 200,
            height: 350,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.deepPurple[400],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Spending Snapshot',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '\$4,327.49',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Early payday is here\nwith direct deposit!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLoginDialog(BuildContext context) {
    Provider.of<WebViewManager>(context, listen: false)
      .prepareLoginPage();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: LoginForm(),
        );
      },
    );
  }
}


