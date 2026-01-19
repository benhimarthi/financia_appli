import 'package:flutter/material.dart';

class CashAvailableCard extends StatelessWidget {
  const CashAvailableCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      shadowColor: const Color.fromARGB(82, 0, 0, 0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Cash Available', style: TextStyle(color: Colors.grey)),
                Icon(Icons.account_balance_wallet),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              '\$2,080',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Income - Expenses',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
