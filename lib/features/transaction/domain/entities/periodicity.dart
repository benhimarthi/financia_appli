enum Periodicity {
  daily,
  weekly,
  monthly,
  yearly,
  none;

  static Periodicity fromString(String value) {
    return Periodicity.values.firstWhere((x) => x.name == value);
  }
}
