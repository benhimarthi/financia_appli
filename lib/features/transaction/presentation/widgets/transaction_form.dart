import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:myapp/features/transaction/domain/entities/debt_tags.dart';
import 'package:myapp/features/transaction/domain/entities/expense_tags.dart';
import 'package:myapp/features/transaction/domain/entities/income_tags.dart';
import 'package:myapp/features/transaction/domain/entities/periodicity.dart';
import 'package:myapp/features/transaction/domain/entities/transaction.dart';
import 'package:myapp/features/transaction/domain/entities/transaction_category.dart';
import 'package:uuid/uuid.dart';

class TransactionForm extends StatefulWidget {
  final Transaction? transition;
  const TransactionForm({super.key, required this.transition});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _interestRateController = TextEditingController();
  TransactionCategory _selectedCategory = TransactionCategory.expense;
  DateTime _selectedDate = DateTime.now();
  Periodicity _selectedPeriodicity = Periodicity.none;
  bool _isPrevision = false;
  late bool update;
  late String uid;
  String? _selectedTag;

  @override
  void initState() {
    super.initState();
    update = false;
    uid = const Uuid().v4();
    if (widget.transition != null) {
      update = true;
      uid = widget.transition!.id;
      _selectedCategory = widget.transition!.category;
      _selectedPeriodicity = widget.transition!.periodicity;
      _descriptionController.text = widget.transition!.description;
      _amountController.text = widget.transition!.amount.toString();
      _selectedDate = widget.transition!.date;
      _selectedTag = widget.transition!.tag;
      _isPrevision = widget.transition!.isPrevision;
      if (widget.transition!.interestRate != null) {
        _interestRateController.text = widget.transition!.interestRate
            .toString();
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SwitchListTile(
                title: const Text('Is Prevision'),
                value: _isPrevision,
                onChanged: (bool value) {
                  setState(() {
                    _isPrevision = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<TransactionCategory>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: TransactionCategory.values
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category.toString().split('.').last),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                    _selectedTag = null;
                  });
                },
              ),
              const SizedBox(height: 10),
              if (_selectedCategory == TransactionCategory.expense)
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Tag',
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  initialValue: _selectedTag,
                  items: ExpenseTags.values
                      .map(
                        (tag) => DropdownMenuItem(
                          value: tag.toString().split('.').last,
                          child: Text(tag.toString().split('.').last),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTag = value;
                    });
                  },
                )
              else if (_selectedCategory == TransactionCategory.debt)
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Tag',
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  initialValue: _selectedTag,
                  items: DebtTags.values
                      .map(
                        (tag) => DropdownMenuItem(
                          value: tag.toString().split('.').last,
                          child: Text(tag.toString().split('.').last),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTag = value;
                    });
                  },
                )
              else
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Tag',
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  initialValue: _selectedTag,
                  items: IncomeTags.values
                      .map(
                        (tag) => DropdownMenuItem(
                          value: tag.toString().split('.').last,
                          child: Text(tag.toString().split('.').last),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTag = value;
                    });
                  },
                ),
              const SizedBox(height: 10),
              DropdownButtonFormField<Periodicity>(
                initialValue: _selectedPeriodicity,
                decoration: const InputDecoration(
                  labelText: 'Periodicity',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: Periodicity.values
                    .map(
                      (periodicity) => DropdownMenuItem(
                        value: periodicity,
                        child: Text(periodicity.toString().split('.').last),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPeriodicity = value!;
                  });
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              if (_selectedCategory == TransactionCategory.debt)
                TextFormField(
                  controller: _interestRateController,
                  decoration: const InputDecoration(
                    labelText: 'Interest Rate (%)',
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
              if (_selectedCategory == TransactionCategory.debt)
                const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        'Date: ${DateFormat.yMd().format(_selectedDate)}',
                      ),
                    ),
                    TextButton(
                      onPressed: () => _selectDate(context),
                      child: const Text('Select Date'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final authState = context.read<AuthCubit>().state;
                    if (authState is AuthSuccess) {
                      final transaction = Transaction(
                        id: uid,
                        userId: authState.user.id,
                        description: _descriptionController.text,
                        amount: double.parse(_amountController.text),
                        date: _selectedDate,
                        category: _selectedCategory,
                        periodicity: _selectedPeriodicity,
                        isPrevision: _isPrevision,
                        tag: _selectedTag!,
                        interestRate:
                            _selectedCategory == TransactionCategory.debt &&
                                _interestRateController.text.isNotEmpty
                            ? double.tryParse(_interestRateController.text)
                            : null,
                      );
                      /*context.read<TransactionCubit>().addTransaction(
                        transaction,
                      );*/
                      context.read<AuthCubit>().emitRandomELement({
                        "transaction": transaction,
                        "update": update,
                        //"purpose": "Personal Finance"
                        //"page": "home",
                      });
                      Navigator.of(context).pop();
                    }
                  }
                },
                child: update
                    ? const Text('Update Transaction')
                    : const Text('Add Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
