enum ExpenseTags {
  rent,
  groceries,
  transport,
  utilities,
  entertainment,
  health,
  education,
  other;

  static ExpenseTags fromString(String type) {
    return ExpenseTags.values.firstWhere((e) => e.name == type);
  }
}
