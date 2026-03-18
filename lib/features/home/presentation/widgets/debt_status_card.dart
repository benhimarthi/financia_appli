import 'package:flutter/material.dart';
import 'package:myapp/features/transaction/domain/entities/transaction.dart';

import '../../../../core/methods/calculate_period_total_transaction.dart';

class DebtStatusCard extends StatelessWidget {
  final Transaction debt;
  final List<Transaction> transactions;
  const DebtStatusCard({super.key, required this.debt, required this.transactions});

  @override
  Widget build(BuildContext context) {
    // ✅ SAFE percentage calculation (used everywhere)
    double remainingAmount = CalculatePeriodTransaction.calculateRemainingAmountFromDept(debt, transactions);
    double totAmount = CalculatePeriodTransaction.calculateTotalDebtAmount(debt);
    final double percentage = 1-(remainingAmount/totAmount);
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
                    color: Colors.red.withAlpha(77),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset("assets/icons/debt.png", scale: 5),
                ),
                //const Icon(Icons.savings_outlined),
              ],
            ),
            const SizedBox(height: 8),

            Text(
              '\$${(((debt.amount * (debt.interestRate!)) + debt.amount) - debt.amount).toStringAsFixed(0)} left',
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
                  const AlwaysStoppedAnimation<Color>(Colors.red),
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