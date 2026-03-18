String formatNumber(num number) {
  if (number < 1000) return number.toString();

  final units = ['K', 'M', 'B', 'T'];
  int unitIndex = -1;

  while (number >= 1000 && unitIndex < units.length - 1) {
    number /= 1000;
    unitIndex++;
  }

  return number % 1 == 0
      ? '${number.toInt()}${units[unitIndex]}'
      : '${number.toStringAsFixed(1)}${units[unitIndex]}';
}