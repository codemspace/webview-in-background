import 'package:ecomzed/webview_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyCodeScreen extends StatelessWidget {
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 104,4,100),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                'Ally',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "We need to make sure",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Text(
              "it's you",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 24),
            Text(
              "We sent a security code to: (XXX) XXX-9382\nWhen you get it, enter it below.\nThe code will expire 20 minutes after you receive it.",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 32),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: 'Enter security code',
                border: OutlineInputBorder(),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text("Resend Security Code"),
              style: TextButton.styleFrom(
                foregroundColor: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                String code = _codeController.text;
                print('----- Entered code: ${code} -----');
                WebViewManager webViewManager = Provider.of<WebViewManager>(context, listen: false);

                webViewManager.verifyCodeAndNavigate(code, context);
              },
              child: Text("Continue"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
                minimumSize: Size.fromHeight(50),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              child: Text("Back"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.deepPurple,
                minimumSize: Size.fromHeight(50),
              ),
            ),
            SizedBox(height: 46),
            Text(
              "If you chose text and don't get your security code within a minute or so, text \"Optin\" to 25595. Then, choose Resend Security Code.",
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}