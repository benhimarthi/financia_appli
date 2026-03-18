import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/methods/format_number.dart';
import 'package:myapp/features/saving_goal/domain/entities/saving_goal.dart';
import 'package:myapp/features/saving_goal/presentation/cubit/saving_goal_cubit.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../saving_goal/presentation/widgets/saving_goal_item_details.dart';
import '../../../saving_goal/presentation/widgets/saving_goal_list.dart';

class FinancialGoalsCard extends StatefulWidget {
  const FinancialGoalsCard({super.key});

  @override
  State<FinancialGoalsCard> createState() => _FinancialGoalsCardState();
}

class _FinancialGoalsCardState extends State<FinancialGoalsCard> {
  late List<SavingGoal> savingGoals;

  @override
  void initState() {
    super.initState();
    savingGoals = [];

    final authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccess) {
      context
          .read<SavingGoalCubit>()
          .getSavingGoals(authState.user.id);
    }
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

  void showBlurDialog(BuildContext context, SavingGoal savingGoal) {
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
                child: SavingGoalItemDetails(transaction: savingGoal),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Financial Goals',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  showSavingGoalList(context);
                },
                child: Row(
                  children: [
                    Text(
                      'View All',
                      style:
                      TextStyle(color: Colors.grey[600]),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          BlocConsumer<SavingGoalCubit, SavingGoalState>(
            listener: (context, state) {
              if (state is SavingGoalLoaded) {
                savingGoals = state.savingGoals;
              }
            },
            builder: (context, state) {
              double totalSavingAmount =
              savingGoals.isEmpty
                  ? 0
                  : savingGoals
                  .map((x) => x.currentAmount)
                  .reduce((a, b) => a + b);

              return Column(
                children: savingGoals.map((x) {
                  var currentCurrency = "null";
                  return GestureDetector(
                    onTap: (){
                      showBlurDialog(context, x);
                    },
                    child: _buildGoalItem(
                      color: const Color.fromARGB(
                          255, 44, 189, 141),
                      title: x.name,
                      currency: x.currency == null ? currentCurrency : x.currency!,
                      currentAmount: x.currentAmount,
                      totalAmount: x.targetAmount,
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGoalItem({
    required Color color,
    required String title,
    required String currency,
    required double currentAmount,
    required double totalAmount,
  }) {
    /// 🔒 SAFE percentage calculation (fix crash)
    final double percentage =
    totalAmount <= 0
        ? 0
        : (currentAmount / totalAmount)
        .clamp(0.0, 1.0);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  padding:
                  const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                        102, 49, 191, 144),
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                  child: Image.asset(
                    "assets/icons/Bullseye.png",
                    scale: 5,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                      const TextStyle(
                        fontSize: 16,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$currency ${formatNumber(currentAmount)} of $currency ${formatNumber(totalAmount)}',
                      style:
                      const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  '${(percentage * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),

            /// 🔥 Animated Charging Effect (only change)
            ClipRRect(
              borderRadius:
              BorderRadius.circular(10),
              child:
              TweenAnimationBuilder<double>(
                tween: Tween(
                    begin: 0,
                    end: percentage),
                duration: const Duration(
                    milliseconds: 900),
                curve:
                Curves.easeInOutCubic,
                builder:
                    (context, value, _) {
                  return LinearProgressIndicator(
                    value: value,
                    minHeight: 10,
                    backgroundColor:
                    Colors.grey[300],
                    valueColor:
                    AlwaysStoppedAnimation<
                        Color>(color),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}