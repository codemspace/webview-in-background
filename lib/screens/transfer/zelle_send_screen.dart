import 'package:ecomzed/screens/layouts/base_page.dart';
import 'package:ecomzed/webview_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ZelleSendScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Send money with Zelle',
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionCard(context, 'Send', Icons.send),
                  _buildActionCard(context, 'Request', Icons.request_page),
                ],
              ),
              SizedBox(height: 50),
              Text('Quick Send', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(vertical: 22, horizontal: 22),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('DecCompany...', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Icon(Icons.arrow_forward_ios, size: 22),
                  ],
                ),
              ),
              SizedBox(height: 40),
              _buildLinkText('Manage Recipients'),
              _buildLinkText('Split a Bill'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon) {
    WebViewManager webViewManager = Provider.of<WebViewManager>(context, listen: false);

    return GestureDetector(
      onTap: () => {
        if (title == 'Send') {
          webViewManager.toSend(context)
        } else if (title == 'Request') {
          webViewManager.toRequest(context)
        } else {
          print('----- Not send or request -----')
        }
      },
      child: Card(
          child: Container(
            width: 160,
            height: 160,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 50, color: Colors.blue),
                SizedBox(height: 10),
                Text(title, style: TextStyle(fontSize: 22),),
              ],
            ),
          ),
        )
    );
  }

  Widget _buildLinkText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold),
      ),
    );
  }
}
