import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/methods/calculate_period_total_transaction.dart';
import 'package:myapp/features/home/presentation/pages/financial_score.dart';
import 'package:myapp/features/home/presentation/widgets/debt_status_card.dart';
import 'package:myapp/features/saving_goal/presentation/widgets/saving_goal_list.dart';
import 'package:myapp/features/transaction/presentation/widgets/transactions_list.dart';
import 'package:myapp/features/saving_goal/data/models/saving_goal_model.dart';
import 'package:myapp/features/saving_goal/presentation/cubit/saving_goal_cubit.dart';
import 'package:myapp/features/transaction/domain/entities/transaction_category.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../saving_goal/domain/entities/saving_goal.dart';
import '../../../transaction/data/models/transaction_model.dart';
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
  late List<Transaction> myTransactions;
  late List<SavingGoal> mySavingGoals;
  late double monthTotalTransaction;

  // We'll create several animations with different intervals
  late Animation<double> _fadeMain;
  late Animation<double> _scaleMain;
  late Animation<Offset> _slideMain;

  late Animation<double> _fadeIncomeExpense;
  late Animation<double> _scaleIncomeExpense;

  late Animation<double> _fadeBottomRow;

  @override
  void initState() {
    super.initState();
    myTransactions = [];
    mySavingGoals = [];
    monthTotalTransaction = 0;

    final authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccess) {
      context.read<TransactionCubit>().setUserId(authState.user.id);
      context.read<TransactionCubit>().getTransactions();
      context.read<SavingGoalCubit>().getSavingGoals(authState.user.id);
    }

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    // ── Main content (Financial Score) ──
    _fadeMain = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.7, curve: Curves.easeInOutCubicEmphasized),
      ),
    );
    _scaleMain = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.7, curve: Curves.easeInOutCubicEmphasized),
      ),
    );

    // ── Income / Expense row ── (appears a bit later)
    _fadeIncomeExpense = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 0.85, curve: Curves.easeOutCubic),
      ),
    );
    _scaleIncomeExpense = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    // ── Bottom row (carousel + cash) ──
    _fadeBottomRow = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.45, 1.0, curve: Curves.easeInOutCubicEmphasized),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimated(Animation<double> fade, Animation<double> scale, Widget child) {
    return FadeTransition(
      opacity: fade,
      child: ScaleTransition(
        scale: scale,
        child: child,
      ),
    );
  }

  void showBlurDialog(BuildContext context, TransactionCategory category) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      barrierColor: Colors.black.withAlpha(77),
      transitionDuration: const Duration(milliseconds: 350),

      pageBuilder: (context, animation, secondaryAnimation) {
        // Required but unused because we use transitionBuilder
        return const SizedBox();
      },

      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: FadeTransition(
            opacity: curvedAnimation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.15), // 🔥 Slight bottom slide
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: Center(
                child: TransactionsList(
                  category: category
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showSavingGoalList(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      barrierColor: Colors.black.withAlpha(77),
      transitionDuration: const Duration(milliseconds: 350),

      pageBuilder: (context, animation, secondaryAnimation) {
        // Required but unused because we use transitionBuilder
        return const SizedBox();
      },

      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: FadeTransition(
            opacity: curvedAnimation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.15), // 🔥 Slight bottom slide
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: Center(
                child: SavingGoalList(),
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper (same as before)
  Widget revenueManagementInfos(
      TransactionCategory category, // 1 income, 2 expenses
      double amount,
      double percentage,
      String currency,
      ) {
    return Expanded(
      child: GestureDetector(
        onTap: (){
          showBlurDialog(context, category);
        },
        child: InfoCard(
          title: 'Total ${category.name}',
          amount: '$currency${amount.toStringAsFixed(0)}',
          percentage: '${percentage.toStringAsFixed(1)}% vs last month',
          icon: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(24, 0, 0, 0),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              category == TransactionCategory.income ? Icons.trending_up : Icons.trending_down,
              color: category == TransactionCategory.income ? Colors.green : Colors.red,
            ),
          ),
          color: category == TransactionCategory.income ? Colors.green : Colors.red,
        ),
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
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Financial Score – first to appear
                _buildAnimated(_fadeMain, _scaleMain, FinancialScore(score: 65, transactions: myTransactions)),

                const SizedBox(height: 24),

                // Income + Expenses row
                _buildAnimated(
                  _fadeIncomeExpense,
                  _scaleIncomeExpense,
                  Row(
                    children: [
                      Builder(
                        builder: (context) {
                          var periodTransactionTendancy =
                              CalculatePeriodTransaction.calculateMonthEvolution(
                                myTransactions,
                                TransactionCategory.income,
                                DateTime.now().month,
                                DateTime.now().year,
                              ) *
                                  100;
                          return revenueManagementInfos(
                            TransactionCategory.income,
                            monthTotalTransaction,
                            periodTransactionTendancy,
                            "\$",
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      revenueManagementInfos(
                        TransactionCategory.expense,
                        CalculatePeriodTransaction.calculateMonthTotalTransaction(
                          myTransactions,
                          TransactionCategory.expense,
                          DateTime.now().month,
                          DateTime.now().year,
                        ),
                        CalculatePeriodTransaction.calculateMonthEvolution(
                          myTransactions,
                          TransactionCategory.expense,
                          DateTime.now().month,
                          DateTime.now().year,
                        ) *
                            100,
                        "\$",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Bottom row – Saving goals carousel + Cash card
                _buildAnimated(
                  _fadeBottomRow,
                  _fadeBottomRow, // using fade also as proxy for scale
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      BlocConsumer<SavingGoalCubit, SavingGoalState>(
                        listener: (context, state) {
                          if (state is SavingGoalLoaded) {
                            mySavingGoals = state.savingGoals;
                          }
                        },
                        builder: (context, state) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: 180,
                            child: CarouselSlider(
                              options: CarouselOptions(
                                height: 180,
                                viewportFraction: 1.0,
                                enlargeCenterPage: false,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 6),
                              ),
                              items: mySavingGoals.isEmpty
                                  ? [SavingGoalCard(savingGoal: SavingGoalModel.empty())]
                                  : mySavingGoals
                                  .map((x) => GestureDetector(
                                onTap:(){
                                  showSavingGoalList(context);
                                },
                                    child: SavingGoalCard(savingGoal: x)
                              ))
                                  .toList(),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: 180,
                        child: CarouselSlider(
                          options: CarouselOptions(
                            height: 180,
                            viewportFraction: 1.0,
                            enlargeCenterPage: false,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 6),
                          ),
                          items: myTransactions.isEmpty
                              ? []
                              : myTransactions.where((x)=>x.category == TransactionCategory.debt).toList()
                              .map((x) => GestureDetector(
                            onTap: (){
                              showBlurDialog(context, TransactionCategory.debt);
                            },
                            child: DebtStatusCard(debt : x, transactions: myTransactions),
                          ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                const Text(
                  'Daily Insight',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // ... you can continue adding more sections with new staggered animations
              ],
            ),
          ),
        );
      },
    );
  }
}