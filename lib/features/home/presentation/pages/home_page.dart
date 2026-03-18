import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:myapp/features/finances/presentation/pages/finances_page.dart';
import 'package:myapp/features/saving_goal/presentation/widgets/financial_goal_form.dart';
import 'package:myapp/features/home/presentation/pages/home_content.dart';
import 'package:myapp/features/home/presentation/widgets/home_bottom_navigation_bar.dart';
import 'package:myapp/features/plan/presentation/pages/plan_page.dart';
import 'package:myapp/features/transaction/domain/entities/transaction.dart';
import 'package:myapp/features/transaction/presentation/widgets/debt_form.dart';
import 'package:myapp/features/transaction/presentation/widgets/expense_transaction_form.dart';
import 'package:myapp/features/transaction/presentation/widgets/income_transaction_form.dart';
import 'package:myapp/features/transaction/presentation/widgets/transfer_form.dart';
import 'package:myapp/features/wealth/presentation/pages/wealth_page.dart';
import 'package:myapp/locale_provider.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../plan/presentation/widgets/show_chat_assistant.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../../../transaction/domain/entities/transaction_category.dart';
import '../../../transaction/presentation/bloc/transaction_cubit.dart';
import '../../../transaction/presentation/bloc/transaction_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late List<Transaction> transactions;

  final List<Widget> _pages = [
    const HomeContent(),
    const FinancesPage(),
    const PlanPage(),
    Center(child: Text('learn_page'.tr())),
    const WealthPage(),
  ];

  @override
  void initState() {
    super.initState();
    transactions = [];
    var authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccess) {
      context.read<TransactionCubit>().setUserId(authState.user.id);
      context.read<TransactionCubit>().getTransactions();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
          ? IncomeTransactionForm(isPrevision: false)
          : ExpenseTransactionForm(isPrevision: false),
    );
  }

  void _showTransferForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (_, controller) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: TransferForm(
              scrollController: controller,
            ), // Pass the controller
          );
        },
      ),
    );
  }

  void _showFinancialGoalForm() {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccess) {
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
        builder: (context) => FinancialGoalForm(),
      );
    }
  }

  void _showDebtForm() {
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
      builder: (context) => const DebtForm(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    return Scaffold(
      appBar: AppBar(
        //elevation: 1,
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        title: Container(
          padding: const EdgeInsets.all(8),
          width: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(18, 0, 0, 0),
                offset: Offset(2, 3),
                blurRadius: 15,
              ),
            ],
          ),
          child: Builder(
            builder: (BuildContext context) {
              final authState = context.read<AuthCubit>().state;
              return Row(
                children: [
                  const CircleAvatar(child: Icon(Icons.person_2_outlined)),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authState is AuthSuccess
                            ? authState.user.name
                            : 'guest_user'.tr(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        authState is AuthSuccess
                            ? authState.user.accountType.name
                            : 'personal_account'.tr(),
                        style: TextStyle(color: Colors.black45, fontSize: 12),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.expand_more, color: Colors.black),
                ],
              );
            },
          ),
        ),
        actions: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(18, 0, 0, 0),
                      offset: Offset(2, 3),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    if (localeProvider.locale.languageCode == 'en') {
                      localeProvider.setLocale(const Locale('fr', 'FR'));
                      context.setLocale(const Locale('fr', 'FR'));
                    } else {
                      localeProvider.setLocale(const Locale('en', 'US'));
                      context.setLocale(const Locale('en', 'US'));
                    }
                  },
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "EN",
                          style: TextStyle(
                            color: localeProvider.locale.languageCode == 'en'
                                ? Theme.of(context).primaryColor
                                : Colors.black26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: " / "),
                        TextSpan(
                          text: "FR",
                          style: TextStyle(
                            color: localeProvider.locale.languageCode == 'fr'
                                ? Theme.of(context).primaryColor
                                : Colors.black26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                      style: const TextStyle(
                        color: Colors.black26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(18, 0, 0, 0),
                      offset: Offset(2, 3),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.notifications_none,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(18, 0, 0, 0),
                        offset: Offset(2, 3),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.settings, color: Colors.black54),
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(child: _pages[_selectedIndex]),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SpeedDial(
            icon: Icons.add,
            activeIcon: Icons.close,
            backgroundColor: Colors.green[200],
            foregroundColor: Colors.black,
            activeBackgroundColor: Colors.grey[300],
            activeForegroundColor: Colors.black,
            buttonSize: const Size(56.0, 56.0),
            childrenButtonSize: const Size(56.0, 56.0),
            visible: true,
            closeManually: false,
            curve: Curves.bounceIn,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            tooltip: 'Speed Dial',
            heroTag: 'speed-dial-hero-tag',
            elevation: 8.0,
            shape: const CircleBorder(),
            children: [
              SpeedDialChild(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.trending_up, color: Colors.white),
                ),
                backgroundColor: Colors.transparent,
                label: 'add_income'.tr(),
                labelStyle: const TextStyle(fontSize: 18.0),
                onTap: () => _showTransactionForm(TransactionCategory.income),
                shape: ShapeBorder.lerp(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(60.0)),
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(60.0)),
                  1,
                ),
              ),
              SpeedDialChild(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.trending_down, color: Colors.white),
                ),
                backgroundColor: Colors.transparent,
                label: 'add_expense'.tr(),
                labelStyle: const TextStyle(fontSize: 18.0),
                onTap: () => _showTransactionForm(TransactionCategory.expense),
              ),
              SpeedDialChild(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color.fromARGB(69, 33, 243, 100),
                  child: Image.asset("assets/icons/Bullseye.png", scale: 5),
                ),
                backgroundColor: Colors.transparent,
                label: 'add financial goal',
                labelStyle: const TextStyle(fontSize: 18.0),
                shape: ShapeBorder.lerp(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                  1,
                ),
                onTap: () => _showFinancialGoalForm(),
              ),
              SpeedDialChild(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.swap_horiz, color: Colors.white),
                ),
                backgroundColor: Colors.transparent,
                label: 'transfer'.tr(),
                labelStyle: const TextStyle(fontSize: 18.0),
                onTap: () => _showTransferForm(),
              ),

              SpeedDialChild(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.orange,
                  child: const Icon(Icons.credit_card, color: Colors.white),
                ),
                backgroundColor: Colors.transparent,
                label: 'add_debt'.tr(),
                labelStyle: const TextStyle(fontSize: 18.0),
                onTap: () => _showDebtForm(),
              ),
            ],
          ),
          SizedBox(height: 10,),
          BlocConsumer<TransactionCubit, TransactionState>(
            listener: (context, state){
              if(state is TransactionLoaded){
                setState(() {
                  transactions = state.transactions;
                });
              }
            },
            builder: (context, state) {
              return SizedBox();
            },
          ),
          GestureDetector(
            onTap: () {
              showChatAssistant(context, transactions);
            },
            child: CircleAvatar(
              radius: 30,

              backgroundColor: Colors.grey[200],
              child: Image.asset("assets/icons/gemini.png", scale:1,),
            ),
          )
        ]
      ),
      bottomNavigationBar: HomeBottomNavigationBar(
        onItemTapped: _onItemTapped,
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
