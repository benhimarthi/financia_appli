
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/methods/calculate_period_total_transaction.dart';
import 'package:myapp/features/transaction/domain/entities/transaction.dart';
import 'package:myapp/features/transaction/presentation/bloc/transaction_state.dart';

import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../transaction/presentation/bloc/transaction_cubit.dart';

class LiquidWealthCard extends StatefulWidget {
  const LiquidWealthCard({super.key});

  @override
  State<LiquidWealthCard> createState() => _LiquidWealthCardState();
}

class _LiquidWealthCardState extends State<LiquidWealthCard> {
  late double periodAmount;
  late List<Transaction> transactions;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    transactions = [];
    periodAmount = 0;
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccess) {
      context.read<TransactionCubit>().setUserId(authState.user.id);
      context.read<TransactionCubit>().getTransactions();
    }

  }

  // This method would ideally contain the logic to calculate wealth based on the selected period.
  // For now, it just returns a formatted string.
  String _calculateWealthForPeriod(String period) {
    // TODO: Implement your actual calculation logic here based on the period
    return CalculatePeriodTransaction.calculateTotalAvailableCash(
        transactions, DateTime.now().month, DateTime.now().year)
        .toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF0064C5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocConsumer<TransactionCubit, TransactionState>(
                      listener: (context, state){
                        if(state is TransactionLoaded){
                          transactions = state.transactions;
                        }
                        periodAmount = CalculatePeriodTransaction.calculateTotalAvailableCash(transactions, DateTime.now().month, DateTime.now().year);
                      },
                      builder: (context, state){
                        return SizedBox();
                      }
                  ),
                  const Text(
                    'Total Liquid Assets',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(38),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Builder(
                      builder: (context) {
                        //for now we calculate the growth yearly
                        double firstYearDays = CalculatePeriodTransaction.calculateTotalAvailableCash(transactions, 1, DateTime.now().year);
                        double currentYearDays = CalculatePeriodTransaction.calculateTotalAvailableCash(transactions, DateTime.now().month, DateTime.now().year);

                        double growth = ((currentYearDays - firstYearDays) / firstYearDays)*100;
                        return Row(
                          children: [
                            growth >= 0 ? Icon(Icons.trending_up, color: Colors.white, size: 16):
                            Icon(Icons.trending_down, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text(
                              '${growth >= 0 ? '+' : '-'}${double.parse(growth.toStringAsFixed(1))}%', // This could also be dynamic based on the period
                              style: TextStyle(
                                color: growth >= 0 ? Colors.greenAccent : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      }
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '\$$periodAmount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Dropdown for selecting the period
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(51),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text("See history", style: TextStyle(color: Colors.white),)
              ),
            ],
          ),
        );
      }
    );
  }
}