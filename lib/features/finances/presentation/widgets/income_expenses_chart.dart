import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/methods/calculate_period_total_transaction.dart';
import 'package:myapp/features/transaction/domain/entities/transaction_category.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../transaction/domain/entities/transaction.dart';
import '../../../transaction/presentation/bloc/transaction_cubit.dart';
import '../../../transaction/presentation/bloc/transaction_state.dart';

class IncomeExpensesChart extends StatefulWidget {
  const IncomeExpensesChart({super.key});

  @override
  State<IncomeExpensesChart> createState() => _IncomeExpensesChartState();
}

class _IncomeExpensesChartState extends State<IncomeExpensesChart> {
  late List<Transaction> myTransactions;

  /// 🎬 You can change animation curve here
  final Curve _chartCurve = Curves.easeOutCubic;

  /// 🎬 You can change animation duration here
  final Duration _chartDuration = const Duration(milliseconds: 700);

  @override
  void initState() {
    super.initState();
    myTransactions = [];

    final authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccess) {
      context.read<TransactionCubit>().setUserId(authState.user.id);
      context.read<TransactionCubit>().getTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// 🔹 Header + Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Income vs Expenses',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLegend(
                          const Color.fromARGB(255, 16, 182, 126), 'Income'),
                      const SizedBox(width: 16),
                      _buildLegend(
                          const Color.fromARGB(255, 241, 122, 122), 'Expenses'),
                      _buildLegend(
                          const Color.fromARGB(255, 180, 122, 241), 'Transfers'),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// 🔹 Chart
              BlocConsumer<TransactionCubit, TransactionState>(
                listener: (context, state) {
                  if (state is TransactionLoaded) {
                    setState(() {
                      myTransactions = state.transactions;
                    });
                  }
                },
                builder: (context, state) {
                  final barGroups = _createBarGroups(myTransactions);

                  return Expanded(
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceBetween,
                        minY: 0,
                        maxY: _safeMaxY(barGroups),
                        //barTouchData: BarTouchData(enabled: false),
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            tooltipRoundedRadius: 8,
                            tooltipPadding: const EdgeInsets.all(8),
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              String label = rodIndex == 0 ? "Income" : "Expenses";

                              return BarTooltipItem(
                                "$label\n\$${rod.toY.toStringAsFixed(2)}",
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget:
                                  (double value, TitleMeta meta) {
                                const style = TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                );

                                final int month = value.toInt();
                                if (month < 1 || month > 12) {
                                  return const SizedBox.shrink();
                                }

                                const months = [
                                  'Jan', 'Feb', 'Mar', 'Apr',
                                  'May', 'Jun', 'Jul', 'Aug',
                                  'Sep', 'Oct', 'Nov', 'Dec'
                                ];

                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  space: 4,
                                  child: Text(months[month - 1], style: style),
                                );
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        barGroups: barGroups,

                      ),

                      /// 🎬 Animation Control
                      swapAnimationDuration: _chartDuration,
                      swapAnimationCurve: _chartCurve,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Legend Widget
  Widget _buildLegend(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration:
          BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  /// 🔹 Safe maxY calculation (prevents NaN crash)
  double _safeMaxY(List<BarChartGroupData> groups) {
    double maxRod = 0;

    for (final group in groups) {
      for (final rod in group.barRods) {
        if (rod.toY.isFinite && rod.toY > maxRod) {
          maxRod = rod.toY;
        }
      }
    }

    if (maxRod <= 0) return 10.0;

    return maxRod * 1.2; // 20% headroom
  }

  /// 🔹 Create bar groups safely (NO normalization)
  List<BarChartGroupData> _createBarGroups(
      List<Transaction> transactions) {
    final now = DateTime.now();
    final year = now.year;

    final incomes = transactions
        .where((t) => t.category == TransactionCategory.income)
        .toList();

    final expenses = transactions
        .where((t) => t.category == TransactionCategory.expense)
        .toList();

    final transfers = transactions
        .where((t) => t.category == TransactionCategory.transfert)
        .toList();

    return List.generate(12, (i) {
      final month = i + 1;

      double income =
      CalculatePeriodTransaction.calculateMonthTotalTransaction(
        incomes,
        TransactionCategory.income,
        month,
        year,
      );

      double expense =
      CalculatePeriodTransaction.calculateMonthTotalTransaction(
        expenses,
        TransactionCategory.expense,
        month,
        year,
      );

      double transfer =
      CalculatePeriodTransaction.calculateMonthTotalTransaction(
        transfers,
        TransactionCategory.transfert,
        month,
        year,
      );

      /// 🔒 Protect against NaN / Infinity
      if (!income.isFinite) income = 0;
      if (!expense.isFinite) expense = 0;
      if (!transfer.isFinite) transfer = 0;

      return BarChartGroupData(
        x: month,
        barRods: [
          BarChartRodData(
            toY: income,
            color: const Color.fromARGB(255, 16, 182, 126),
            width: 5,
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(3)),
          ),
          BarChartRodData(
            toY: expense,
            color: const Color.fromARGB(255, 241, 122, 122),
            width: 5,
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(3)),
          ),
          BarChartRodData(
            toY: transfer,
            color: const Color.fromARGB(255, 180, 122, 241),
            width: 5,
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(3)),
          ),
        ],
      );
    });
  }
}