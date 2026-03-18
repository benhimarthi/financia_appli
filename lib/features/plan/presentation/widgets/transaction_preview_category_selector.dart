import 'package:flutter/material.dart';
import '../../../transaction/domain/entities/transaction_category.dart';
import '../../../transaction/presentation/widgets/expense_transaction_form.dart';
import '../../../transaction/presentation/widgets/income_transaction_form.dart';

class TransactionPreviewCategorySelector extends StatefulWidget {
  final DateTime previsionDate;
  const TransactionPreviewCategorySelector({super.key, required this.previsionDate});

  @override
  State<TransactionPreviewCategorySelector> createState() => _TransactionPreviewCategorySelectorState();
}

class _TransactionPreviewCategorySelectorState extends State<TransactionPreviewCategorySelector> {
  void _showTransactionForm(TransactionCategory category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => category == TransactionCategory.income
          ? IncomeTransactionForm(isPrevision: true, previsionDate: widget.previsionDate,)
          : ExpenseTransactionForm(isPrevision: true, previsionDate: widget.previsionDate,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Category', textAlign: TextAlign.center,),

      content: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
              _showTransactionForm(TransactionCategory.income);
            },
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.trending_up, color: Colors.white),
                  ),
                  Text('Income', style: Theme.of(context).textTheme.bodyMedium)
                ]
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
              _showTransactionForm(TransactionCategory.expense);
            },
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.red,
                    child: const Icon(Icons.trending_down, color: Colors.white),
                  ),
                  Text('Expense', style: Theme.of(context).textTheme.bodyMedium)
                ]
            ),
          )
        ]
      )
    );
  }
}
