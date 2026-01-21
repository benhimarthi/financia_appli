import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/features/saving_goal/domain/entities/saving_goal.dart';

class SavingGoalModel extends SavingGoal {
  const SavingGoalModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.targetAmount,
    required super.currentAmount,
    required super.targetDate,
    required super.date,
  });

  factory SavingGoalModel.fromMap(Map<String, dynamic> map) {
    return SavingGoalModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      name: map['name'] as String,
      targetAmount: (map['targetAmount'] as num).toDouble(),
      currentAmount: (map['currentAmount'] as num).toDouble(),
      targetDate: (map['targetDate'] as Timestamp).toDate(),
      date: (map['date'] as Timestamp).toDate(),
    );
  }

  factory SavingGoalModel.fromSavingGoal(SavingGoal savingGoal) {
    return SavingGoalModel(
      id: savingGoal.id,
      userId: savingGoal.userId,
      name: savingGoal.name,
      targetAmount: savingGoal.targetAmount,
      currentAmount: savingGoal.currentAmount,
      targetDate: savingGoal.targetDate,
      date: savingGoal.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'targetDate': targetDate,
      'date': date,
    };
  }

  SavingGoalModel copyWith({
    String? id,
    String? userId,
    String? name,
    double? targetAmount,
    double? currentAmount,
    DateTime? targetDate,
    DateTime? date,
  }) {
    return SavingGoalModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      targetDate: targetDate ?? this.targetDate,
      date: date ?? this.date,
    );
  }
}
