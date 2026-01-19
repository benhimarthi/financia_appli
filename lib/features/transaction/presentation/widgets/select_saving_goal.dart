import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// 1. Model for the data
class SavingGoal {
  final String name;
  final double remainingAmount;

  SavingGoal({required this.name, required this.remainingAmount});
}

// 2. The new widget
class SelectSavingGoal extends StatefulWidget {
  final Function(SavingGoal) onGoalSelected;

  const SelectSavingGoal({super.key, required this.onGoalSelected});

  @override
  State<SelectSavingGoal> createState() => _SelectSavingGoalState();
}

class _SelectSavingGoalState extends State<SelectSavingGoal> {
  // Mock data for now
  final List<SavingGoal> _savingGoals = [
    SavingGoal(name: 'Emergency Fund', remainingAmount: 6500),
    SavingGoal(name: 'Vacation 2025', remainingAmount: 1800),
    SavingGoal(name: 'New Car', remainingAmount: 20500),
  ];

  SavingGoal? _selectedGoal;

  @override
  Widget build(BuildContext context) {
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
              color: isSelected ? Colors.green.withOpacity(0.1) : Colors.grey[100],
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
                  '\$${goal.remainingAmount.toStringAsFixed(0)} remaining',
                  style: GoogleFonts.roboto(color: Colors.black54),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
