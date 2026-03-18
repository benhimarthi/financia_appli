import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/methods/format_number.dart';
import 'package:myapp/features/saving_goal/domain/entities/saving_goal.dart';
import 'package:myapp/features/saving_goal/presentation/cubit/saving_goal_cubit.dart';
import 'package:myapp/features/saving_goal/presentation/widgets/saving_goal_item_details.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';


class SavingGoalList extends StatefulWidget {
  final bool isLoading; // ← new: control when to show loading

  const SavingGoalList({
    super.key,
    this.isLoading = false,
  });

  @override
  State<SavingGoalList> createState() => _SavingGoalListState();
}

class _SavingGoalListState extends State<SavingGoalList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late List<SavingGoal> mySavingGoals;
  late List<SavingGoal> myInfSavingGoals;
  late int currentMouth;
  late int year;
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
    mySavingGoals=[];
    myInfSavingGoals=[];
    currentMouth = DateTime.now().month;
    year = DateTime.now().year;
    var authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccess) {
      context.read<SavingGoalCubit>().getSavingGoals(authState.user.id);
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
  void didUpdateWidget(covariant SavingGoalList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-trigger animation when new transactions arrive
    if (mySavingGoals.isNotEmpty) {
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
      SavingGoal savingGoal,
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
                color: Colors.black.withAlpha(25),
              ),
            ),

            // Dialog
            /*Center(
              child: EditTransactionDialog(
                transaction: transaction,
              ),
            ),*/
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
            Text("$value $unity", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),)
          ]
      ),
    );
  }

  void showBlurDialog(BuildContext context, SavingGoal savingGoal) {
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
                child: SavingGoalItemDetails(transaction: savingGoal),
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
                BlocConsumer<SavingGoalCubit, SavingGoalState>(
                    listener: (context, state){
                      if(state is SavingGoalLoaded){
                        setState(() {
                          myInfSavingGoals = state.savingGoals;
                          mySavingGoals = state.savingGoals;
                          //.where((x)=> x.category == widget.category && !x.isPrevision).toList();
                        });
                      }
                    },
                    builder: (context, state) {
                      return SizedBox();
                    }
                ),
                Text(
                  'Saving Goals'.toUpperCase(),
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
            /*Container(
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
                            if(myInfSavingGoals.where((x) => x.date.year == year && x.date.month == currentMouth).toList().isNotEmpty){
                              mySavingGoals = myInfSavingGoals.where((x) => x.date.year == year && x.date.month == currentMouth && x.category == widget.category).toList();
                            }
                          }else{
                            currentMouth = prevMouth;
                            if(myInfSavingGoals.where((x) => x.date.year == year && x.date.month == currentMouth).toList().isNotEmpty){
                              mySavingGoals = myInfSavingGoals.where((x) => x.date.year == year && x.date.month == currentMouth && x.category == widget.category).toList();
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
                            if(myInfSavingGoals.where((x) => x.date.year == year && x.date.month == currentMouth).toList().isNotEmpty){
                              mySavingGoals = myInfSavingGoals.where((x) => x.date.year == year && x.date.month == currentMouth && x.category == widget.category).toList();
                            }
                          }else{
                            currentMouth = nextMouth;
                            if(myInfSavingGoals.where((x) => x.date.year == year && x.date.month == currentMouth).toList().isNotEmpty){
                              mySavingGoals = myInfSavingGoals.where((x) => x.date.year == year && x.date.month == currentMouth && x.category == widget.category).toList();
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
            ),*/
            const SizedBox(height: 16),
            /*Container(
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
                                    mySavingGoals = myInfSavingGoals.where((x)=>x.category.name == selectedCategory).toList();
                                  });
                                },
                                child: Center(child: Text(TransactionCategory.values[x].name, style: TextStyle(color: selectedCategory ==  TransactionCategory.values[x].name ? Colors.white: Colors.white.withAlpha(55)),)),
                              )
                          ))
                //TransactionCategory.values.map((x)=> Container(child: ListTile(title: Text(x.name),))).toList(),
              ),
            ),*/
            const SizedBox(height: 16),
            /*Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Builder(
                    builder: (context) {
                      double totAmount = CalculatePeriodTransaction.calculateMonthTotalTransaction(mySavingGoals, widget.category, currentMouth, year);
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
                      int totNb = mySavingGoals.where((x)=> x.date.month == currentMouth).toList().length;
                      return showInformationBox("Trans nb", "", totNb.toString(),
                          colorByTransaction[selectedCategory]!);
                    }
                ),
                Builder(
                    builder: (context) {
                      double value = CalculatePeriodTransaction.calculateMonthEvolution(
                          myInfSavingGoals.where((transaction) => transaction.category == widget.category).toList(),
                          widget.category, currentMouth, year);
                      return showInformationBox("Progression","%", (value * 100).toStringAsFixed(1),
                          colorByTransaction[selectedCategory]!);
                    }
                )
              ],
            ),*/
          ]
      ),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
          maxWidth: MediaQuery.of(context).size.width * 0.99,
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
        child: widget.isLoading || mySavingGoals.isEmpty
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
                children: mySavingGoals.asMap().entries.map((entry) {
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
                        backgroundColor: Colors.white,
                        child: Icon(Icons.tablet_rounded, color: Colors.grey[600], size: 20),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              transaction.name.isNotEmpty
                                  ? transaction.name.toUpperCase()
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
                            '${'${transaction.currency} '}${formatNumber(double.parse(transaction.currentAmount.toStringAsFixed(2)))}',
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
                            Builder(
                              builder: (context) {
                                double remainingSavingAmount = transaction.targetAmount - transaction.currentAmount;
                                double percentage = 1 - (remainingSavingAmount / transaction.targetAmount);
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
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}