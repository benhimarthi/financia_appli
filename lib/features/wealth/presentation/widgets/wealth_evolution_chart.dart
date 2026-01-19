import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WealthEvolutionChart extends StatelessWidget {
  const WealthEvolutionChart({super.key});

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
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                          case 0:
                            text = 'Aug';
                            break;
                          case 1:
                            text = 'Sep';
                            break;
                          case 2:
                            text = 'Oct';
                            break;
                          case 3:
                            text = 'Nov';
                            break;
                          case 4:
                            text = 'Dec';
                            break;
                        }
                        return SideTitleWidget(
                          meta: TitleMeta(
                            min: 2,
                            max: 4,
                            parentAxisSize: 1,
                            axisPosition: 1,
                            appliedInterval: 1,
                            sideTitles: SideTitles(showTitles: true),
                            formattedValue: "formattedValue",
                            axisSide: AxisSide.left,
                            rotationQuarterTurns: 0,
                          ),
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
                    spots: const [
                      FlSpot(0, 3),
                      FlSpot(1, 2.8),
                      FlSpot(2, 3.5),
                      FlSpot(3, 3.8),
                      FlSpot(4, 4),
                    ],
                    isCurved: true,
                    color: const Color(0xFF34495E),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF34495E).withOpacity(0.3),
                          const Color(0xFF34495E).withOpacity(0.0),
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
        ],
      ),
    );
  }
}
