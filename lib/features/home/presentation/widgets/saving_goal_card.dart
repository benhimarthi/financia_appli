import 'package:flutter/material.dart';
import 'package:myapp/features/saving_goal/domain/entities/saving_goal.dart';

class SavingGoalCard extends StatelessWidget {
  final SavingGoal savingGoal;
  const SavingGoalCard({super.key, required this.savingGoal});

  @override
  Widget build(BuildContext context) {
    // ✅ SAFE percentage calculation (used everywhere)
    final double percentage =
    savingGoal.targetAmount <= 0
        ? 0
        : (savingGoal.currentAmount / savingGoal.targetAmount)
        .clamp(0.0, 1.0);

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 35,
                  height: 35,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(102, 49, 191, 144),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset("assets/icons/Bullseye.png", scale: 5),
                ),
                const Icon(Icons.savings_outlined),
              ],
            ),
            const SizedBox(height: 8),

            Text(
              '\$${(savingGoal.targetAmount - savingGoal.currentAmount).toStringAsFixed(0)} left',
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            /// ✅ Animated + Safe Progress
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: percentage),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeInOutCubic,
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  value: value,
                  backgroundColor: Colors.grey[300],
                  valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.green),
                );
              },
            ),

            const SizedBox(height: 8),

            Text(
              '${(percentage * 100).toStringAsFixed(2)}% of goals reached',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}