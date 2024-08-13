import 'package:ecomzed/webview_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BasePage extends StatelessWidget {
  final Widget child;

  BasePage({required this.child});

  @override
  Widget build(BuildContext context) {
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
      body: child,
    );
  }

  void _showAccountModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: [
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Manage account'),
              onTap: () {}, 
            ),
            ListTile(
              leading: Icon(Icons.card_travel),
              title: Text('Trips'),
              onTap: () {}, 
            ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text('Genius loyalty program'),
              onTap: () {}, 
            ),
            ListTile(
              leading: Icon(Icons.wallet_giftcard),
              title: Text('Rewards & Wallet'),
              onTap: () {}, 
            ),
            ListTile(
              leading: Icon(Icons.comment),
              title: Text('Reviews'),
              onTap: () {}, 
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Saved'),
              onTap: () {}, 
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sign out'),
              onTap: () {}, 
            ),
          ],
        );
      }
    );
  }

  void _showMenuModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Transfer and Pay',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              ListTile(
                title: Text('Transfers', style: TextStyle(color: Colors.blue)),
                onTap: () {

                },
              ),
              ListTile(
                title: Text('Zelle', style: TextStyle(color: Colors.blue)),
                onTap: () {
                  
                },
              ),
              ListTile(
                title: Text('Bill Pay', style: TextStyle(color: Colors.blue)),
                onTap: () {},
              ),
              Divider(color: Colors.grey[300]),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Checks',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              ListTile(
                title: Text('Deposit Checks', style: TextStyle(color: Colors.blue)),
                onTap: () {},
              ),
              ListTile(
                title: Text('Order Checks', style: TextStyle(color: Colors.blue)),
                onTap: () {},
              ),
              Divider(color: Colors.grey[300]),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Preferences',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              ListTile(
                title: Text('Alerts', style: TextStyle(color: Colors.blue)),
                onTap: () {},
              ),
              ListTile(
                title: Text('Linked Accounts', style: TextStyle(color: Colors.blue)),
                onTap: () {},
              ),
              ListTile(
                title: Text('Debit Card', style: TextStyle(color: Colors.blue)),
                onTap: () {},
              ),
            ],
          ),
        );
      }
    );
  }
}
  
void _handleZelle(BuildContext context) async {
  WebViewManager webViewManager = Provider.of<WebViewManager>(context, listen: false);

  webViewManager.navigateZelle(context);
}