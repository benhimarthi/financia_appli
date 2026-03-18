import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:myapp/features/saving_goal/presentation/cubit/saving_goal_cubit.dart';
import 'package:myapp/features/settings/presentation/cubit/export_data_cubit.dart';
import 'package:myapp/features/transaction/domain/entities/transaction.dart';
import 'package:myapp/features/transaction/domain/entities/transaction_category.dart';
import 'package:myapp/features/transaction/presentation/bloc/transaction_cubit.dart';
import 'package:myapp/injection_container.dart';

import '../../../saving_goal/domain/entities/saving_goal.dart';
import '../../../transaction/presentation/bloc/transaction_state.dart'; // For service locator 'sl'

class ExportDataPage extends StatefulWidget {
  const ExportDataPage({super.key});

  @override
  State<ExportDataPage> createState() => _ExportDataPageState();
}

// These enums should match what the Cubit expects
// enum ExportFormat { csv, pdf, json } // Already defined in cubit
enum DateRange { thisMonth, last3Months, thisYear, allTime }

class _ExportDataPageState extends State<ExportDataPage> {
  ExportFormat _selectedFormat = ExportFormat.csv;
  late DateRange _selectedDateRange = DateRange.thisMonth;
  late List<Transaction> transactions;
  late List<SavingGoal> savingGoals;

  late List<Transaction> filteredTransaction;
  late List<SavingGoal> filteredSavingGoals;


  @override
  void initState() {
    super.initState();
    filteredTransaction = [];
    filteredSavingGoals = [];
    savingGoals = [];
    var authState = context.read<AuthCubit>().state;
    if(authState is AuthSuccess){
      context.read<TransactionCubit>().setUserId(authState.user.id);
      context.read<TransactionCubit>().getTransactions();
      context.read<SavingGoalCubit>().getSavingGoals(authState.user.id);
    }
  }

  // This method will contain the logic to call the cubit
  void _onExportPressed() {
    context.read<ExportDataCubit>().exportFinancialSummary(
        allTransactions: transactions,
        savingGoals: savingGoals,
        debts: transactions.where((x)=>x.category == TransactionCategory.debt).toList(),
        financialScore: 0, format: _selectedFormat
    );
    context.read<ExportDataCubit>().exportUserData(
      allTransactions: filteredTransaction,
      transactionType : TransactionCategory.income, // Example category
      format: _selectedFormat,
      td: 0, // Example tendency, you would calculate this
    );
    context.read<ExportDataCubit>().exportUserData(
      allTransactions: filteredTransaction,
      transactionType : TransactionCategory.expense, // Example category
      format: _selectedFormat,
      td: 0, // Example tendency, you would calculate this
    );
    context.read<ExportDataCubit>().exportUserData(
      allTransactions: filteredTransaction,
      transactionType : TransactionCategory.transfert, // Example category
      format: _selectedFormat,
      td: 0, // Example tendency, you would calculate this
    );
    context.read<ExportDataCubit>().exportUserData(
      allTransactions: filteredTransaction,
      transactionType : TransactionCategory.debt, // Example category
      format: _selectedFormat,
      td: 0, // Example tendency, you would calculate this
    );
  }

  @override
  Widget build(BuildContext context) {
    // Provide the Cubit to the widget tree
    return BlocProvider(
      create: (context) => sl<ExportDataCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('export_data'.tr()),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Theme
              .of(context)
              .scaffoldBackgroundColor,
          elevation: 0,
          foregroundColor: Theme
              .of(context)
              .textTheme
              .bodyLarge
              ?.color,
        ),
        // Use a BlocConsumer to listen to state changes and build the UI
        body: BlocConsumer<ExportDataCubit, ExportDataState>(
          listener: (context, state) {
            if (state is ExportDataSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                        'Export successful! File is ready to be shared.'),
                    backgroundColor: Colors.green,
                  ),
                );
            }
            else if (state is ExportDataFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('Export failed: ${state.message}'),
                    backgroundColor: Colors.red,
                  ),
                );
            }
          },
          builder: (context, state) {
            final isLoading = state is ExportDataLoading;

            // Stack to show a loading overlay
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocConsumer<TransactionCubit, TransactionState>(
                        listener: (context, state){
                          if(state is TransactionLoaded){
                            transactions = state.transactions;
                            filteredTransaction = transactions.where((x)=> x.date.month == DateTime.now().month).toList();
                          }
                        },
                        builder: (context, state) {
                          return SizedBox();
                        }
                      ),
                      BlocConsumer<SavingGoalCubit, SavingGoalState>(
                        listener: (context, state){
                          if(state is SavingGoalLoaded){
                            savingGoals = state.savingGoals;
                          }
                        },
                        builder: (context, state){
                          return SizedBox();
                        },
                      ),
                      Text(
                        'Export format'.tr(),
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildFormatCard(
                            format: ExportFormat.csv,
                            icon: Icons.article_outlined,
                            title: 'CSV',
                            subtitle: 'Excel compatible'.tr(),
                          ),
                          _buildFormatCard(
                            format: ExportFormat.pdf,
                            icon: Icons.picture_as_pdf_outlined,
                            title: 'PDF',
                            subtitle: 'Print ready'.tr(),
                          ),
                          _buildFormatCard(
                            format: ExportFormat.json,
                            icon: Icons.code_outlined,
                            title: 'JSON',
                            subtitle: 'Developer friendly'.tr(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Date range'.tr(),
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          children: [
                            _buildDateRangeTile(
                                DateRange.thisMonth, 'This month'.tr(),
                                    (){
                                  setState(() {
                                    filteredTransaction = transactions.where((x)=>x.date.month == DateTime.now().month).toList();
                                    filteredSavingGoals = savingGoals.where((x)=>x.date.month == DateTime.now().month).toList();
                                    _selectedDateRange = DateRange.thisMonth;
                                  });
                                    }
                            ),
                            const Divider(height: 1),
                            _buildDateRangeTile(
                                DateRange.last3Months, 'Last 3 months'.tr(), (){
                                  setState(() {
                                    filteredTransaction = transactions.where((x){
                                      int currentM = DateTime.now().month;
                                      int lastM = currentM == 1 ? 12 : currentM - 1;
                                      int lastLastM = lastM-1;
                                      return x.date.month == currentM ||
                                          x.date.month == lastM ||
                                          x.date.month == lastLastM;
                                    }).toList();
                                    _selectedDateRange = DateRange.last3Months;
                                  });
                            }),
                            const Divider(height: 1),
                            _buildDateRangeTile(
                                DateRange.thisYear, 'This year'.tr(), (){
                                  setState(() {
                                    filteredTransaction = transactions.where(
                                            (x)=>x.date.year == DateTime.now().year
                                    ).toList();
                                    _selectedDateRange = DateRange.thisYear;
                                  });
                            }),
                            const Divider(height: 1),
                            _buildDateRangeTile(
                                DateRange.allTime, 'All time'.tr(), (){
                                  setState(() {
                                    filteredTransaction = transactions;
                                    _selectedDateRange = DateRange.allTime;
                                  });
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Loading overlay
                if (isLoading)
                  Container(
                    color: Colors.black.withAlpha(125),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(color: Colors.white),
                          const SizedBox(height: 16),
                          Text(
                            'exporting_data'.tr(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.file_download_outlined),
            label: Text('Export data'.tr()),
            // Call the export method when pressed
            onPressed: _onExportPressed,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormatCard({
    required ExportFormat format,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selectedFormat == format;
    return GestureDetector(
      onTap: () => setState(() => _selectedFormat = format),
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width / 3 - 24,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Theme
              .of(context)
              .primaryColor
              .withAlpha(23) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Theme
                .of(context)
                .primaryColor : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Theme
                .of(context)
                .primaryColor),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: Theme
                .of(context)
                .textTheme
                .bodySmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangeTile(DateRange range, String title, Function() onTap) {
    final isSelected = _selectedDateRange == range;
    return ListTile(
      title: Text(title),
      trailing: isSelected ? Icon(Icons.check_circle, color: Theme
          .of(context)
          .primaryColor) : null,
      onTap: onTap, //() => setState(() => _selectedDateRange = range),
    );
  }
}