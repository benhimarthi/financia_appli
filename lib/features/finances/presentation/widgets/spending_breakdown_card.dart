import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/transaction/domain/entities/expense_tags.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../transaction/domain/entities/transaction.dart';
import '../../../transaction/domain/entities/transaction_category.dart';
import '../../../transaction/presentation/bloc/transaction_cubit.dart';
import '../../../transaction/presentation/bloc/transaction_state.dart';
import '../../../transaction/presentation/widgets/transactions_list.dart';

class SpendingBreakdownCard extends StatefulWidget {
  const SpendingBreakdownCard({super.key});

  @override
  State<SpendingBreakdownCard> createState() =>
      _SpendingBreakdownCardState();
}

class _SpendingBreakdownCardState
    extends State<SpendingBreakdownCard>
    with SingleTickerProviderStateMixin {
  late List<Transaction> myTransactions;

  /// 🎯 Animation controls (like we did for fl_chart)
  final Duration _animationDuration =
  const Duration(milliseconds: 900);
  final Curve _animationCurve = Curves.easeInOutCubic;

  final List<Color> colors = [
    const Color(0xff1f456e),
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.grey,
    Colors.blueGrey,
  ];

  @override
  void initState() {
    super.initState();
    myTransactions = [];

    final authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccess) {
      context
          .read<TransactionCubit>()
          .setUserId(authState.user.id);
      context.read<TransactionCubit>().getTransactions();
    }
  }

  void showBlurDialog(BuildContext context, ExpenseTags tag) {
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
                    category: TransactionCategory.expense,
                  tag: tag,
                  displayCategoryBar: false,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Spending Breakdown',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Icon(Icons.trending_down, color: Colors.red[600],)
              ],
            ),

            /// 🔥 Bloc
            BlocConsumer<TransactionCubit, TransactionState>(
              listener: (context, state) {
                if (state is TransactionLoaded) {
                  myTransactions = state.transactions.where((x)=>x.date.month == DateTime.now().month && x.date.year == DateTime.now().year && !x.isPrevision).toList();
                }
              },
              builder: (context, state) {
                final expenditure = myTransactions
                    .where((x) =>
                x.category ==
                    TransactionCategory.expense)
                    .toList();

                final double total = expenditure.isEmpty
                    ? 0
                    : expenditure
                    .map((x) => x.amount)
                    .reduce((a, b) => a + b);

                final tags = expenditure
                    .map((x) => x.tag)
                    .toSet()
                    .toList();

                if (total == 0) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("No expenses yet."),
                  );
                }

                return Column(
                  children: List.generate(
                    tags.length,
                        (index) {
                      final tag = tags[index];

                      final currentAmount = expenditure
                          .where((x) => x.tag == tag)
                          .map((x) => x.amount)
                          .reduce((a, b) => a + b);

                      return GestureDetector(
                        onTap: (){
                          print(ExpenseTags.fromString(tag));
                          showBlurDialog(context, ExpenseTags.fromString(tag));
                        },
                        child: _buildSpendingItem(
                          context,
                          color: colors[index %
                              colors.length],
                          category: tag,
                          amount: currentAmount,
                          totalAmount: total,
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSpendingItem(
      BuildContext context, {
        required Color color,
        required String category,
        required double amount,
        required double totalAmount,
      }) {
    final double percentage =
    totalAmount == 0 ? 0 : amount / totalAmount;

    return Padding(
      padding:
      const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Text(category,
                  style:
                  const TextStyle(fontSize: 16)),
              Text(
                '\$${amount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          /// 🚀 Animated Progress Bar
          TweenAnimationBuilder<double>(
            tween:
            Tween(begin: 0, end: percentage),
            duration: _animationDuration,
            curve: _animationCurve,
            builder: (context, value, child) {
              return ClipRRect(
                borderRadius:
                BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: value,
                  minHeight: 10,
                  backgroundColor:
                  Colors.grey[300],
                  valueColor:
                  AlwaysStoppedAnimation<
                      Color>(color),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}