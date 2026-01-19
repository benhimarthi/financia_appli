import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class IncomeExpensesChart extends StatelessWidget {
  const IncomeExpensesChart({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Income vs Expenses',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      _buildLegend(Colors.green, 'Income'),
                      const SizedBox(width: 16),
                      _buildLegend(Colors.red, 'Expenses'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 38),
              Expanded(
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceBetween,
                    maxY: 20,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            const style = TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            );
                            String text;
                            switch (value.toInt()) {
                              case 0:
                                text = 'Jul';
                                break;
                              case 1:
                                text = 'Aug';
                                break;
                              case 2:
                                text = 'Sep';
                                break;
                              case 3:
                                text = 'Oct';
                                break;
                              case 4:
                                text = 'Nov';
                                break;
                              case 5:
                                text = 'Dec';
                                break;
                              default:
                                text = '';
                                break;
                            }
                            return SideTitleWidget(
                              //axisSide: meta.axisSide,
                              space: 4.0,
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
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barGroups: _createSampleData(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      children: <Widget>[
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  List<BarChartGroupData> _createSampleData() {
    return [
      _makeGroupData(0, 12, 8),
      _makeGroupData(1, 13, 8),
      _makeGroupData(2, 11, 9),
      _makeGroupData(3, 14, 8.5),
      _makeGroupData(4, 15, 10),
      _makeGroupData(5, 16, 9),
    ];
  }

  BarChartGroupData _makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: Colors.green,
          width: 7,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
        BarChartRodData(
          toY: y2,
          color: Colors.red,
          width: 7,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
      ],
    );
  }
}
