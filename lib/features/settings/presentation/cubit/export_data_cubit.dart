import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/methods/calculate_period_total_transaction.dart';
import 'package:myapp/features/transaction/domain/entities/transaction.dart';
import 'package:myapp/features/transaction/domain/entities/transaction_category.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:csv/csv.dart';
import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

import '../../../saving_goal/domain/entities/saving_goal.dart';

// Define the states for the Cubit
abstract class ExportDataState {}

class ExportDataInitial extends ExportDataState {}

class ExportDataLoading extends ExportDataState {}

class ExportDataSuccess extends ExportDataState {
  final String filePath;

  ExportDataSuccess(this.filePath);
}

class ExportDataFailure extends ExportDataState {
  final String message;

  ExportDataFailure(this.message);
}

enum ExportFormat { csv, json, pdf }

class ExportDataCubit extends Cubit<ExportDataState> {
  // The repository is no longer needed here.
  ExportDataCubit() : super(ExportDataInitial());

  // The method now accepts the list of transactions and the category type.
  Future<void> exportUserData({
    required List<Transaction> allTransactions,
    required TransactionCategory transactionType,
    required ExportFormat format,
    required double td,
  }) async {
    emit(ExportDataLoading());
    try {
      // 1. Filter transactions based on the provided category.
      final filteredTransactions = allTransactions
          .where((t) => t.category == transactionType)
          .toList();

      if (filteredTransactions.isEmpty) {
        throw Exception('No transactions found for the selected category.');
      }

      // 2. Format and save the data to a file.
      final file = await _createFile(
        transactions: filteredTransactions,
        transactionType: transactionType,
        format: format,
        td: td,
      );

      // 3. Use the share_plus package to open the share dialog.
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Here is your exported ${transactionType.name} data.',
      );

      emit(ExportDataSuccess(file.path));
    } catch (e) {
      emit(ExportDataFailure(e.toString()));
    }
  }

  Future<File> _createFile({
    required List<Transaction> transactions,
    required TransactionCategory transactionType,
    required ExportFormat format,
    required double td,
  }) async {
    final directory = await getApplicationDocumentsDirectory();
    final reportDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // Filename now includes the transaction type (e.g., Income_Report_...).
    final fileName = '${transactionType.name.capitalize()}Report_$reportDate';
    final path = '${directory.path}/$fileName';
    String finalPath;

    // Calculate the total amount for the filtered transactions.
    final double totalAmount = transactions.fold(
        0.0, (sum, item) => sum + item.amount);

    // Calculate tendency for the filtered transactions.
    final double tendency = td;

    // Define the title based on the transaction type.
    final String title = '${transactionType.name.capitalize()} Report';

    switch (format) {
      case ExportFormat.json:
        finalPath = '$path.json';
        final data = {
          'title': title,
          'reportDate': reportDate,
          'transactions': transactions.map((t) =>
          {
            'Date': t.date.toIso8601String(),
            'Description': t.description,
            'Amount': t.amount,
            'Tag': t.tag,
            'Category': t.category.name,
            'Currency': t.currency,
          }).toList(),
          'summary': {
            'totalAmount': totalAmount,
            'monthlyTendency': '${tendency.toStringAsFixed(2)}%',
          }
        };
        final content = const JsonEncoder.withIndent('  ').convert(data);
        return File(finalPath)
          ..writeAsString(content);

      case ExportFormat.csv:
        finalPath = '$path.csv';
        List<List<dynamic>> rows = [];
        rows.add([title]);
        rows.add([]);
        rows.add(
            ['Date', 'Description', 'Amount', 'Tag', 'Category', 'Currency']);
        for (var t in transactions) {
          rows.add([
            t.date
                .toIso8601String()
                .split('T')
                .first,
            t.description,
            t.amount,
            t.tag,
            t.category.name,
            t.currency ?? 'N/A',
          ]);
        }
        rows.add([]);
        rows.add(
            ['', '', '', '', 'Total Amount:', totalAmount.toStringAsFixed(2)]);
        rows.add([
          '',
          '',
          '',
          '',
          'Monthly Tendency:',
          '${tendency.toStringAsFixed(2)}%'
        ]);
        final content = csv.encode(rows);
        return File(finalPath)
          ..writeAsString(content);

      case ExportFormat.pdf:
        finalPath = '$path.pdf';
        final pdf = pw.Document();
        pdf.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(32),
            header: (context) =>
                pw.Header(
                  level: 0,
                  child: pw.Text(title, style: pw.Theme
                      .of(context)
                      .header0),
                ),
            build: (context) =>
            [
              pw.Table.fromTextArray(
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headers: [
                  'Date',
                  'Description',
                  'Amount',
                  'Tag',
                  'Category',
                  'Currency'
                ],
                data: transactions.map((t) =>
                [
                  t.date
                      .toIso8601String()
                      .split('T')
                      .first,
                  t.description,
                  t.amount.toStringAsFixed(2),
                  t.tag,
                  t.category.name,
                  t.currency ?? 'N/A',
                ]).toList(),
              ),
              pw.Divider(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Total Amount: ${totalAmount.toStringAsFixed(2)}',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 14),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        'Monthly Tendency: ${tendency.toStringAsFixed(2)}%',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
        final bytes = await pdf.save();
        return File(finalPath)
          ..writeAsBytes(bytes);
    }
  }
  // =======================================================================
  //  NEW METHOD FOR SAVING GOALS
  // =======================================================================
  Future<void> exportSavingGoals({
    required List<SavingGoal> savingGoals,
    required ExportFormat format,
  }) async {
    emit(ExportDataLoading());
    try {
      if (savingGoals.isEmpty) {
        throw Exception('No saving goals found to export.');
      }

      // Format and save the data to a file.
      final file = await _createSavingGoalFile(
        savingGoals: savingGoals,
        format: format,
      );

      // Use the share_plus package to open the share dialog.
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Here is your exported Saving Goals data.',
      );

      emit(ExportDataSuccess(file.path));
    } catch (e) {
      emit(ExportDataFailure(e.toString()));
    }
  }

  Future<File> _createSavingGoalFile({
    required List<SavingGoal> savingGoals,
    required ExportFormat format,
  }) async {
    final directory = await getApplicationDocumentsDirectory();
    final reportDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final fileName = 'SavingGoals_Report_$reportDate';
    final path = '${directory.path}/$fileName';
    String finalPath;

    const String title = 'Saving Goals Report';

    // Helper to format a date as YYYY-MM-DD
    String formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

    switch (format) {
      case ExportFormat.json:
        finalPath = '$path.json';
        final data = {
          'title': title,
          'reportDate': reportDate,
          'savingGoals': savingGoals.map((goal) => {
            'name': goal.name,
            'targetAmount': goal.targetAmount,
            'currentAmount': goal.currentAmount,
            'date': formatDate(goal.date),
            'targetDate': formatDate(goal.targetDate),
            'progress': '${((goal.currentAmount / goal.targetAmount) * 100).toStringAsFixed(1)}%',
          }).toList(),
        };
        final content = const JsonEncoder.withIndent('  ').convert(data);
        return File(finalPath)..writeAsString(content);

      case ExportFormat.csv:
        finalPath = '$path.csv';
        List<List<dynamic>> rows = [];
        rows.add([title]);
        rows.add([]);
        // Add header row with the specified fields
        rows.add(['Name', 'Target Amount', 'Current Amount', 'Creation Date', 'Target Date', 'Progress (%)']);
        for (var goal in savingGoals) {
          rows.add([
            goal.name,
            goal.targetAmount,
            goal.currentAmount,
            formatDate(goal.date),
            formatDate(goal.targetDate),
            '${((goal.currentAmount / goal.targetAmount) * 100).toStringAsFixed(1)}%',
          ]);
        }
        final content = csv.encode(rows);
        return File(finalPath)..writeAsString(content);

      case ExportFormat.pdf:
        finalPath = '$path.pdf';
        final pdf = pw.Document();
        pdf.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(32),
            header: (context) => pw.Header(
              level: 0,
              child: pw.Text(title, style: pw.Theme.of(context).header0),
            ),
            build: (context) => [
              pw.TableHelper.fromTextArray(
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headers: ['Name', 'Target', 'Current', 'Created', 'Target Date', 'Progress'],
                data: savingGoals.map((goal) => [
                  goal.name,
                  goal.targetAmount.toStringAsFixed(2),
                  goal.currentAmount.toStringAsFixed(2),
                  formatDate(goal.date),
                  formatDate(goal.targetDate),
                  '${((goal.currentAmount / goal.targetAmount) * 100).toStringAsFixed(1)}%',
                ]).toList(),
              ),
            ],
          ),
        );
        final bytes = await pdf.save();
        return File(finalPath)..writeAsBytes(bytes);
    }
  }
  // =======================================================================
  //  NEW METHOD FOR FINANCIAL SUMMARY
  // =======================================================================
  Future<void> exportFinancialSummary({
    required List<Transaction> allTransactions,
    required List<SavingGoal> savingGoals,
    required List<Transaction> debts,
    required int financialScore,
    required ExportFormat format,
  }) async {
    emit(ExportDataLoading());
    try {
      // Calculate all the required values
      final totalIncome = allTransactions
          .where((t) => t.category == TransactionCategory.income)
          .fold(0.0, (sum, item) => sum + item.amount);

      final totalExpenses = allTransactions
          .where((t) => t.category == TransactionCategory.expense)
          .fold(0.0, (sum, item) => sum + item.amount);

      final totalInSavings = savingGoals.fold(0.0, (sum, item) => sum + item.currentAmount);

      final totalDebtAmount = debts.fold(0.0, (sum, item) => sum + item.amount);

      // Total Liquid Assets = Income - Expenses
      final totalLiquidAssets = totalIncome - totalExpenses;

      // Global Tendency for all transactions
      final globalTendency = 0;/*calculatePeriodTotalTransaction(
        transactions: allTransactions,
        period: 'monthly',
      );*/

      final summaryData = {
        'totalLiquidAssets': totalLiquidAssets,
        'globalTendency': globalTendency,
        'totalIncome': totalIncome,
        'totalExpenses': totalExpenses,
        'totalMoneyInSavings': totalInSavings,
        'totalDebtAmount': totalDebtAmount,
        'financialScore': financialScore,
      };

      final file = await _createFinancialSummaryFile(
        summaryData: summaryData,
        format: format,
      );

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Here is your financial summary report.',
      );

      emit(ExportDataSuccess(file.path));
    } catch (e) {
      emit(ExportDataFailure(e.toString()));
    }
  }

  Future<File> _createFinancialSummaryFile({
    required Map<String, dynamic> summaryData,
    required ExportFormat format,
  }) async {
    final directory = await getApplicationDocumentsDirectory();
    final reportDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final fileName = 'FinancialSummary_Report_$reportDate';
    final path = '${directory.path}/$fileName';
    String finalPath;

    const String title = 'Global Financial Summary';

    switch (format) {
      case ExportFormat.json:
        finalPath = '$path.json';
        final data = {
          'title': title,
          'reportDate': reportDate,
          'summary': {
            'totalLiquidAssets': summaryData['totalLiquidAssets'],
            'globalTendency': '${(summaryData['globalTendency'] as double).toStringAsFixed(2)}%',
            'totalIncome': summaryData['totalIncome'],
            'totalExpenses': summaryData['totalExpenses'],
            'totalMoneyInSavings': summaryData['totalMoneyInSavings'],
            'totalDebtAmount': summaryData['totalDebtAmount'],
            'financialScore': summaryData['financialScore'],
          }
        };
        final content = const JsonEncoder.withIndent('  ').convert(data);
        return File(finalPath)..writeAsString(content);

      case ExportFormat.csv:
        finalPath = '$path.csv';
        List<List<dynamic>> rows = [];
        rows.add([title]);
        rows.add(['Report Date', reportDate]);
        rows.add([]);
        rows.add(['Metric', 'Value']);
        rows.add(['Total Liquid Assets', summaryData['totalLiquidAssets']]);
        rows.add(['Global Monthly Tendency', '${(summaryData['globalTendency'] as double).toStringAsFixed(2)}%']);
        rows.add(['Total Income', summaryData['totalIncome']]);
        rows.add(['Total Expenses', summaryData['totalExpenses']]);
        rows.add(['Total Money in Saving Accounts', summaryData['totalMoneyInSavings']]);
        rows.add(['Total Debt Amount', summaryData['totalDebtAmount']]);
        rows.add(['Financial Score', summaryData['financialScore']]);
        final content = csv.encode(rows);
        return File(finalPath)..writeAsString(content);

      case ExportFormat.pdf:
        finalPath = '$path.pdf';
        final pdf = pw.Document();
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(40),
            build: (context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Header(
                    level: 0,
                    child: pw.Text(title, style: pw.Theme.of(context).header0),
                  ),
                  pw.Text('Report Date: $reportDate', style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
                  pw.Divider(height: 30),
                  _buildSummaryRow('Total Liquid Assets:', (summaryData['totalLiquidAssets'] as double).toStringAsFixed(2), context),
                  _buildSummaryRow('Global Monthly Tendency:', '${(summaryData['globalTendency'] as double).toStringAsFixed(2)}%', context),
                  _buildSummaryRow('Total Income:', (summaryData['totalIncome'] as double).toStringAsFixed(2), context),
                  _buildSummaryRow('Total Expenses:', (summaryData['totalExpenses'] as double).toStringAsFixed(2), context),
                  _buildSummaryRow('Total in Saving Accounts:', (summaryData['totalMoneyInSavings'] as double).toStringAsFixed(2), context),
                  _buildSummaryRow('Total Debt Amount:', (summaryData['totalDebtAmount'] as double).toStringAsFixed(2), context),
                  pw.Divider(height: 30),
                  _buildSummaryRow('Financial Score:', summaryData['financialScore'].toString(), context, isScore: true),
                ],
              );
            },
          ),
        );
        final bytes = await pdf.save();
        return File(finalPath)..writeAsBytes(bytes);
    }
  }

  // Helper for building PDF rows
  pw.Widget _buildSummaryRow(String title, String value, pw.Context context, {bool isScore = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(title, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.Text(value, style: pw.TextStyle(fontSize: isScore ? 18 : 14, fontWeight: isScore ? pw.FontWeight.bold : pw.FontWeight.normal)),
        ],
      ),
    );
  }
}


// Helper extension to capitalize the first letter of a string.
extension StringCapitalize on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}