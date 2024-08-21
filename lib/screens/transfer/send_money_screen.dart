import 'dart:ffi';

import 'package:ecomzed/screens/layouts/base_page.dart';
import 'package:ecomzed/webview_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendMoneyScreen extends StatelessWidget {
  final Map<String, String> scrapedData;
  final TextEditingController _amountController = TextEditingController();
  
  SendMoneyScreen({required this.scrapedData}); 

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
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: Text('DE'),
              ),
              title: Text('DecCompany001'),
              subtitle: Text('Enrolled as Decco Inc.'),
            ),
            SizedBox(height: 50),
            Text(
              'Enter Amount',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: '0.00',
                suffixIcon: Icon(Icons.help_outline),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            ListTile(
              title: Text('Send Today (One Time)', style: TextStyle(color: Colors.blue)),
              trailing: Icon(Icons.change_circle, color: Colors.blue),
            ),
            SizedBox(height: 20),
            Text(
              'FROM',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.grey[200],
              child: Text(scrapedData['availableBalance']!),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                WebViewManager webViewManager = Provider.of<WebViewManager>(context, listen: false);
                webViewManager.reviewBeforeSend(context, _amountController as Double);
              },
              child: Text('Review'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Implement your logic
              },
              child: Text('Back'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
