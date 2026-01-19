import 'package:flutter/material.dart';

class SavingGoalCard extends StatelessWidget {
  const SavingGoalCard({super.key});

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
                //Text('Saving Goal', style: TextStyle(color: Colors.grey)),
                Container(
                  width: 35,
                  height: 35,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(87, 101, 216, 132),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset("assets/icons/Bullseye.png", scale: 5),
                ),
                Icon(Icons.savings_outlined),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              '\$28,800 left',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: 0.33,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            const SizedBox(height: 8),
            const Text(
              '33% of goals reached',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
