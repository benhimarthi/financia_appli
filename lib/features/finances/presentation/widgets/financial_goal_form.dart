import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/features/saving_goal/domain/entities/saving_goal.dart';
import 'package:myapp/features/saving_goal/presentation/cubit/saving_goal_cubit.dart';
import 'package:myapp/features/transaction/domain/entities/periodicity.dart';
import 'package:myapp/features/transaction/domain/entities/transaction.dart';
import 'package:myapp/features/transaction/domain/entities/transaction_category.dart';
import 'package:myapp/features/transaction/presentation/bloc/transaction_cubit.dart';
import 'package:uuid/uuid.dart';

import '../../../auth/presentation/bloc/auth_cubit.dart';

class FinancialGoalForm extends StatefulWidget {
  const FinancialGoalForm({super.key});

  @override
  _FinancialGoalFormState createState() => _FinancialGoalFormState();
}

class _FinancialGoalFormState extends State<FinancialGoalForm> {
  final _formKey = GlobalKey<FormState>();
  String _goalName = '';
  double _targetAmount = 0.0;
  double _currentAmount = 0.0;
  DateTime _targetDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _targetDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _targetDate) {
      setState(() {
        _targetDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      /*widget.onSubmit(
        _goalName,
        _targetAmount,
        _currentAmount,
        _targetDate,
        DateTime.now(),
      );*/
      final authState = context.read<AuthCubit>().state;
      if (authState is AuthSuccess) {
        var goal = SavingGoal(
          id: Uuid().v4(),
          userId: authState.user.id,
          name: _goalName,
          targetAmount: _targetAmount,
          currentAmount: _currentAmount,
          targetDate: _targetDate,
          date: DateTime.now(),
        );
        context.read<SavingGoalCubit>().addSavingGoal(goal);
        var trans = Transaction(
          id: Uuid().v4(),
          userId: authState.user.id,
          amount: _currentAmount,
          category: TransactionCategory.transfert,
          date: DateTime.now(),
          description: "transfert fund to saving account",
          periodicity: Periodicity.none,
          tag: "transfert",
          isPrevision: false,
          isTransfer: true,
        );
        context.read<TransactionCubit>().addTransaction(trans);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
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
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saving goal',
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        /*Text(
                          '${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}',
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),*/
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Goal name',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a goal name';
                }
                return null;
              },
              onSaved: (value) {
                _goalName = value!;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Target amount',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || double.tryParse(value) == null) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
              onSaved: (value) {
                _targetAmount = double.parse(value!);
              },
            ),
            const SizedBox(height: 20),
            Container(width: double.infinity, height: 1, color: Colors.black12),
            const SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(61, 255, 172, 64),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child: Text(
                'The current amount will be taken from your current available cash,'
                'You can you the transfert option for futher cash movements',
                style: TextStyle(color: Colors.black54),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Current Amount',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || double.tryParse(value) == null) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
              onSaved: (value) {
                _currentAmount = double.parse(value!);
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Target Date: ${DateFormat.yMd().format(_targetDate)}",
                  ),
                ),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Select Date'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.grey[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: Text('Add Goal'),
            ),
          ],
        ),
      ),
    );
  }
}
