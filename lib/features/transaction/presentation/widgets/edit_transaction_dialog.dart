import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:myapp/features/transaction/data/models/transaction_model.dart';
import 'package:myapp/features/transaction/domain/entities/expense_tags.dart';
import 'package:myapp/features/transaction/domain/entities/transaction.dart';
import 'package:myapp/features/transaction/domain/entities/transaction_category.dart';

import '../../domain/entities/income_tags.dart';
import '../../domain/entities/currency.dart';
import '../bloc/transaction_cubit.dart';

class EditTransactionDialog extends StatefulWidget {
  final Transaction transaction;
  const EditTransactionDialog({Key? key, required this.transaction}) : super(key: key);

  @override
  State<EditTransactionDialog> createState() =>
      _EditTransactionDialogState();
}

class _EditTransactionDialogState
    extends State<EditTransactionDialog>
    with SingleTickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  String? _selectedTag;
  String? _selectedCurrency;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  late List<String> _tags;

  final List<String> _currencies = Currency.values.map((currency) => currency.symbol).toList();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation =
        Tween<double>(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );

    _fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeIn,
          ),
        );
    if(widget.transaction.category == TransactionCategory.income || widget.transaction.category == TransactionCategory.expense){
      _tags = widget.transaction.category == TransactionCategory.income ? IncomeTags.values.map((x)=>x.name).toList()
          : ExpenseTags.values.map((x)=>x.name).toList();
    }else{
      _tags = [];
    }

    _priceController.text = widget.transaction.amount.toString();
    _detailsController.text = widget.transaction.description;
    _selectedTag = widget.transaction.tag;
    if(widget.transaction.currency != null) {
      _selectedCurrency = widget.transaction.currency.toString();
    }else{
      var authState = context.read<AuthCubit>().state;
      if(authState is AuthSuccess){
        _selectedCurrency = authState.user.currentCurrency.toString();
      }
    }
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _priceController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withAlpha(20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.white),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.white, width: 2),
      ),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AlertDialog(
          title: Text("Edit Transaction", style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.transparent,
          elevation: 0,
          contentPadding: EdgeInsets.zero,
          content: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(25),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.white.withAlpha(51)),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text.rich(TextSpan(text: "Date : ", children: [
                          TextSpan(text: widget.transaction.date.toString().substring(0, 10), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        ]), style: TextStyle(color: Colors.white),),
                        const SizedBox(height: 12),
                        /// 🔹 PRICE + CURRENCY
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                controller: _priceController,
                                keyboardType:
                                TextInputType.number,
                                style: const TextStyle(
                                    color: Colors.white),
                                decoration:
                                _inputDecoration("Price").copyWith(
                                  prefixText: "${widget.transaction.currency.toString()} ",
                                ),

                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        /// 🔹 TAG
                        Visibility(
                          visible: widget.transaction.category == TransactionCategory.income ||
                              widget.transaction.category == TransactionCategory.expense,
                          child: DropdownButtonFormField<String>(
                            initialValue: _selectedTag,
                            dropdownColor: Colors.black87,
                            isExpanded: true,
                            iconEnabledColor: Colors.white,
                            style: const TextStyle(
                                color: Colors.white),
                            decoration:
                            _inputDecoration("Tag"),
                            items: _tags
                                .map((tag) =>
                                DropdownMenuItem(
                                  value: tag,
                                  child: Text(tag),
                                ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedTag = value;
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// 🔹 DETAILS
                        TextFormField(
                          controller: _detailsController,
                          maxLines: 3,
                          style: const TextStyle(
                              color: Colors.white),
                          decoration:
                          _inputDecoration("Details"),
                        ),

                        const SizedBox(height: 25),

                        /// 🔹 BUTTONS
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                    color: Colors.red,),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton
                                  .styleFrom(
                                backgroundColor:
                                Colors.white,
                                foregroundColor:
                                Colors.black,
                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      12),
                                ),
                              ),
                              onPressed: () {
                                var modifyTransaction = TransactionModel.fromTransaction(widget.transaction);
                                modifyTransaction = modifyTransaction.copyWith(
                                  amount: double.parse(_priceController.text),
                                  description: _detailsController.text,
                                  tag: _selectedTag!,
                                );
                                if(widget.transaction.currency == null){
                                  modifyTransaction = modifyTransaction.copyWith(
                                    currency: _selectedCurrency,
                                  );
                                }
                                context.read<TransactionCubit>().updateTransaction(modifyTransaction);
                                Navigator.pop(context);
                              },
                              child: const Text("Save"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}