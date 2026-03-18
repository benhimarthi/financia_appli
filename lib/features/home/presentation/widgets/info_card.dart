import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String amount;
  final String percentage;
  final Widget icon;
  final Color color;

  const InfoCard({
    super.key,
    required this.title,
    required this.amount,
    required this.percentage,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      shadowColor: const Color.fromARGB(82, 0, 0, 0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 65,
                  child: Text(
                    title,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 4),
                icon,
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: Text(
                '\$${amount.replaceAll(RegExp(r'[^0-9.]'), '')}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Builder(
              builder: (context) {
                double p = double.parse(percentage.replaceAll(RegExp(r'[^-0-9.]'), ''));

                return Text(percentage, style: TextStyle(color: color, fontSize: 12), overflow: TextOverflow.ellipsis,);
              }
            ),
          ],
        ),
      ),
    );
  }
}
/*
import 'package:flutter/material.dart';

class InfoCard extends StatefulWidget {
  final String title;
  final String amount;      // e.g. "1245.67" or "$1,245.67"
  final String percentage;
  final Widget icon;
  final Color color;

  const InfoCard({
    super.key,
    required this.title,
    required this.amount,
    required this.percentage,
    required this.icon,
    required this.color,
  });

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _amountAnimation;

  double get _targetAmount {
    // Clean string → double
    final clean = widget.amount.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(clean) ?? 0.0;
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400), // 1.4s feels nice & premium
    );

    _amountAnimation = Tween<double>(
      begin: 0.0,
      end: _targetAmount,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubicEmphasized, // smooth modern deceleration
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatAmount(double value) {
    // You can customize formatting here (commas, decimals, currency symbol)
    // Simple version with 2 decimal places
    return value.toStringAsFixed(2);
    // Alternative with thousand separators:
    // return value.toStringAsFixed(2).replaceAllMapped(
    //   RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    //   (Match m) => '${m[1]},',
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      shadowColor: const Color.fromARGB(82, 0, 0, 0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 65,
                  child: Text(
                    widget.title,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 4),
                widget.icon,
              ],
            ),
            const SizedBox(height: 8),

            // Animated amount
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final currentValue = _amountAnimation.value;
                return SizedBox(
                  width: double.infinity,
                  child: Text(
                    '\$${_formatAmount(currentValue)}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      // letterSpacing: 0.5, // optional – looks more premium
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),

            const SizedBox(height: 8),

            Builder(
              builder: (context) {
                final cleanPercent = widget.percentage.replaceAll(RegExp(r'[^-0-9.]'), '');
                final p = double.tryParse(cleanPercent) ?? 0.0;
                final isPositive = p >= 0;

                return Text(
                  widget.percentage,
                  style: TextStyle(
                    color: isPositive ? widget.color : Colors.redAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}*/