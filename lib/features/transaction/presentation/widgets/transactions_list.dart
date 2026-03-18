import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/methods/calculate_period_total_transaction.dart';
import 'package:myapp/core/methods/format_number.dart';
import 'package:myapp/features/transaction/domain/entities/expense_tags.dart';
import 'package:myapp/features/transaction/presentation/bloc/transaction_cubit.dart';
import 'package:myapp/features/transaction/presentation/bloc/transaction_state.dart';
import 'package:myapp/features/transaction/presentation/widgets/transaction_details.dart';
import 'package:myapp/features/transaction/domain/entities/transaction_category.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../domain/entities/transaction.dart';
import 'edit_transaction_dialog.dart';

class TransactionsList extends StatefulWidget {
  final TransactionCategory category;
  final ExpenseTags? tag;
  final bool displayCategoryBar;
  final bool isLoading; // ← new: control when to show loading

  const TransactionsList({
    super.key,
    required this.category,
    this.tag,
    this.isLoading = false,
    this.displayCategoryBar = true,
  });

  @override
  State<TransactionsList> createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late List<Transaction> myTransactions;
  late List<Transaction> myInfTransactions;
  late int currentMouth;
  late int year;
  late String selectedCategory;
  late String selectedTag;
  final Map<String, Color> colorByTransaction= {
    "income": Colors.green.withAlpha(77),
    "debt": Colors.orange.withAlpha(77),
    "transfert": Colors.deepPurple.withAlpha(77),
    "expense": Colors.red.withAlpha(77),
  };
  final Map<String, Icon> transactionCategoryIcons = {
    "income": Icon(Icons.arrow_upward_rounded, color: Colors.green[700], size: 20),
    "debt": Icon(Icons.credit_card, color: Colors.orange[700], size: 20),
    "transfert": Icon(Icons.swap_horiz_rounded, color: Colors.deepPurple[700], size: 20,),
    "expense": Icon(Icons.arrow_downward_rounded, color: Colors.red[700], size: 20,)
  };
  final Map<int, String> mouths = {
    1:"January",
    2:"February",
    3:"March",
    4:"April",
    5:"May",
    6:"June",
    7:"July",
    8:"August",
    9:"September",
    10:"October",
    11:"November",
    12:"December",
  };

  @override
  void initState() {
    super.initState();
    myTransactions=[];
    myInfTransactions=[];
    selectedCategory = widget.category.name;
    selectedTag = "";
    currentMouth = DateTime.now().month;
    year = DateTime.now().year;
    var authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccess) {
      context.read<TransactionCubit>().setUserId(authState.user.id);
      context.read<TransactionCubit>().getTransactions();
    }
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
  }

  @override
  void didUpdateWidget(covariant TransactionsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-trigger animation when new transactions arrive
    if (myTransactions.isNotEmpty) {
      _controller.reset();
      _controller.forward();
    }else{
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool?> showEditTransactionDialog(
      BuildContext context,
      Transaction transaction,
      ) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Edit Transaction",
      barrierColor: Colors.black.withAlpha(30),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Stack(
          children: [
            // Glass effect
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                color: Colors.black.withAlpha(26),
              ),
            ),

            // Dialog
            Center(
              child: EditTransactionDialog(
                transaction: transaction,
              ),
            ),
          ],
        );
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
                child: TransactionDetails(transaction: transaction, transactionCategory: selectedCategory,),
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
      title: Column(
        children: [
          Row(
            children: [
              BlocConsumer<TransactionCubit, TransactionState>(
                  listener: (context, state){
                    if(state is TransactionLoaded){
                      setState(() {
                        myInfTransactions = state.transactions;
                        myTransactions = state.transactions.where(
                                (x)=> x.category.name == selectedCategory && !x.isPrevision
                        ).toList();
                        if(widget.tag!=null){
                          myTransactions = myTransactions.where((x)=>x.tag == widget.tag!.name).toList();
                        }
                      });
                    }
                  },
                  builder: (context, state) {
                    return SizedBox();
                  }
              ),
              Text(
                '$selectedCategory Transactions'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded, color: Colors.red,),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          Visibility(
            visible: widget.displayCategoryBar,
            child: Container(
              //color: Colors.green,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              width: double.infinity,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          int prevMouth = currentMouth - 1;
                          int cYear = year;
                          if(prevMouth == 0){
                            currentMouth = 12;
                            year--;
                            if(myInfTransactions.where((x) => x.date.year == year && x.date.month == currentMouth).toList().isNotEmpty){
                              myTransactions = myInfTransactions.where((x) => x.date.year == year && x.date.month == currentMouth && x.category.name == selectedCategory).toList();
                            }
                          }else{
                            currentMouth = prevMouth;
                            if(myInfTransactions.where((x) => x.date.year == year && x.date.month == currentMouth).toList().isNotEmpty){
                              myTransactions = myInfTransactions.where((x) => x.date.year == year && x.date.month == currentMouth && x.category.name == selectedCategory).toList();
                            }
                          }
                        });
                        setState(() {});
                      },
                      child: CircleAvatar(
                          backgroundColor: colorByTransaction[selectedCategory], //widget.category == TransactionCategory.income ?
                          //Colors.green.withAlpha(77):Colors.red.withAlpha(77),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 12,
                          )
                      ),
                    ),
                    Container(
                      width: 150,
                      height: 40,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: colorByTransaction[selectedCategory],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                          child: Text(
                              "${mouths[currentMouth]}, ${year.toString()}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)
                          )
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          int nextMouth = currentMouth + 1;
                          int cYear = year;
                          if(nextMouth == 13){
                            currentMouth = 1;
                            year++;
                            if(myInfTransactions.where((x) => x.date.year == year && x.date.month == currentMouth).toList().isNotEmpty){
                              myTransactions = myInfTransactions.where((x) => x.date.year == year && x.date.month == currentMouth && x.category.name == selectedCategory).toList();
                            }
                          }else{
                            currentMouth = nextMouth;
                            if(myInfTransactions.where((x) => x.date.year == year && x.date.month == currentMouth).toList().isNotEmpty){
                              myTransactions = myInfTransactions.where((x) => x.date.year == year && x.date.month == currentMouth && x.category.name == selectedCategory).toList();
                            }
                          }
                        });
                        setState(() {});
                      },
                      child: CircleAvatar(
                        backgroundColor: colorByTransaction[selectedCategory],
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    )
                  ]
              ),
            ),
          ),
          const SizedBox(height: 16),
          Visibility(
            visible: widget.displayCategoryBar,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.92,
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(
                    TransactionCategory.values.length,
                        (x) =>
                            Container(
                              width: 100,
                              height: 30,
                              padding: EdgeInsets.all(1),
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: colorByTransaction[TransactionCategory.values[x].name],//selectedCategory ==  TransactionCategory.values[x].name ? Colors.yellow.shade700 : Colors.yellow.withAlpha(77),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: selectedCategory ==  TransactionCategory.values[x].name ? Colors.white : Colors.transparent,
                                  width: 3
                                )
                              ),
                              child: TextButton(
                                onPressed: (){
                                  setState(() {
                                    selectedCategory = TransactionCategory.values[x].name;
                                    myTransactions = myInfTransactions.where((x)=>x.category.name == selectedCategory).toList();
                                  });
                                },
                                child: Center(child: Text(TransactionCategory.values[x].name, style: TextStyle(color: selectedCategory ==  TransactionCategory.values[x].name ? Colors.white: Colors.white.withAlpha(55)),)),
                              )
                            ))
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Builder(
                  builder: (context) {
                    double totAmount = CalculatePeriodTransaction.calculateMonthTotalTransaction(myTransactions, TransactionCategory.fromString(selectedCategory), currentMouth, year);
                    //print(myTransactions);
                    var authState = context.read<AuthCubit>().state;
                    var currency = '€';
                    if (authState is AuthSuccess) {
                      currency = authState.user.currentCurrency!;
                    }
                    return showInformationBox("Total amount", currency, formatNumber(totAmount),
                        colorByTransaction[selectedCategory]!);
                  }
              ),
              Builder(
                  builder: (context) {
                    int totNb = myTransactions.where((x)=> x.date.month == currentMouth).toList().length;
                    return showInformationBox("Trans nb", "", totNb.toString(),
                        colorByTransaction[selectedCategory]!);
                  }
              ),
              Builder(
                  builder: (context) {
                    double value = CalculatePeriodTransaction.calculateMonthEvolution(
                        myInfTransactions.where((transaction) => transaction.category.name == selectedCategory).toList(),
                        TransactionCategory.fromString(selectedCategory), currentMouth, year);
                    return showInformationBox("Progression","%", (value * 100).toStringAsFixed(2),
                        colorByTransaction[selectedCategory]!);
                  }
              )
            ],
          ),
        ]
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
        child: widget.isLoading || myTransactions.isEmpty
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Divider(),
                const SizedBox(height: 16),
                SizedBox(
                  //color: Colors.red.withAlpha(37),
                  width: double.infinity,
                  //height: 450,
                  child: Column(
                    children: myTransactions.where((x)=> x.date.month == currentMouth).toList().asMap().entries.map((entry) {
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
                          const EdgeInsets.symmetric(horizontal: 1, vertical: 4),
                          leading: CircleAvatar(
                            backgroundColor: colorByTransaction[selectedCategory],
                            child: transactionCategoryIcons[selectedCategory],
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
                                      fontSize: 12
                                  ),
                                ),
                              ),
                              Spacer(),
                              Text(
                                '${'${transaction.currency} '}${formatNumber(double.parse(transaction.amount.toStringAsFixed(2)))}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,//colorByTransaction[selectedCategory],
                                ),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                transaction.date.toString().substring(0, 10),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 10
                                ),
                              ),
                              if(selectedCategory=="debt")
                                Builder(
                                  builder: (context) {
                                    double remainingDeptAmount =
                                    CalculatePeriodTransaction.calculateRemainingAmountFromDept(
                                        transaction, myInfTransactions);

                                    double debtAmount =
                                    CalculatePeriodTransaction.calculateTotalDebtAmount(transaction);

                                    double percentage = 1 - (remainingDeptAmount / debtAmount);

                                    Color progressColor;

                                    if (percentage < 0.33) {
                                      progressColor = Colors.red;
                                    } else if (percentage < 0.66) {
                                      progressColor = Colors.orange;
                                    } else {
                                      progressColor = Colors.green;
                                    }

                                    return TweenAnimationBuilder<double>(
                                      tween: Tween(begin: 0, end: percentage),
                                      duration: const Duration(milliseconds: 900),
                                      curve: Curves.easeInOutCubic,
                                      builder: (context, value, _) {
                                        return LinearProgressIndicator(
                                          value: value,
                                          backgroundColor: Colors.grey[300],
                                          valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                                        );
                                      },
                                    );
                                  },
                                )
                            ]
                          ),
                          trailing: IconButton(onPressed: () async {
                            await showEditTransactionDialog(context, transaction);
                          }, icon: Icon(Icons.edit_outlined, size: 20, color: Colors.white.withAlpha(77),)),
                          onTap: () {
                            showBlurDialog(context, transaction);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            )
          ),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}