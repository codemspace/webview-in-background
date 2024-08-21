import 'package:ecomzed/screens/layouts/base_page.dart';
import 'package:ecomzed/webview_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewSendScreen extends StatelessWidget {
  final Map<String, String> scrapedData;
  
  ReviewSendScreen({required this.scrapedData}); 

  @override
  Widget build(BuildContext context) {

    return BasePage(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Send money with Zelle',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50),
            Text(
              'Review and Send',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              scrapedData['h3'] ?? 'N/A',
              style: TextStyle(fontSize: 20, color: Colors.deepPurple),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: Text('DE'),
              ),
              title: Text('DecCompany001'),
              subtitle: Text('Enrolled as Decco Inc. \nat company001@thedeccocompany.com'),
            ),
            SizedBox(height: 30),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Reason (Optional)',
                border: OutlineInputBorder(),
              ),
            ),
            // Text(
            //   'Remember not to enter a debit or credit card number.',
            //   style: TextStyle(color: Colors.red),
            // ),
            SizedBox(height: 20),
            Text(
              'The money will be delivered to DecCompany001 typically within minutes.',
            ),
            SizedBox(height: 20),
            Text(
              'By choosing Send you authorize this payment. It will be sent now and cannot be canceled. If you have any questions, call us anytime at 1-877-247-2559.',
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Back'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      WebViewManager webViewManager = Provider.of<WebViewManager>(context, listen: false);
                      webViewManager.clickSend();
                      webViewManager.clickSendAgain();
                    },
                    child: Text('Send'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
