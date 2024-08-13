import 'package:ecomzed/screens/layouts/base_page.dart';
import 'package:flutter/material.dart';
import 'payment_details.dart'; 

class PaymentDetailsOverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      child: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text(
            'Payment details',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Securely add or remove payment methods to make it easier when you book.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 16),
          buildPaymentOption(
            context,
            title: 'Payment cards',
            description: 'Pay with new card',
            actionText: 'Add card',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaymentDetailsPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildPaymentOption(BuildContext context, {
    required String title,
    required String description,
    required String actionText,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          GestureDetector(
            onTap: onTap,
            child: Text(
              actionText,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
