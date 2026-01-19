import 'package:flutter/material.dart';

class InfoCard extends StatefulWidget {
  const InfoCard({
    super.key,
    required this.title,
    required this.amount,
    required this.percentage,
    required this.icon,
    required this.color,
  });

  final String title;
  final String amount;
  final String percentage;
  final Widget icon;
  final Color color;

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    final double amountValue = double.tryParse(widget.amount.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
    _animation = Tween<double>(begin: 0, end: amountValue).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 4),
                widget.icon,
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '\$${_animation.value.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.percentage, style: TextStyle(color: widget.color)),
          ],
        ),
      ),
    );
  }
}
