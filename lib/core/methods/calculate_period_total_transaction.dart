import '../../features/transaction/domain/entities/transaction.dart';
import '../../features/transaction/domain/entities/transaction_category.dart';

class CalculatePeriodTransaction {
  static double calculateMonthTotalTransaction(
    List<Transaction> transactions,
    TransactionCategory category,
    int month,
    int year,
      { bool isPrevision = false}
  ) {
    //Filter the transactions by income and periodicity
    List<Transaction> incomeTransactions = transactions
    .where((x) => x.isPrevision == isPrevision).toList()
        .where(
          (transaction) =>
              transaction.category == category &&
              transaction.date.month == month &&
              transaction.date.year == year,
        )
        .toList();
    double totTransactions = incomeTransactions.fold(0, (previousValue, element) {
      return previousValue + element.amount;
    });
    return totTransactions;
  }

  static double calculateMonthTotalTransferFromCash(
    List<Transaction> transactions,
    int month,
    int year,
  ) {
    List<Transaction> transfert = transactions
        .where(
          (transaction) =>
              transaction.category == TransactionCategory.transfert &&
              transaction.transferDetails!.values.first == "Cash Available" &&
              transaction.date.month == month &&
              transaction.date.year == year,
        )
        .toList();
    return transfert.fold(0, (previousValue, element) {
      return previousValue + element.amount;
    });
  }

  static double calculateMonthTotalTransferToCash(
      List<Transaction> transactions,
      int month,
      int year,
      ){
    List<Transaction> transfer = transactions
        .where(
          (transaction) =>
      transaction.category == TransactionCategory.transfert &&
          transaction.transferDetails!.values.last == "Cash Available" &&
          transaction.date.month == month &&
          transaction.date.year == year,
    )
        .toList();
    return transfer.fold(0, (previousValue, element) {
      return previousValue + element.amount;
    });
  }

  static double compareMonthTotalTransaction(
    List<Transaction> transactions,
    TransactionCategory category,
    int fromMonth,
    int fromYear,
    int toMonth,
    int toYear,
  ) {
    double fromMonthTotal = calculateMonthTotalTransaction(
      transactions,
      category,
      fromMonth,
      fromYear,
    );
    double toMonthTotal = calculateMonthTotalTransaction(
      transactions,
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
    // Get the total for the starting period ("from")
    double previousMonthTotal = calculateMonthTotalTransaction(
      transactions,
      category,
      toMonth,
      toYear,
    );
    // Get the total for the ending period ("to")
    double currentMonthTotal = calculateMonthTotalTransaction(
      transactions,
      category,
      fromMonth,
      fromYear,
    );
    // Avoid division by zero if the starting total was 0
    if (previousMonthTotal == 0) {
      // If the new total is also 0, there's no change.
      // If the new total is positive, you could return 100.0 (representing 100% increase)
      // or simply return 0.0 to indicate the calculation is not possible.
      // Returning 0.0 is often safer.
      return 0.0;
    }

    // Calculate the difference
    double difference = currentMonthTotal - previousMonthTotal;

    // Calculate the percentage change
    double res = difference / previousMonthTotal;
    // Calculate the percentage change
    return res;
  }
  static double calculateMonthEvolution(List<Transaction> transactions,
      TransactionCategory category,
      int month,
      int year,)
  {
    int previousMonth = month - 1 == 0 ? 12 : month - 1;
    int previousYear = year;
    if(previousMonth == 12) {
      previousYear -= 1;
    }
    double res = calculatePeriodTransactionTendancy(transactions, category, month, year, previousMonth, previousYear,);
    return res;
  }

  static double calculatePeriodTotalSavings(
    List<Transaction> transactions,
    int month,
    int year,
  ) {
    double incomeTransactions = calculateMonthTotalTransaction(transactions, TransactionCategory.income, month, year,);
    double expenseTransactions = calculateMonthTotalTransaction(transactions, TransactionCategory.expense, month, year,);
    double debts = calculateMonthTotalTransaction(transactions, TransactionCategory.debt, month, year,);
    double transferFromCash = calculateMonthTotalTransferFromCash(
      transactions,
      month,
      year,
    );
    double transferToCash = calculateMonthTotalTransferToCash(
      transactions,
      month,
      year,
    );
    return incomeTransactions + debts + transferToCash - transferFromCash - expenseTransactions;
  }

  static double calculatePeriodAvailableIncome(
      List<Transaction> transactions,
      int fromMonth,
      int fromYear,
      int toMonth,
      int toYear,
      ) {
    //check if out of bound
    var sortedTransactions = transactions..sort((a, b) => a.date.compareTo(b.date));
    var oldestTransaction = sortedTransactions.first;
    if(toYear < oldestTransaction.date.year)return calculateTotalAvailableCash(transactions, fromMonth, fromYear);
    return 0;
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

  static double calculateRemainingAmountFromDept(Transaction debt, List<Transaction> sentToDept){
    //Transfer transactions to the debt.
    if(debt.category!=TransactionCategory.debt)return 0;
    var transactionToDept = sentToDept.where((x)=>x.category == TransactionCategory.transfert).toList().
    where((x) => x.transferDetails!.values.last == debt.id).toList();
    double totalTransaction = transactionToDept.fold(0,
            (previousValue, element) {
              return previousValue + element.amount;
    });
    double debtAmount = debt.amount + (debt.amount * debt.interestRate!);
    return debtAmount - totalTransaction;
  }

  static double calculateTotalDebtAmount(Transaction debt){
    if(debt.category!=TransactionCategory.debt)return 0;
    double debtAmount = debt.amount + (debt.amount * debt.interestRate!);
    return debtAmount;
  }
}
