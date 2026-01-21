import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/features/saving_goal/presentation/cubit/saving_goal_cubit.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../saving_goal/domain/entities/saving_goal.dart';

// 2. The new widget
class SelectSavingGoal extends StatefulWidget {
  final Function(SavingGoal) onGoalSelected;

  const SelectSavingGoal({super.key, required this.onGoalSelected});

  @override
  State<SelectSavingGoal> createState() => _SelectSavingGoalState();
}

class _SelectSavingGoalState extends State<SelectSavingGoal> {
  // Mock data for now

  late List<SavingGoal> _savingGoals;
  SavingGoal? _selectedGoal;
  @override
  void initState() {
    super.initState();
    _savingGoals = [];
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccess) {
      context.read<SavingGoalCubit>().getSavingGoals(authState.user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      listener: (context, state) {
        if (state is SavingGoalLoaded) {
          _savingGoals = state.savingGoals;
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Saving Goal',
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _savingGoals.length,
              itemBuilder: (context, index) {
                final goal = _savingGoals[index];
                final isSelected = _selectedGoal == goal;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  elevation: 0,
                  color: isSelected
                      ? Colors.green.withAlpha(26)
                      : Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected ? Colors.green : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: ListTile(
                    onTap: () {
                      setState(() {
                        _selectedGoal = goal;
                      });
                      widget.onGoalSelected(goal);
                    },
                    leading: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Icon(
                        Icons.track_changes,
                        color: isSelected ? Colors.green : Colors.grey[600],
                      ),
                    ),
                    title: Text(
                      goal.name,
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      '\$${goal.currentAmount.toStringAsFixed(0)} remaining',
                      style: GoogleFonts.roboto(color: Colors.black54),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
