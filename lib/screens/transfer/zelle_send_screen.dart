import 'package:ecomzed/screens/layouts/base_page.dart';
import 'package:flutter/material.dart';

class ZelleSendScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Send money with Zelle',
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionCard('Send', Icons.send),
                  _buildActionCard('Request', Icons.request_page),
                ],
              ),
              SizedBox(height: 50),
              Text('Quick Send', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('DE\nDecCompany...', style: TextStyle(fontWeight: FontWeight.bold)),
                    Icon(Icons.arrow_forward_ios, size: 18),
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

  Widget _buildActionCard(String title, IconData icon) {
    return Card(
      child: Container(
        width: 120,
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            SizedBox(height: 10),
            Text(title),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
    );
  }
}
