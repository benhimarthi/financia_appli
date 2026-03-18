import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/methods/calculate_period_total_transaction.dart';
import 'package:myapp/features/transaction/domain/entities/transaction.dart';
import 'package:myapp/features/transaction/domain/entities/transaction_category.dart';

import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../transaction/presentation/bloc/transaction_cubit.dart';
import '../../../transaction/presentation/bloc/transaction_state.dart';

class WealthEvolutionChart extends StatefulWidget {
  const WealthEvolutionChart({super.key});

  @override
  State<WealthEvolutionChart> createState() => _WealthEvolutionChartState();
}

class _WealthEvolutionChartState extends State<WealthEvolutionChart> {
  late List<Transaction> transactions;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    transactions = [];
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccess) {
      context.read<TransactionCubit>().setUserId(authState.user.id);
      context.read<TransactionCubit>().getTransactions();
    }

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(25),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocConsumer<TransactionCubit, TransactionState>(listener: (context, state){
            if(state is TransactionLoaded){
              transactions = state.transactions;
            }
          },
          builder: (context, state){
            return SizedBox();
          }),
          const Text(
            'Wealth Evolution',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        );
                        String text = '';
                        switch (value.toInt()) {
                          case 1:
                            text = 'Jan';
                            break;
                          case 2:
                            text = 'Feb';
                            break;
                          case 3:
                            text = 'Mar';
                            break;
                          case 4:
                            text = 'Apr';
                            break;
                          case 5:
                            text = 'May';
                            break;
                          case 6:
                            text = 'Jun';
                            break;
                          case 7:
                            text = 'Jul';
                            break;
                          case 8:
                            text = 'Aug';
                            break;
                          case 9:
                            text = 'Sep';
                            break;
                          case 10:
                            text = 'Oct';
                            break;
                          case 11:
                            text = 'Nov';
                            break;
                          case 12:
                            text = 'Dec';
                            break;
                        }
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(text, style: style),
                        );
                      },
                      reservedSize: 30,
                      interval: 1,
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: transactions.map((x) {
                      double currentValue = CalculatePeriodTransaction.calculateMonthTotalTransaction(
                        transactions,
                        TransactionCategory.income,
                        x.date.month,
                        x.date.year,
                      );
                      return FlSpot(
                        x.date.month.toDouble(),
                        double.parse(currentValue.toStringAsFixed(2)),
                      );
                    }).toSet().toList()..sort((a, b) => a.x.compareTo(b.x)),
                    isCurved: false,
                    color: const Color(0xFF34495E),
                    barWidth: 1,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF34495E).withAlpha(77),
                          const Color(0xFF34495E).withAlpha(0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  LineChartBarData(
                    spots: transactions.map((x) {
                      double currentValue = CalculatePeriodTransaction.calculateMonthTotalTransaction(
                        transactions,
                        TransactionCategory.expense,
                        x.date.month,
                        x.date.year,
                      );
                      return FlSpot(
                        x.date.month.toDouble(),
                        double.parse(currentValue.toStringAsFixed(2)),
                      );
                    }).toSet().toList()..sort((a, b) => a.x.compareTo(b.x)),
                    isCurved: true,
                    color: const Color(0xFFFF0000),
                    barWidth: 1,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFF0000).withAlpha(77),
                          const Color(0x64FF0000).withAlpha(0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  LineChartBarData(
                    spots: transactions.map((x) {
                      double currentValue = CalculatePeriodTransaction.calculateMonthTotalTransaction(
                        transactions,
                        TransactionCategory.transfert,
                        x.date.month,
                        x.date.year,
                      );
                      return FlSpot(
                        x.date.month.toDouble(),
                        double.parse(currentValue.toStringAsFixed(2)),
                      );
                    }).toSet().toList()..sort((a, b) => a.x.compareTo(b.x)),
                    isCurved: true,
                    color: const Color(0xFF42345E),
                    barWidth: 1,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFB47AF1).withAlpha(77),
                          const Color(0x90B47AF1).withAlpha(0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(width: 12, height: 12, color: const Color(0xFF34495E)),
              const SizedBox(width: 4),
              const Text('Incomes'),
              const SizedBox(width: 16),
              Container(width: 12, height: 12, color: const Color(0xFFFF0000)),
              const SizedBox(width: 4),
              const Text('Expenses'),
              Container(width: 12, height: 12, color: const Color(0xFFB47AF1)),
              const SizedBox(width: 4),
              const Text('Transfers'),
            ],
          ),
        ],
      ),
    );
  }
}
