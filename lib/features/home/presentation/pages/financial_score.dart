import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class FinancialScore extends StatelessWidget {
  final double score;
  const FinancialScore({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.amber,
      padding: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment:
            CrossAxisAlignment.center, // Align items to the bottom
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'December 2024',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text('Monthly Overview', style: TextStyle(color: Colors.black45)),
            ],
          ),
          CircularPercentIndicator(
            radius: 60.0,
            lineWidth: 10.0,
            percent: 0.78,
            arcBackgroundColor: Colors.black12,
            arcType: ArcType.FULL,
            circularStrokeCap: CircularStrokeCap.round,
            center: const Text.rich(
              TextSpan(
                text: '78',
                children: [
                  TextSpan(
                    text: '\n/100',
                    style: TextStyle(fontSize: 12, color: Colors.black45),
                  ),
                ],
              ),
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent,
              ),
            ),
            footer: const Text(
              'Financial Score',
              style: TextStyle(color: Colors.black45),
            ),
            progressColor: Colors.greenAccent,
            backgroundColor: Colors.white24,
          ),
        ],
      ),
    );
  }
}
