import 'package:ecomzed/screens/profile/other_travelers.dart';
import 'package:ecomzed/screens/profile/payment_details_overview.dart';
import 'package:ecomzed/screens/profile/personal_details.dart';
import 'package:ecomzed/screens/profile/privacy_settings.dart';
import 'package:ecomzed/screens/profile/security_settings.dart';
import 'package:ecomzed/webview_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final Map<String, String> scrapedData;
  
  HomeScreen({required this.scrapedData});  
  
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Complete: ${scrapedData.toString()}'),
          duration: Duration(seconds: 2),
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 104,4,100),
        title: Row(
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
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Snapshot',
              style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hello Ryan',
                  style: TextStyle(fontSize: 22, color: Colors.black87),
                ),
                Text(
                  "\$48",
                  style: TextStyle(fontSize: 22, color: Colors.black87),
                ),
              ]
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "+ Customize",
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ]
            ),
            SizedBox(height: 20),
            Text(
              'Bank Accounts',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black54, width: 1)
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Spending Account',
                        style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Available',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '••3849',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$48.00',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$48.00',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ]
              )
            ),
            SizedBox(height: 50),
            Text(
              'Make a One-Time Transfer',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField(
              items: ['Select an Account', 'Account 1', 'Account 2']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {},
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'From account',
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField(
              items: ['Select an Account', 'Account 1', 'Account 2']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {},
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'To account',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text('More transfer options'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.deepPurple,
                backgroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 140),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    print('----------------- Go to profile page ---------------------');
                    WebViewManager webViewManager = Provider.of<WebViewManager>(context, listen: false);

                    print('----------------- Go to profile page ---------------------');
                    webViewManager.scrapeAndNavigateProfile(context);
                  },
                  child: Text('Profile Setting'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.deepPurple,
                  ),
                ),
              ]
            ),
          ],
        ),
      ),
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
                onTap: () {},
              ),
              ListTile(
                title: Text('Zelle', style: TextStyle(color: Colors.blue)),
                onTap: () {},
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

  
  
  void _showAccountModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            buildCard(
              context,
              icon: Icons.person,
              title: 'Personal details',
              description: 'Update your info and find out how it\'s used.',
              linkText: 'Manage personal details',
              destination: PersonalDetailsPage(),
            ),
            buildCard(
              context,
              icon: Icons.lock,
              title: 'Security',
              description: 'Change your security settings, set up secure authentication, or delete your account.',
              linkText: 'Manage account security',
              destination: SecuritySettingsPage(),
            ),
            buildCard(
              context,
              icon: Icons.privacy_tip,
              title: 'Privacy',
              description: 'Exercise your privacy rights and control how your data is used.',
              linkText: 'Manage privacy',
              destination: PrivacySettingsPage(),
            ),
            buildCard(
              context,
              icon: Icons.payment,
              title: 'Payment details',
              description: 'Securely add or remove payment methods to make it easier when you book.',
              linkText: 'Manage payment details',
              destination: PaymentDetailsOverviewPage(),
            ),
            buildCard(
              context,
              icon: Icons.group,
              title: 'Other travelers',
              description: 'Add or edit info about the people you’re traveling with.',
              linkText: 'Manage travelers',
              destination: OtherTravelersPage(), 
            ),
          ],
        );
      }
    );
  }

  
  Widget buildCard(BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required String linkText,
    required Widget destination,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      linkText,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
