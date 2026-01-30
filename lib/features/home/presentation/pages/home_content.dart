import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/methods/calculate_period_total_transaction.dart';
import 'package:myapp/features/home/presentation/pages/financial_score.dart';
import 'package:myapp/features/transaction/domain/entities/transaction_category.dart';

import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../transaction/domain/entities/transaction.dart';
import '../../../transaction/presentation/bloc/transaction_cubit.dart';
import '../../../transaction/presentation/bloc/transaction_state.dart';
import '../widgets/cash_available_card.dart';
import '../widgets/info_card.dart';
import '../widgets/saving_goal_card.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;
  late List<Transaction> myTransactions;
  late double monthTotalTransaction;

  @override
  void initState() {
    super.initState();
    myTransactions = [];
    monthTotalTransaction = 0;
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccess) {
      context.read<TransactionCubit>().setUserId(authState.user.id);
      context.read<TransactionCubit>().getTransactions();
    }
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  revenuManagementInfos(
    int category, // 1 for income, 2 for expenses
    double amount,
    double percentage,
    String currency,
  ) {
    return Expanded(
      child: InfoCard(
        title: category == 1 ? 'Total Income' : 'Total Expenses',
        amount: '$currency$amount',
        percentage: '+$percentage% vs last month',
        icon: Container(
          padding: const EdgeInsets.all(10),
          //margin: EdgeInsets.only(left: 3),
          decoration: BoxDecoration(
            color: const Color.fromARGB(24, 0, 0, 0),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            category == 1 ? Icons.trending_up : Icons.trending_down,
            color: category == 1 ? Colors.green : Colors.red,
          ),
        ),
        //category == 1 ? Icons.trending_up : Icons.trending_down,
        color: category == 1 ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionCubit, TransactionState>(
      listener: (context, state) {
        if (state is TransactionLoaded) {
          setState(() {
            myTransactions = state.transactions;
            monthTotalTransaction =
                CalculatePeriodTransaction.calculateMonthTotalTransaction(
                  myTransactions,
                  TransactionCategory.income,
                  DateTime.now().month,
                  DateTime.now().year,
                );
          });
        }
      },
      builder: (context, state) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _offsetAnimation,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    FinancialScore(score: 65),
                    Row(
                      children: [
                        Builder(
                          builder: (context) {
                            var periodTransactionTendancy =
                                CalculatePeriodTransaction.calculatePeriodTransactionTendancy(
                                  myTransactions,
                                  TransactionCategory.income,
                                  DateTime.now().month - 1,
                                  DateTime.now().year,
                                  DateTime.now().month,
                                  DateTime.now().year,
                                );
                            return revenuManagementInfos(
                              1,
                              monthTotalTransaction,
                              periodTransactionTendancy,
                              "\$",
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                        revenuManagementInfos(
                          2,
                          CalculatePeriodTransaction.calculateMonthTotalTransaction(
                            myTransactions,
                            TransactionCategory.expense,
                            DateTime.now().month,
                            DateTime.now().year,
                          ),
                          CalculatePeriodTransaction.calculatePeriodTransactionTendancy(
                            myTransactions,
                            TransactionCategory.expense,
                            DateTime.now().month - 1,
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().year,
                          ),
                          "\$",
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .45,
                          height: 180,
                          child: const SavingGoalCard(),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .45,
                          height: 180,
                          child: CashAvailableCard(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Daily Insight',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
