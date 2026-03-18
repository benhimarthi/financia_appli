import 'package:csv/csv.dart';

void testCsv() {
  final rows = [
    ['A', 'B'],
    [1, 2],
  ];

  final content = csv.encode(rows);
  print(content);
}