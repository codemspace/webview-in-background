import 'package:ecomzed/screens/layouts/base_page.dart';
import 'package:ecomzed/webview_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectRecipientScreen extends StatelessWidget {
  final List<Map<String, String>> scrapedData;
  
  SelectRecipientScreen({required this.scrapedData}); 

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
              SizedBox(height: 80),
              Text(
                'Select Recipient',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Name, email, mobile #, account #',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.add),
                label: Text('New Contact'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.purple,
                  backgroundColor: Colors.white,
                ),
              ),
              SizedBox(height: 40),
              Text(
                'Recent Recipients',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Divider(),
              ElevatedButton(
                onPressed: () {
                  WebViewManager webViewManager = Provider.of<WebViewManager>(context, listen: false);
                  webViewManager.clickOneRecipient(context, 0);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Background color
                  foregroundColor: Colors.black, // Text and icon color
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // To minimize the button width
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        scrapedData[0]['countryCode']!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Text color inside the circle
                        ),
                      ),
                    ),
                    SizedBox(width: 10), // Space between icon and text
                    Text(scrapedData[0]['companyName']!,
                        style: TextStyle(color: Colors.black)), // Text color
                  ],
                ),
              )
              // ...List.generate(scrapedData.length, (i) {
              //   WebViewManager webViewManager = Provider.of<WebViewManager>(context, listen: false);
              //   return GestureDetector(
              //     onTap: () => {
              //       webViewManager.clickOneRecipient(context, i)
              //     },
              //     child: ListTile(
              //       leading: Container(
              //         padding: EdgeInsets.all(8),
              //         decoration: BoxDecoration(
              //           color: Colors.grey[200],
              //           shape: BoxShape.circle,
              //         ),
              //         child: Text(
              //           scrapedData[i]['countryCode']!,
              //           style: TextStyle(fontWeight: FontWeight.bold),
              //         ),
              //       ),
              //       title: Text(scrapedData[i]['companyName']!),
              //     )
              //   );
              // }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon) {
    return Card(
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
