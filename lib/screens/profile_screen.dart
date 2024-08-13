import 'package:ecomzed/screens/profile/other_travelers.dart';
import 'package:ecomzed/screens/profile/payment_details_overview.dart';
import 'package:ecomzed/screens/profile/personal_details.dart';
import 'package:ecomzed/screens/profile/privacy_settings.dart';
import 'package:ecomzed/screens/profile/security_settings.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final Map<String, String> scrapedData;

  ProfileScreen({required this.scrapedData});

  @override
  Widget build(BuildContext context) {
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
              'Profile and Setting',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            Divider(),
            Text(
              'Username',
              style: TextStyle(color: Colors.grey[800], fontSize: 30),
            ),
            SizedBox(height: 16),
            Text(
              'Current Username',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
            Text(
              'decuser002',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 42),
            TextFormField(
              initialValue: 'DecUser002',
              decoration: InputDecoration(
                labelText: 'New username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Username Requirements',
              style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text('✔ Your username cannot contain *^()|'),
            Text('✔ At least 1 letter'),
            Text('✔ 4 to 28 characters, no spaces'),
            SizedBox(height: 28),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {},
              child: Text('Why do we need your password?'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.deepPurple,
                backgroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('Change Username'),
            ),
          ],
        ),
      ),
      // Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text('User Name: ${scrapedData['name'] ?? 'N/A'}'),
      //       Text('Email: ${scrapedData['email'] ?? 'N/A'}'),
      //       Text('Phone Number: ${scrapedData['phone'] ?? 'N/A'}'),
      //       Text('Primary Address: ${scrapedData['primaryAddress'] ?? 'N/A'}'),
      //       Text('Mailing Address: ${scrapedData['mailingAddress'] ?? 'N/A'}'),
      //     ],
      //   ),
      // ),
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
}
