import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/auth/data/models/user_model.dart';
import 'package:myapp/features/auth/domain/entities/account_type.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:myapp/features/auth/presentation/pages/location_currency_page.dart';
import 'package:myapp/features/auth/presentation/pages/password_page.dart';
import 'package:myapp/features/auth/presentation/pages/purpose_page.dart';
import 'package:myapp/features/transaction/domain/entities/transaction.dart';
import 'package:myapp/features/transaction/presentation/bloc/transaction_cubit.dart';
import 'package:myapp/features/transaction/presentation/bloc/transaction_state.dart';
import 'package:uuid/uuid.dart';
import 'email_page.dart';
import 'name_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

enum Progress { purpose, name, email, currency, password, validate }

class _SignUpPageState extends State<SignUpPage> {
  late Progress progress;
  late AccountType accountType;
  late String name;
  late String email;
  late String password;
  late String location;
  late String currency;
  late double pageProgress;
  late String selectedCountry;
  late String selectedCurrency;
  late List<Transaction> transactions;

  @override
  void initState() {
    super.initState();
    progress = Progress.purpose;
    accountType = AccountType.business;
    name = '';
    email = '';
    password = '';
    location = '';
    currency = '';
    pageProgress = 0.25;
    selectedCountry = "";
    selectedCurrency = "";
    transactions = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(value: pageProgress),
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            for (var x in transactions) {
              context.read<TransactionCubit>().addTransaction(x);
            }
          }
          setState(() {
            if (state is EmitRandomELement) {
              //if the purpose is emitted
              if (state.elements["purpose"] != null) {
                switch (state.elements["purpose"]) {
                  case "Personal Finance":
                    accountType = AccountType.personal;
                    break;
                  case "Business Finance":
                    accountType = AccountType.business;
                    break;
                  default:
                }
              }
              //if page is validate
              if (state.elements["page"] != null) {
                if (state.elements["page"] == "validate") {}
              }
              //if the name is emited
              if (state.elements["name"] != null) {
                name = state.elements["name"];
              }
              //if the email is emitted
              if (state.elements["email"] != null) {
                email = state.elements["email"];
              }
              //if the currency is emitted
              if (state.elements["currency"] != null) {
                currency = state.elements["currency"];
              }
              //if the location is emitted
              if (state.elements["location"] != null) {
                location = state.elements["location"];
              }
              //it the selected country is emitted
              if (state.elements["selectedCountry"] != null) {
                selectedCountry = state.elements["selectedCountry"];
              }
              //if the selected currency is emitted
              if (state.elements["selectedCurrency"] != null) {
                selectedCurrency = state.elements["selectedCurrency"];
              }
              // if the password is emitted
              if (state.elements["password"] != null) {
                password = state.elements["password"];
              }
              //if the transaction is emitted
              if (state.elements["page"] != null) {
                if (state.elements["transaction"] != null) {
                  transactions = state.elements["transaction"];
                }
              }
              //if the page is emitted
              if (state.elements["page"] != null) {
                switch (state.elements["page"]) {
                  case "purpose":
                    pageProgress = .2;
                    progress = Progress.purpose;
                    break;
                  case "name":
                    progress = Progress.name;
                    pageProgress = .4;
                    break;
                  case "email":
                    pageProgress = .6;
                    progress = Progress.email;
                    break;
                  case "password":
                    pageProgress = .8;
                    progress = Progress.password;
                    break;
                  case "currency":
                    pageProgress = 1;
                    progress = Progress.currency;
                    break;
                  case "validate":
                    pageProgress = 1;
                    context.read<AuthCubit>().signUp(
                      userMd: UserModel(
                        id: Uuid().v4(),
                        email: email,
                        name: name,
                        createdAt: DateTime.now().toIso8601String(),
                        updatedAt: DateTime.now().toIso8601String(),
                        accountType: accountType,
                      ),
                      password: password,
                    );
                    progress = Progress.validate;
                    break;
                  default:
                }
              }
            }
          });
        },
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              final isGoingOut = child.key != ValueKey<Progress>(progress);

              final slideIn = Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation);

              final slideOut = Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(1.0, 0.0),
              ).animate(animation);

              if (isGoingOut) {
                // Widget is leaving
                return ClipRect(
                  child: FadeTransition(
                    opacity: Tween<double>(
                      begin: 1.0,
                      end: 0.0,
                    ).animate(animation),
                    child: SlideTransition(position: slideOut, child: child),
                  ),
                );
              } else {
                // Widget is entering
                return ClipRect(
                  child: FadeTransition(
                    opacity: animation,
                    child: SlideTransition(position: slideIn, child: child),
                  ),
                );
              }
            },
            child: Builder(
              key: ValueKey<Progress>(progress),
              builder: (context) {
                switch (progress) {
                  case Progress.purpose:
                    return PurposePage();
                  case Progress.name:
                    return NamePage(name: name);
                  case Progress.email:
                    return EmailPage(email: email);
                  case Progress.currency:
                    return LocationCurrencyPage(
                      selectedCountry: selectedCountry,
                      selectedCurrency: selectedCurrency,
                      transactions: transactions,
                    );
                  case Progress.password:
                    return PasswordPage(password: password);
                  case Progress.validate:
                    return BlocConsumer<TransactionCubit, TransactionState>(
                      listener: (context, state) {
                        if (state is TransactionLoaded) {}
                      },
                      builder: (context, state) {
                        return const Center(child: CircularProgressIndicator());
                      },
                    );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
