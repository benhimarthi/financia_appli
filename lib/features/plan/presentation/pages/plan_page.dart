import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/methods/calculate_period_total_transaction.dart';
import 'package:myapp/core/methods/format_number.dart';
import 'package:myapp/features/plan/presentation/widgets/transaction_preview_category_selector.dart';
import 'package:myapp/features/plan/presentation/widgets/plan_info_card.dart';
import 'package:myapp/features/plan/presentation/widgets/transaction_list_item.dart';
import 'package:myapp/features/transaction/presentation/bloc/transaction_state.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../transaction/domain/entities/transaction.dart';
import '../../../transaction/domain/entities/transaction_category.dart';
import '../../../transaction/presentation/bloc/transaction_cubit.dart';
import '../../../transaction/presentation/widgets/transaction_details.dart';

class PlanPage extends StatefulWidget {
  const PlanPage({super.key});

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> with SingleTickerProviderStateMixin {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late List<Transaction> transactions;

  late AnimationController _controller;
  late Animation<double> _fadeHeader;
  late Animation<double> _scaleHeader;
  late Animation<double> _fadeCards;
  late Animation<double> _scaleCards;
  late Animation<double> _fadeCalendar;
  late Animation<double> _scaleCalendar;
  late Animation<double> _fadeList;
  late Animation<double> _scaleList;

  @override
  void initState() {
    super.initState();
    transactions = [];

    final authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccess) {
      context.read<TransactionCubit>().setUserId(authState.user.id);
      context.read<TransactionCubit>().getTransactions();
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fadeHeader = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeInOutCubicEmphasized),
      ),
    );
    _scaleHeader = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeInOutCubicEmphasized),
      ),
    );

    _fadeCards = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.65, curve: Curves.easeOutCubic),
      ),
    );
    _scaleCards = Tween<double>(begin: 0.96, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.65, curve: Curves.easeOutCubic),
      ),
    );

    _fadeCalendar = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.3, 0.8, curve: Curves.easeInOutCubicEmphasized),
      ),
    );
    _scaleCalendar = Tween<double>(begin: 0.96, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.3, 0.8, curve: Curves.easeInOutCubicEmphasized),
      ),
    );

    _fadeList = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    _scaleList = Tween<double>(begin: 0.96, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimatedSection({
    required Animation<double> fade,
    required Animation<double> scale,
    required Widget child,
  }) {
    return FadeTransition(
      opacity: fade,
      child: ScaleTransition(
        scale: scale,
        child: child,
      ),
    );
  }

  void showBlurDialog(BuildContext context, Transaction transaction, String selectedCategory) {
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
                child: TransactionDetails(transaction: transaction, transactionCategory: selectedCategory,),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionCubit, TransactionState>(
      listener: (context, state) {
        if (state is TransactionLoaded) {
          setState(() {
            transactions = state.transactions
                .where((element) => element.isPrevision)
                .toList();
          });
        }
      },
      builder: (context, state) {
        if (state is TransactionLoading || state is TransactionInitial) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Loading planned transactions..."),
              ],
            ),
          );
        }

        // Loaded state (with animation)
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAnimatedSection(
                  fade: _fadeHeader,
                  scale: _scaleHeader,
                  child: const Text(
                    'Planned Transactions',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                _buildAnimatedSection(
                  fade: _fadeHeader,
                  scale: _scaleHeader,
                  child: const Text('Manage your upcoming income & expenses'),
                ),
                const SizedBox(height: 24),

                _buildAnimatedSection(
                  fade: _fadeCards,
                  scale: _scaleCards,
                  child: Row(
                    children: [
                      Builder(
                        builder: (context) {
                          double incomingValue =
                          CalculatePeriodTransaction.calculateMonthTotalTransaction(
                            transactions,
                            TransactionCategory.income,
                            _focusedDay.month,
                            _focusedDay.year,
                            isPrevision: true,
                          );
                          var authState = context.read<AuthCubit>().state;
                          String? currency = "MAD";
                          if (authState is AuthSuccess){
                            currency = authState.user.currentCurrency;
                          }
                          return Expanded(
                            child: PlanInfoCard(
                              title: 'Upcoming Income',
                              amount: '$currency ${formatNumber(incomingValue)}',
                              icon: Icons.arrow_upward,
                              backgroundColor: const Color(0xFFE9F7EF),
                              iconColor: const Color(0xFF27AE60),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      Builder(
                        builder: (context) {
                          var authState = context.read<AuthCubit>().state;
                          String? currency = "MAD";
                          if (authState is AuthSuccess){
                            currency = authState.user.currentCurrency;
                          }
                          double outgoingValue =
                          CalculatePeriodTransaction.calculateMonthTotalTransaction(
                            transactions,
                            TransactionCategory.expense,
                            DateTime.now().month,
                            DateTime.now().year,
                            isPrevision: true,
                          );
                          return Expanded(
                            child: PlanInfoCard(
                              title: 'Upcoming Expenses',
                              amount: '$currency ${formatNumber(outgoingValue)}',
                              icon: Icons.arrow_downward,
                              backgroundColor: const Color(0xFFFDEEEE),
                              iconColor: const Color(0xFFE74C3C),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                _buildAnimatedSection(
                  fade: _fadeCalendar,
                  scale: _scaleCalendar,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha(51),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TableCalendar(
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) async {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                        if (selectedDay.isBefore(DateTime.now())) return;
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return TransactionPreviewCategorySelector(previsionDate: _selectedDay!,);
                          },
                        );
                      },
                      onPageChanged: (focusedDay) {
                        setState(() {
                          _focusedDay = focusedDay;
                        });
                      },
                      headerStyle: const HeaderStyle(
                        titleCentered: true,
                        formatButtonVisible: false,
                      ),
                      // --- ADD THE CALENDAR BUILDERS HERE ---
                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, day, events) {
                          // Filter transactions for this specific day
                          final dayTransactions = transactions.where((t) => isSameDay(t.date, day));

                          if (dayTransactions.isEmpty) return const SizedBox.shrink();

                          final hasIncome = dayTransactions.any((t) => t.category == TransactionCategory.income);
                          final hasExpense = dayTransactions.any((t) => t.category == TransactionCategory.expense);

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (hasIncome)
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 1),
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green, // Green dot for income
                                  ),
                                ),
                              if (hasExpense)
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 1),
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red, // Red dot for expense
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                _buildAnimatedSection(
                  fade: _fadeList,
                  scale: _scaleList,
                  child: const Text(
                    'Upcoming Transactions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                _buildAnimatedSection(
                  fade: _fadeList,
                  scale: _scaleList,
                  child: Builder(
                    builder: (context) {
                      // Filter transactions based on the month currently visible in the calendar
                      final filteredTransactions = transactions.where((t) {
                        return t.date.month == _focusedDay.month &&
                            t.date.year == _focusedDay.year;
                      }).toList();

                      if (filteredTransactions.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Text(
                              'No upcoming transactions for this month.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: filteredTransactions.map((transaction) {
                          DateTime dt = transaction.date;
                          return GestureDetector(
                            onTap: (){
                              showBlurDialog(context, transaction, transaction.category.name);
                            },
                            child: TransactionListItem(
                              title: transaction.description,
                              date: "${dt.month}/${dt.day}/${dt.year}",
                              amount: "${transaction.currency} ${formatNumber(transaction.amount)}", //.toStringAsFixed(2),
                              isIncome: transaction.category == TransactionCategory.income,
                              tag: transaction.tag,
                              isPrevision: transaction.isPrevision,
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}