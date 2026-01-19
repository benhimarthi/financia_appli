import 'package:flutter/material.dart';

class ContinueLearningCard extends StatelessWidget {
  const ContinueLearningCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Continue Learning', style: Theme.of(context).textTheme.titleLarge),
                Chip(
                  label: const Text('In Progress'),
                  backgroundColor: Colors.green.shade100,
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                //Icon(Icons.attach_money, color: Colors.orange, size: 40),
                const Text('💰', style: TextStyle(fontSize: 40)),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Setting Financial Goals', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Budgeting Basics • 7 min', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                const Icon(Icons.play_arrow, size: 40, color: Colors.blue),
              ],
            )
          ],
        ),
      ),
    );
  }
}
