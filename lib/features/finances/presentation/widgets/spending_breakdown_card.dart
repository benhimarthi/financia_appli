import 'package:flutter/material.dart';

class SpendingBreakdownCard extends StatelessWidget {
  const SpendingBreakdownCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Spending Breakdown',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text(
                        'View all',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSpendingItem(
              context,
              color: const Color(0xff1f456e),
              category: 'Rent',
              amount: 1400,
              totalAmount: 3009,
            ),
            _buildSpendingItem(
              context,
              color: Colors.green,
              category: 'Grocery & Dining',
              amount: 680,
              totalAmount: 3009,
            ),
            _buildSpendingItem(
              context,
              color: Colors.orange,
              category: 'Transport',
              amount: 340,
              totalAmount: 3009,
            ),
            _buildSpendingItem(
              context,
              color: Colors.red,
              category: 'Entertainment',
              amount: 280,
              totalAmount: 3009,
            ),
            _buildSpendingItem(
              context,
              color: Colors.grey,
              category: 'Internet & Phone',
              amount: 164,
              totalAmount: 3009,
            ),
            _buildSpendingItem(
              context,
              color: Colors.grey[600]!,
              category: 'Electricity',
              amount: 145,
              totalAmount: 3009,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpendingItem(
    BuildContext context, {
    required Color color,
    required String category,
    required double amount,
    required double totalAmount,
  }) {
    final double percentage = amount / totalAmount;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(category, style: const TextStyle(fontSize: 16)),
              Text(
                '\$${amount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
