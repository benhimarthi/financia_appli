import 'package:flutter/material.dart';

class CashAvailableCard extends StatelessWidget {
  final double amount;
  const CashAvailableCard({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Card(
      //elevation: 20,
      shadowColor: Colors.transparent,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Cash Available ', style: TextStyle(color: Colors.grey, fontSize: 18)),
                Icon(Icons.account_balance_wallet),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '\$$amount',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Income - Expenses',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
