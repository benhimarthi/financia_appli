import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/saving_goal/presentation/cubit/saving_goal_cubit.dart';
import 'package:myapp/features/saving_goal/presentation/widgets/saving_goal_list.dart';

class SavingGoalPage extends StatelessWidget {
  final String userId;

  const SavingGoalPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saving Goals'),
      ),
      body: BlocProvider(
        create: (context) =>
            SavingGoalCubit(getSavingGoals: context.read(), addSavingGoal: context.read(), updateSavingGoal: context.read(), deleteSavingGoal: context.read())..getSavingGoals(userId),
        child: BlocBuilder<SavingGoalCubit, SavingGoalState>(
          builder: (context, state) {
            if (state is SavingGoalLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SavingGoalLoaded) {
              return SavingGoalList(savingGoals: state.savingGoals);
            } else if (state is SavingGoalError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('No saving goals found.'));
          },
        ),
      ),
    );
  }
}
