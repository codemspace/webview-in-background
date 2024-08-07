import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  final Map<String, String> scrapedData;

  DashboardPage({required this.scrapedData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User Name: ${scrapedData['userName'] ?? 'N/A'}'),
            Text('Total Balance: ${scrapedData['totalBalance'] ?? 'N/A'}'),
            Text('Account Number: ${scrapedData['accountNumber'] ?? 'N/A'}'),
            Text('Available Balance: ${scrapedData['availableBalance'] ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }
}
