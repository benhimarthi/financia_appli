import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:myapp/features/transaction/domain/entities/transaction.dart';

import '../../../transaction/domain/entities/transaction_category.dart';
import 'delete_confirmation_dialog.dart';

class TransactionDetails extends StatefulWidget {
  final Transaction transaction;
  const TransactionDetails({super.key, required this.transaction});

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {

  Future<bool?> showDeleteConfirmationDialog(BuildContext context) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Delete",
      barrierColor: Colors.black.withOpacity(0.2),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const DeleteConfirmationAlertDialog();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved =
        CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);

        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.2),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  Widget blurredContainer() {
    return Stack(
      children: [
        /*// 🔹 Background (example)
        Image.network(
          "https://picsum.photos/600/400",
          fit: BoxFit.cover,
          width: double.infinity,
          height: 300,
        ),*/

        // 🔹 The blurred container
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: 260,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(51), // important
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Blurred Background",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 2),
      backgroundColor: Colors.transparent,
      //contentPadding: EdgeInsets.zero,
      title: Row(
        children: [
          Text(widget.transaction.tag.toUpperCase(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          Spacer(),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded, color: Colors.red,),
          ),
          IconButton(onPressed: ()async{
             bool? result = await showDeleteConfirmationDialog(context);
            if (result == true) {
              // 🔥 Perform deletion
            } else {
              // ❌ Cancelled or timed out
            }
          }, icon: Icon(Icons.delete_outline_rounded, color: Colors.white,))
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(widget.transaction.date.toString().substring(0, 10), style: TextStyle(color: Colors.white),),
              Spacer(),
              Container(
                margin: const EdgeInsets.only(right: 10, left: 10),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: widget.transaction.category == TransactionCategory.income
                      ? Colors.green.withAlpha(38)
                      : Colors.red.withAlpha(38),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(widget.transaction.category.name,
                  style: TextStyle(
                      color: widget.transaction.category == TransactionCategory.income
                          ? Colors.green[700]
                          : Colors.red[700]
                  ),),),
              Text(
                widget.transaction.currency.toString(),
                style: TextStyle(
                  color: widget.transaction.category == TransactionCategory.income
                      ? Colors.green[700]
                      : Colors.red[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              Text(
                widget.transaction.amount.toString(),
                style: TextStyle(
                    color: widget.transaction.category == TransactionCategory.income
                  ? Colors.green[700]
                  : Colors.red[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ],
          ),

          SizedBox(height: 15,),
          Text(widget.transaction.description, style: TextStyle(color: Colors.white),),

        ]
      )
    );
  }
}
