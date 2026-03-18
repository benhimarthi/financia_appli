import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:myapp/features/home/presentation/widgets/transaction_details.dart';
import 'package:myapp/features/transaction/domain/entities/transaction_category.dart';
import '../../../transaction/domain/entities/transaction.dart';

class TransactionsList extends StatefulWidget {
  final List<Transaction> transactions;
  final TransactionCategory category;
  final bool isLoading; // ← new: control when to show loading

  const TransactionsList({
    super.key,
    required this.transactions,
    required this.category,
    this.isLoading = false,
  });

  @override
  State<TransactionsList> createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late List<Transaction> myTransactions;

  @override
  void initState() {
    super.initState();
    myTransactions = widget.transactions.where((transaction) => transaction.category == widget.category).toList();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    // Start animation only when we have data
    if (widget.transactions.isNotEmpty) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant TransactionsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-trigger animation when new transactions arrive
    if (widget.transactions.isNotEmpty && oldWidget.transactions.isEmpty) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void showBlurDialog(BuildContext context, Transaction transaction) {
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
                child: TransactionDetails(transaction: transaction)
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 5),
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      titlePadding: const EdgeInsets.fromLTRB(24, 20, 12, 8),
      title: Row(
        children: [
          Text(
            '${widget.category.name} Transactions'.toUpperCase(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
      content: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
          maxWidth: MediaQuery.of(context).size.width * 0.92,
        ),
        decoration: BoxDecoration(
          //color: Theme.of(context).dialogBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(38),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: widget.isLoading || widget.transactions.isEmpty
            ? Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 40),
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              Text(
                widget.isLoading
                    ? 'Loading transactions...'
                    : 'No transactions found',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        )
            : FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: myTransactions.asMap().entries.map((entry) {
                final index = entry.key;
                final transaction = entry.value;

                // Staggered delay per item
                final delay = index * 80;
                final itemAnimation = Tween<double>(begin: 0.0, end: 1.0)
                    .animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: Interval(
                      (delay / 1000).clamp(0.0, 1.0),
                      ((delay + 600) / 1000).clamp(0.0, 1.0),
                      curve: Curves.easeOut,
                    ),
                  ),
                );

                return FadeTransition(
                  opacity: itemAnimation,
                  child: ListTile(
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    leading: CircleAvatar(
                      backgroundColor: widget.category == TransactionCategory.income
                          ? Colors.green.withAlpha(38)
                          : Colors.red.withAlpha(38),
                      child: Icon(
                        widget.category == TransactionCategory.income
                            ? Icons.arrow_upward_rounded
                            : Icons.arrow_downward_rounded,
                        color: widget.category == TransactionCategory.income
                            ? Colors.green[700]
                            : Colors.red[700],
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            transaction.tag.isNotEmpty
                                ? transaction.tag.toUpperCase()
                                : 'Untitled',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Spacer(),
                        Text(
                          '${widget.category == TransactionCategory.income ? '+' : ''}${transaction.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: widget.category == TransactionCategory.income
                                ? Colors.green[800]
                                : Colors.red[800],
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      transaction.date.toString().substring(0, 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white60,
                      ),
                    ),
                    trailing: const Icon(Icons.edit_outlined, size: 20),
                    onTap: () {
                      // Optional: edit action
                      showBlurDialog(context, transaction);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}