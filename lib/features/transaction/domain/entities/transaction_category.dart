enum TransactionCategory {
  income,
  debt,
  transfert,
  expense;

  static TransactionCategory fromString(String type) {
    return TransactionCategory.values.firstWhere((e) => e.name == type);
  }
}
