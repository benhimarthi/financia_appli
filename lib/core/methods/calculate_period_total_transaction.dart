import '../../features/transaction/domain/entities/transaction.dart';
import '../../features/transaction/domain/entities/transaction_category.dart';

class CalculatePeriodTransaction {
  static double calculateMonthTotalTransaction(
    List<Transaction> transactions,
    TransactionCategory category,
    int month,
    int year,
  ) {
    //print(transactions.length);
    //Filter the transactions by income and periodicity
    List<Transaction> incomeTransactions = transactions
        .where(
          (transaction) =>
              transaction.category == category &&
              transaction.date.month == month &&
              transaction.date.year == year,
        )
        .toList();
    return incomeTransactions.fold(
      0,
      (previousValue, element) => previousValue + element.amount,
    );
  }

  static double compareMonthTotalTransaction(
    List<Transaction> transations,
    TransactionCategory category,
    int fromMonth,
    int fromYear,
    int toMonth,
    int toYear,
  ) {
    double fromMonthTotal = calculateMonthTotalTransaction(
      transations,
      category,
      fromMonth,
      fromYear,
    );
    double toMonthTotal = calculateMonthTotalTransaction(
      transations,
      category,
      toMonth,
      toYear,
    );
    return toMonthTotal - fromMonthTotal;
  }

  static double calculatePeriodTransactionTendancy(
    List<Transaction> transactions,
    TransactionCategory category,
    int fromMonth,
    int fromYear,
    int toMonth,
    int toYear,
  ) {
    double fromMonthTotal = compareMonthTotalTransaction(
      transactions,
      category,
      fromMonth,
      fromYear,
      toMonth,
      toYear,
    );
    double thisMonth = calculateMonthTotalTransaction(
      transactions,
      category,
      toMonth,
      toYear,
    );
    return (fromMonthTotal / thisMonth) * 100;
  }

  static double calculatePeriodTotalSavings(
    List<Transaction> transactions,
    int month,
    int year,
  ) {
    List<Transaction> incomeTransactions = transactions
        .where(
          (transaction) =>
              transaction.category == TransactionCategory.income &&
              transaction.date.month == month &&
              transaction.date.year == year,
        )
        .toList();
    List<Transaction> expenseTransactions = transactions
        .where(
          (x) =>
              x.category == TransactionCategory.income &&
              x.date.month == month &&
              x.date.year == year,
        )
        .toList();
    double incomeAmount = incomeTransactions.fold(
      0,
      (previousValue, element) => previousValue + element.amount,
    );
    double expenseAmount = expenseTransactions.fold(
      0,
      (previousValue, element) => previousValue + element.amount,
    );
    return incomeAmount - expenseAmount;
  }

  static double calculateTotalAvailableCash(
    List<Transaction> transactions,
    int month,
    int year,
  ) {
    //get the total savings for the current month
    double currentMonthTotalSavings = calculatePeriodTotalSavings(
      transactions,
      month,
      year,
    );
    int previousMonth = month - 1;
    int previousYear = year;
    if (previousMonth == 0) {
      previousMonth = 12;
      previousYear = year - 1;
    }
    // get the savings from the last month
    double lastMonthSavings = calculatePeriodTotalSavings(
      transactions,
      previousMonth,
      previousYear,
    );
    return currentMonthTotalSavings + lastMonthSavings;
  }
}
