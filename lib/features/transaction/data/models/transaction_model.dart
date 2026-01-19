import 'package:myapp/features/transaction/domain/entities/transaction.dart';
import 'package:myapp/features/transaction/domain/entities/transaction_category.dart';
import 'package:myapp/features/transaction/domain/entities/periodicity.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.userId,
    required super.amount,
    required super.category,
    required super.date,
    required super.description,
    required super.periodicity,
    required super.tag,
    required super.isPrevision,
    super.isTransfer,
    super.interestRate,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      userId: json['userId'],
      amount: (json['amount'] as num).toDouble(),
      category: TransactionCategory.values.firstWhere((e) => e.toString() == 'TransactionCategory.' + json['category']),
      date: DateTime.parse(json['date']),
      description: json['description'],
      periodicity: Periodicity.values.firstWhere((e) => e.toString() == 'Periodicity.' + json['periodicity']),
      tag: json['tag'],
      isPrevision: json['isPrevision'] ?? false,
      isTransfer: json['isTransfer'] ?? false,
      interestRate: (json['interestRate'] as num?)?.toDouble(),
    );
  }
  
  factory TransactionModel.fromTransaction(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      userId: transaction.userId,
      amount: transaction.amount,
      category: transaction.category,
      date: transaction.date,
      description: transaction.description,
      periodicity: transaction.periodicity,
      tag: transaction.tag,
      isPrevision: transaction.isPrevision,
      isTransfer: transaction.isTransfer,
      interestRate: transaction.interestRate,
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'id': id,
      'userId': userId,
      'amount': amount,
      'category': category.toString().split('.').last,
      'date': date.toIso8601String(),
      'description': description,
      'periodicity': periodicity.toString().split('.').last,
      'tag': tag,
      'isPrevision': isPrevision,
      'isTransfer': isTransfer,
      'interestRate': interestRate,
    };
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
