import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/methods/calculate_period_total_transaction.dart';
import 'package:myapp/features/saving_goal/domain/entities/saving_goal.dart';
import 'package:myapp/features/saving_goal/presentation/cubit/saving_goal_cubit.dart';
import 'package:myapp/features/transaction/data/models/transaction_model.dart';
import 'package:myapp/features/transaction/domain/entities/transaction.dart';
import 'package:myapp/features/transaction/presentation/bloc/transaction_state.dart';
import 'package:myapp/features/transaction/presentation/widgets/transfer_benef.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../core/methods/format_number.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../domain/entities/transaction_category.dart';
import '../../../home/presentation/widgets/delete_confirmation_dialog.dart';
import '../bloc/transaction_cubit.dart';
import 'edit_transaction_dialog.dart';

class TransactionDetails extends StatefulWidget {
  final Transaction transaction;
  final String transactionCategory;
  const TransactionDetails({super.key, required this.transaction, required this.transactionCategory});

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> with SingleTickerProviderStateMixin{
  late List<Transaction> myTransactions;
  late List<Transaction> transferTransactions;
  late List<SavingGoal> savingGoals;
  late AnimationController _controller;
  late Animation<double> _percentAnimation;
  late Animation<double> _scoreAnimation;
  late double score;

  final Map<String, Color> colorByTransaction= {
    "income": Colors.green.withAlpha(66),
    "debt": Colors.orange.withAlpha(66),
    "transfert": Colors.deepPurple.withAlpha(66),
    "expense": Colors.red.withAlpha(66),
  };

  final Map<String, Icon> transactionCategoryIcons = {
    "income": Icon(Icons.arrow_upward_rounded, color: Colors.green[700], size: 20),
    "debt": Icon(Icons.credit_card, color: Colors.orange[700], size: 20),
    "transfert": Icon(Icons.swap_horiz_rounded, color: Colors.deepPurple[700], size: 20,),
    "expense": Icon(Icons.arrow_downward_rounded, color: Colors.red[700], size: 20,)
  };

  Future<bool?> showDeleteConfirmationDialog(BuildContext context) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Delete",
      barrierColor: Colors.black.withAlpha(55),
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

  Widget showInformationBox(String title, String unity, dynamic value, Color color){
    return Container(
      width: 105,
      height: 90,
      margin: const EdgeInsets.only(right: 5, left: 5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(offset: Offset(1, 5), blurRadius: 10, color: Colors.black.withAlpha(38))
          ]
      ),
      child: Column(
          children: [
            Text(title, style: TextStyle(color: Colors.white, fontSize: 10),),
            const SizedBox(height: 10),
            Text("$value $unity", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),)
          ]
      ),
    );
  }

  Future<bool?> showEditTransactionDialog(BuildContext context, Transaction transaction) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Edit Transaction",
      barrierColor: Colors.black.withAlpha(43),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return EditTransactionDialog(transaction: transaction,);
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
                child: TransactionDetails(transaction: transaction, transactionCategory: TransactionCategory.transfert.name),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    score = 0;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800), // feels premium — not too fast
    );
    // Animate from 0 → actual percent (score / 100)
    _percentAnimation = Tween<double>(
      begin: 0.0,
      end: score / 100.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubicEmphasized, // very smooth & modern
      ),
    );
    // Optional: animate the displayed number too (0 → score)
    _scoreAnimation = Tween<double>(
      begin: 0.0,
      end: score,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut), // slightly delayed
      ),
    );
    myTransactions = [];
    transferTransactions = [];
    savingGoals = [];
    _controller.forward();
    var authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccess) {
      context.read<TransactionCubit>().setUserId(authState.user.id);
      context.read<TransactionCubit>().getTransactions();
      context.read<SavingGoalCubit>().getSavingGoals(authState.user.id);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TransactionDetails oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if(myTransactions.isNotEmpty){
      _controller.reset();
      _controller.forward();
    }else{
      _controller.reset();
      _controller.forward();
    }
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

          IconButton(onPressed: ()async{

             bool? result = await showEditTransactionDialog(context, widget.transaction);
             if (result == true) {
               // 🔥 Perform deletion
             } else {
               // ❌ Cancelled or timed out
             }
          }, icon: Icon(Icons.mode_edit_outlined, color: Colors.white,))
          ,
            IconButton(
                onPressed: ()async{
                  bool? result = await showDeleteConfirmationDialog(context);
                  if (result == true) {
                    // 🔥 Perform deletion
                  } else {
                    // ❌ Cancelled or timed out
                  }
                },
              icon: Icon(Icons.delete_outline_rounded, color: Colors.white,)),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded, color: Colors.red,),
          ),
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
                  color: colorByTransaction[widget.transaction.category.name],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(widget.transaction.category.name.toUpperCase(),
                  style: TextStyle(
                      color: Colors.white
                  ),),),
              Text(
                "${widget.transaction.currency.toString()} ",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              Text(
                formatNumber(widget.transaction.amount).toString(),
                style: TextStyle(
                    color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ],
          ),
          SizedBox(height: 15,),
          BlocConsumer<TransactionCubit, TransactionState>(
            listener: (context, state) {
              if(state is TransactionLoaded){
                setState(() {
                  myTransactions = state.transactions;
                  transferTransactions = state.transactions.where((x)=>x.category == TransactionCategory.transfert).
                  toList().where((x){
                    bool val = x.transferDetails!.values.last == widget.transaction.id;
                    return val;
                  }).toList();
                  var remaining = CalculatePeriodTransaction.calculateRemainingAmountFromDept(widget.transaction, myTransactions);
                  var totAmount = CalculatePeriodTransaction.calculateTotalDebtAmount(widget.transaction);
                  score = 1 - (remaining / totAmount);
                });
              }
            },
            builder: (context, state) {
              return SizedBox();
            }
          ),
          Visibility(
            visible: widget.transaction.category.name == "debt",
            child: Row(
              children: [
                Builder(
                    builder: (context) {
                      var currency = '€';
                      var totAmount = CalculatePeriodTransaction.calculateTotalDebtAmount(widget.transaction);
                      if(widget.transaction.currency!=null){
                        currency = widget.transaction.currency!;
                      }
                      return showInformationBox(
                          "Tot amount",
                          currency,
                          formatNumber(totAmount),
                          colorByTransaction[widget.transaction.category.name]!
                      );
                    }
                ),
                Builder(
                    builder: (context) {
                      var currency = '€';
                      var remaining = CalculatePeriodTransaction.calculateRemainingAmountFromDept(widget.transaction, myTransactions);
                      if(widget.transaction.currency!=null){
                        currency = widget.transaction.currency!;
                      }
                      return showInformationBox(
                          "amount left",
                          currency,
                          formatNumber(remaining),
                          colorByTransaction[widget.transaction.category.name]!
                      );
                    }
                ),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final currentPercent = _percentAnimation.value;
                    final displayedScore = _scoreAnimation.value.toStringAsFixed(2);

                    return CircularPercentIndicator(
                      radius: 40.0,
                      lineWidth: 5.0,
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
                                fontSize: 10,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
                        ),
                      ),

                      progressColor: Colors.greenAccent,
                      backgroundColor: Colors.white24,
                      animation: true,           // still useful for internal tween if needed
                      animateFromLastPercent: true,
                    );
                  },
                ),
              ],
            )
          ),
          SizedBox(height: 15,),
          Text("Dept description".toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),),
          Divider(),
          Text(widget.transaction.description, style: TextStyle(color: Colors.white),),
          SizedBox(height: 15,),
          if(widget.transactionCategory == TransactionCategory.debt.name)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocConsumer<SavingGoalCubit, SavingGoalState>(
                  listener: (context, state){
                    if(state is SavingGoalLoaded){
                      setState(() {
                        savingGoals = state.savingGoals;
                      });
                    }
                  },
                  builder: (context, state){
                    return SizedBox();
                  }),
              Text("Transfer to Dept".toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),),
              Divider(),
              Column(
                children: transferTransactions.map((x)=>GestureDetector(
                  onTap: (){
                    showBlurDialog(context, x);
                  },
                  child: ListTile(
                      title: Row(
                        children: [
                          Text(x.date.toString().substring(0, 10), style: TextStyle(color: Colors.white),),
                          Spacer(),
                          Text(x.currency == null ? "€ " : x.currency!, style: TextStyle(color: Colors.white),),
                          Text(formatNumber(x.amount), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        ],
                      ),
                      subtitle: Text(x.description),
                      trailing: IconButton(
                          onPressed: ()async{
                            showBlurDialog(context, x);
                          },
                          icon: Icon(Icons.edit_outlined, color: Colors.white,)
                      )
                  ),
                )).toList(),
              )
            ],
          ),
          if(widget.transaction.isPrevision)
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white,
                width: 1,
              )
            ),
            child: Column(
              children: [
                Text(
                    "Validate prevision".toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold
                    )
                ),
                Divider(),
                Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        var transactionMod = TransactionModel.fromTransaction(widget.transaction);
                        var updatedTransaction = transactionMod.copyWith(isPrevision: false);
                        context.read<TransactionCubit>().updateTransaction(updatedTransaction).whenComplete((){
                          Navigator.of(context).pop();
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(5),
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.green.withAlpha(77),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Validate Prevision", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            Text(
                              "This action will make this transaction as a real transaction.",
                              style: TextStyle(color: Colors.white, fontSize: 10),
                              textAlign: TextAlign.center,
                            )
                          ]
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        showDeleteConfirmationDialog(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(5),
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.red.withAlpha(77),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Dismiss Prevision", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              Text(
                                "This action will remove this provisional transaction.",
                                style: TextStyle(color: Colors.white, fontSize: 10),
                                textAlign: TextAlign.center,
                              )
                            ]
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ]
      )
    );
  }
}
