import 'package:flutter/material.dart';

class FinancialGoalsCard extends StatelessWidget {
  const FinancialGoalsCard({super.key});

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
                  'Financial Goals',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text(
                        'View All',
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
            _buildGoalItem(
              icon: Icons.shield,
              color: Colors.green,
              title: 'Emergency Fund',
              currentAmount: 8500,
              totalAmount: 15000,
            ),
            const SizedBox(height: 16),
            _buildGoalItem(
              icon: Icons.flight,
              color: Colors.blue,
              title: 'Vacation 2025',
              currentAmount: 1200,
              totalAmount: 3000,
            ),
            const SizedBox(height: 16),
            _buildGoalItem(
              icon: Icons.directions_car,
              color: Colors.orange,
              title: 'New Car',
              currentAmount: 4500,
              totalAmount: 25000,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalItem({
    required IconData icon,
    required Color color,
    required String title,
    required double currentAmount,
    required double totalAmount,
  }) {
    final double percentage = currentAmount / totalAmount;
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.1),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${currentAmount.toStringAsFixed(0)} of \$${totalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const Spacer(),
            Text(
              '${(percentage * 100).toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
    );
  }
}
