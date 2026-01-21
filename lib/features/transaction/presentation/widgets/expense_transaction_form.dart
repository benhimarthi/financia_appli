import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:myapp/features/transaction/domain/entities/expense_tags.dart';
import 'package:myapp/features/transaction/domain/entities/transaction.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/periodicity.dart';
import '../../domain/entities/transaction_category.dart';
import '../bloc/transaction_cubit.dart';

class ExpenseTransactionForm extends StatefulWidget {
  const ExpenseTransactionForm({super.key});

  @override
  State<ExpenseTransactionForm> createState() => _ExpenseTransactionFormState();
}

class _ExpenseTransactionFormState extends State<ExpenseTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController(text: '0');
  final _noteController = TextEditingController();
  String? _selectedTag;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Add Expense';
    const icon = Icons.trending_down;
    const color = Colors.red;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(icon, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      title,
                      style: GoogleFonts.roboto(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
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
                suffixIcon: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_drop_up,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                  ],
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
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                if (double.parse(value) <= 0) {
                  return 'Amount must be positive';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Preset Amount Chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [10, 25, 50, 100, 200].map((amount) {
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

            // Category Field
            Text(
              'Category',
              style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ExpenseTags.values.map((tag) {
                final tagName = tag.toString().split('.').last;
                final isSelected = _selectedTag == tagName;
                return ChoiceChip(
                  label: Text(tagName),
                  selected: isSelected,
                  selectedColor: color.withAlpha(100),
                  backgroundColor: Colors.grey[200],
                  labelStyle: TextStyle(
                    color: isSelected ? color : Colors.black,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: BorderSide(
                    color: isSelected ? color : Colors.grey[300]!,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      _selectedTag = selected ? tagName : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Note Field
            Text(
              'Note (optional)',
              style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _noteController,
              decoration: InputDecoration(
                hintText: 'Add a quick note...',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Confirm Button
            ElevatedButton.icon(
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text(
                'Confirm',
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
                  if (_selectedTag == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a category')),
                    );
                    return;
                  }

                  final authState = context.read<AuthCubit>().state;
                  if (authState is AuthSuccess) {
                    final transaction = Transaction(
                      id: const Uuid().v4(),
                      userId: authState.user.id,
                      description: _noteController.text,
                      amount: double.parse(_amountController.text),
                      date: DateTime.now(),
                      category: TransactionCategory.expense,
                      periodicity: Periodicity.none,
                      isPrevision: false,
                      tag: _selectedTag!,
                    );
                    //print('Transaction to be added: ${transaction.toJson()}');
                    context.read<TransactionCubit>().addTransaction(
                      transaction,
                    );
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
