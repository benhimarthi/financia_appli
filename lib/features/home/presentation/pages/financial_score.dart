
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../core/methods/calculate_period_total_transaction.dart';
import '../../../transaction/domain/entities/transaction.dart';
import '../widgets/cash_available_card.dart';

class FinancialScore extends StatefulWidget {
  final double score; // e.g. 78.0 (out of 100)
  final List<Transaction> transactions;

  const FinancialScore({
    super.key,
    required this.score,
    required this.transactions,
  });

  @override
  State<FinancialScore> createState() => _FinancialScoreState();
}

class _FinancialScoreState extends State<FinancialScore>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _percentAnimation;
  late Animation<double> _scoreAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800), // feels premium — not too fast
    );

    // Animate from 0 → actual percent (score / 100)
    _percentAnimation = Tween<double>(
      begin: 0.0,
      end: widget.score / 100.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubicEmphasized, // very smooth & modern
      ),
    );

    // Optional: animate the displayed number too (0 → score)
    _scoreAnimation = Tween<double>(
      begin: 0.0,
      end: widget.score,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut), // slightly delayed
      ),
    );

    _controller.forward(); // start animation when widget is built
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*const Text(
                'December 2024',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                'Monthly Overview',
                style: TextStyle(color: Colors.black45),
              ),*/
              CashAvailableCard(
                amount: CalculatePeriodTransaction.calculateTotalAvailableCash(
                  widget.transactions,
                  DateTime.now().month,
                  DateTime.now().year,
                ),
              )
            ],
          ),

          // Animated circular indicator
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final currentPercent = _percentAnimation.value;
              final displayedScore = _scoreAnimation.value.round(); // or .toStringAsFixed(0)

              return CircularPercentIndicator(
                radius: 60.0,
                lineWidth: 10.0,
                percent: currentPercent.clamp(0.0, 1.0),
                arcBackgroundColor: Colors.black12,
                arcType: ArcType.FULL,
                circularStrokeCap: CircularStrokeCap.round,
                center: Text.rich(
                  TextSpan(
                    text: '$displayedScore',
                    children: const [
                      TextSpan(
                        text: '\n/100',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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
                animation: true,           // still useful for internal tween if needed
                animateFromLastPercent: true,
              );
            },
          ),
        ],
      ),
    );
  }
}