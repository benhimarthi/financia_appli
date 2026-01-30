import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String amount;
  final String percentage;
  final Widget icon;
  final Color color;

  const InfoCard({
    super.key,
    required this.title,
    required this.amount,
    required this.percentage,
    required this.icon,
    required this.color,
  });

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
              children: [
                SizedBox(
                  width: 65,
                  child: Text(
                    title,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 4),
                icon,
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: Text(
                '\$${amount.replaceAll(RegExp(r'[^0-9.]'), '')}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(percentage, style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }
}
