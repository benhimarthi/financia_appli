import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/core/methods/calculate_period_total_transaction.dart';
import 'package:myapp/core/methods/format_number.dart';
import 'package:myapp/features/saving_goal/presentation/cubit/saving_goal_cubit.dart';
import 'package:myapp/features/transaction/domain/entities/transaction.dart';
import 'package:myapp/features/transaction/domain/entities/transaction_category.dart';
import 'package:myapp/features/transaction/presentation/bloc/transaction_cubit.dart';
import 'package:myapp/features/transaction/presentation/bloc/transaction_state.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../saving_goal/domain/entities/saving_goal.dart';

// 2. The new widget
class SelectDebt extends StatefulWidget {
  final Function(Transaction) onDebtSelected;

  const SelectDebt({super.key, required this.onDebtSelected});

  @override
  State<SelectDebt> createState() => _SelectDebtState();
}

class _SelectDebtState extends State<SelectDebt> {
  // Mock data for now

  late List<Transaction> _debt;
  late List<Transaction> _transactions;
  Transaction? _selectedDebt;
  @override
  void initState() {
    super.initState();
    _debt = [];
    _transactions = [];
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccess) {
      context.read<TransactionCubit>().setUserId(authState.user.id);
      context.read<TransactionCubit>().getTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionCubit, TransactionState>(
      listener: (context, state) {
        if (state is TransactionLoaded) {
          _transactions = state.transactions;
          _debt = state.transactions.where((x)=>x.category == TransactionCategory.debt).toList();
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Debt',
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
              itemCount: _debt.length,
              itemBuilder: (context, index) {
                final debt = _debt[index];
                final isSelected = _selectedDebt == debt;
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
                        _selectedDebt = debt;
                      });
                      widget.onDebtSelected(debt);
                    },
                    leading: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Icon(
                        Icons.track_changes,
                        color: isSelected ? Colors.green : Colors.grey[600],
                      ),
                    ),
                    title: Text(
                      debt.tag,
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Builder(
                      builder: (context) {
                        double remainingAmount  = CalculatePeriodTransaction.calculateRemainingAmountFromDept(debt, _transactions);
                        return Text(
                          '\$${formatNumber(remainingAmount)} remaining',
                          style: GoogleFonts.roboto(color: Colors.black54),
                        );
                      }
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
