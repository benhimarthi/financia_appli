import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/core/methods/calculate_period_total_transaction.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:myapp/features/saving_goal/data/models/saving_goal_model.dart';
import 'package:myapp/features/saving_goal/domain/entities/saving_goal.dart';
import 'package:myapp/features/saving_goal/presentation/cubit/saving_goal_cubit.dart';
import 'package:myapp/features/transaction/domain/entities/periodicity.dart';
import 'package:myapp/features/transaction/domain/entities/transaction.dart';
import 'package:myapp/features/transaction/domain/entities/transaction_category.dart';
import 'package:myapp/features/transaction/presentation/bloc/transaction_cubit.dart';
import 'package:myapp/features/transaction/presentation/bloc/transaction_state.dart';
import 'package:myapp/features/transaction/presentation/widgets/select_saving_goal.dart';
import 'package:uuid/uuid.dart';

class TransferForm extends StatefulWidget {
  final ScrollController? scrollController; // Added controller
  const TransferForm({super.key, this.scrollController}); // Updated constructor

  @override
  State<TransferForm> createState() => _TransferFormState();
}

class _TransferFormState extends State<TransferForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController(text: '0');
  String? _fromAccount;
  String? _toAccount;
  bool _showFromSavingGoals = false;
  bool _showToSavingGoals = false;
  SavingGoal? _selectedFromGoal;
  SavingGoal? _selectedToGoal;

  final List<String> _fromOptions = ['Cash Available', 'Savings'];
  final List<String> _toOptions = [
    'Savings Goal',
    'Cash Available',
    'Debt Payment',
  ];

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccess) {
      context.read<TransactionCubit>().setUserId(authState.user.id);
      context.read<TransactionCubit>().getTransactions();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Replaced the previous structure with a Form containing a ListView.
    // This is the correct way to build a scrollable form within a DraggableScrollableSheet.
    return Form(
      key: _formKey,
      child: ListView(
        controller: widget.scrollController, // Use the passed controller
        padding: const EdgeInsets.all(20.0),
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transfer',
                style: GoogleFonts.roboto(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Amount Field
          Text(
            'Amount',
            style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: GoogleFonts.roboto(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              prefixText: '\$ ',
              prefixStyle: GoogleFonts.roboto(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 16.0,
              ),
            ),
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  double.tryParse(value) == null ||
                  double.parse(value) <= 0) {
                return 'Please enter a valid amount';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),

          // Preset Amount Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [100, 250, 500, 1000].map((amount) {
              return ActionChip(
                label: Text('\$$amount'),
                backgroundColor: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: () {
                  _amountController.text = amount.toString();
                  _formKey.currentState?.validate();
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // From Section
          Text(
            'From',
            style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _fromOptions.map((account) {
              final isSelected = _fromAccount == account;
              return ChoiceChip(
                label: Text(account),
                selected: isSelected,
                selectedColor: Colors.blue[900],
                backgroundColor: Colors.grey[200],
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: BorderSide.none,
                onSelected: (selected) {
                  setState(() {
                    _fromAccount = selected ? account : null;
                    _showFromSavingGoals = selected && account == 'Savings';
                    if (!_showFromSavingGoals) {
                      _selectedFromGoal = null;
                    }
                  });
                },
              );
            }).toList(),
          ),
          if (_showFromSavingGoals)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SelectSavingGoal(
                onGoalSelected: (goal) {
                  setState(() {
                    _selectedFromGoal = goal as SavingGoal?;
                  });
                },
              ),
            ),
          const SizedBox(height: 16),
          Center(child: Icon(Icons.arrow_downward, color: Colors.grey[400])),
          const SizedBox(height: 16),

          // To Section
          Text(
            'To',
            style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _toOptions.map((account) {
              final isSelected = _toAccount == account;
              return ChoiceChip(
                label: Text(account),
                selected: isSelected,
                selectedColor: Colors.green,
                backgroundColor: Colors.grey[200],
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: BorderSide.none,
                onSelected: (selected) {
                  setState(() {
                    _toAccount = selected ? account : null;
                    _showToSavingGoals = selected && account == 'Savings Goal';
                    if (!_showToSavingGoals) {
                      _selectedToGoal = null;
                    }
                  });
                },
              );
            }).toList(),
          ),
          if (_showToSavingGoals)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SelectSavingGoal(
                onGoalSelected: (goal) {
                  setState(() {
                    _selectedToGoal = goal as SavingGoal?;
                  });
                },
              ),
            ),
          const SizedBox(height: 24),

          // Confirm Button
          ElevatedButton.icon(
            icon: const Icon(Icons.check, color: Colors.white),
            label: const Text(
              'Confirm Transfer',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              backgroundColor: Colors.grey[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (_fromAccount == null || _toAccount == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select accounts for the transfer'),
                    ),
                  );
                  return;
                }
                if (_fromAccount == 'Savings' && _selectedFromGoal == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please select a saving goal to transfer from',
                      ),
                    ),
                  );
                  return;
                }
                if (_toAccount == 'Savings Goal' && _selectedToGoal == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please select a saving goal to transfer to',
                      ),
                    ),
                  );
                  return;
                }
                final authState = context.read<AuthCubit>().state;
                if (authState is AuthSuccess) {
                  final fromText = _fromAccount == 'Savings'
                      ? _selectedFromGoal!.name
                      : _fromAccount;
                  final toText = _toAccount == 'Savings Goal'
                      ? _selectedToGoal!.name
                      : _toAccount;
                  final currentAccountAmount =
                      CalculatePeriodTransaction.calculateTotalAvailableCash(
                        context.read<TransactionCubit>().state
                                is TransactionLoaded
                            ? (context.read<TransactionCubit>().state
                                      as TransactionLoaded)
                                  .transactions
                            : [],
                        DateTime.now().month,
                        DateTime.now().year,
                      );
                  double transactionValue = 0;
                  double value = double.parse(_amountController.text);

                  if (_fromAccount == 'Cash Available') {
                    if (value > currentAccountAmount) {
                      transactionValue = currentAccountAmount;
                    } else {
                      transactionValue = value;
                    }
                  } else if (_fromAccount == 'Savings') {
                    if (value > _selectedFromGoal!.currentAmount) {
                      transactionValue = _selectedFromGoal!.currentAmount;
                    } else {
                      transactionValue =
                          _selectedFromGoal!.currentAmount - value;
                    }
                    if (_selectedFromGoal != null) {
                      var currentGoalModel = SavingGoalModel.fromSavingGoal(
                        _selectedFromGoal!,
                      );
                      var updatedGoalModel = currentGoalModel.copyWith(
                        currentAmount: transactionValue,
                      );
                      context.read<SavingGoalCubit>().updateSavingGoal(
                        updatedGoalModel,
                      );
                    }
                  }
                  if (_selectedToGoal != null) {
                    var updatedVal =
                        double.parse(
                          _selectedToGoal!.currentAmount.toString(),
                        ) +
                        value;
                    var currentGoalModel = SavingGoalModel.fromSavingGoal(
                      _selectedToGoal!,
                    );
                    var updatedGoalModel = currentGoalModel.copyWith(
                      currentAmount: updatedVal,
                    );
                    context.read<SavingGoalCubit>().updateSavingGoal(
                      updatedGoalModel,
                    );
                  }

                  final transaction = Transaction(
                    id: const Uuid().v4(),
                    userId: authState.user.id,
                    amount: transactionValue,
                    category: TransactionCategory.transfert,
                    date: DateTime.now(),
                    description: 'Transfer from $fromText to $toText',
                    periodicity: Periodicity.none,
                    tag: 'Transfer',
                    isPrevision: false,
                    isTransfer: true,
                    transferDetails: {
                      'from': _fromAccount == 'Savings'
                          ? _selectedFromGoal!.id
                          : _fromAccount,
                      'to': _toAccount == 'Savings Goal'
                          ? _selectedToGoal!.id
                          : _toAccount,
                    },
                  );
                  context.read<TransactionCubit>().addTransaction(transaction);
                  Navigator.of(context).pop();
                }
              }
            },
          ),
          const SizedBox(height: 40), // Added some padding at the bottom
        ],
      ),
    );
  }
}
