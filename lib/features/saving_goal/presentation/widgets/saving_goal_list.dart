import 'package:flutter/material.dart';
import 'package:myapp/features/saving_goal/domain/entities/saving_goal.dart';

class SavingGoalList extends StatelessWidget {
  final List<SavingGoal> savingGoals;

  const SavingGoalList({super.key, required this.savingGoals});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: savingGoals.length,
      itemBuilder: (context, index) {
        final savingGoal = savingGoals[index];
        return ListTile(
          title: Text(savingGoal.name),
          subtitle: Text(
              '${savingGoal.currentAmount} / ${savingGoal.targetAmount}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // TODO: Implement delete saving goal
            },
          ),
        );
      },
    );
  }
}
