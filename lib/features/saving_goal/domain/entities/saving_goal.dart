import 'package:equatable/equatable.dart';

class SavingGoal extends Equatable {
  final String id;
  final String userId;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime targetDate;
  final DateTime date;

  const SavingGoal({
    required this.id,
    required this.userId,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    required this.date,
  });

  @override
  List<Object?> get props => [id, userId, name, targetAmount, currentAmount, targetDate, date];
}
