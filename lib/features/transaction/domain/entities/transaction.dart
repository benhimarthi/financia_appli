import 'package:equatable/equatable.dart';
import 'package:myapp/features/transaction/domain/entities/periodicity.dart';
import 'package:myapp/features/transaction/domain/entities/transaction_category.dart';

class Transaction extends Equatable {
  final String id;
  final String userId;
  final double amount;
  final TransactionCategory category;
  final DateTime date;
  final String description;
  final Periodicity periodicity;
  final String tag;
  final double? interestRate;
  final bool isPrevision;
  final bool isTransfer;
  final Map<String, dynamic>? transferDetails;

  const Transaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.category,
    required this.date,
    required this.description,
    required this.periodicity,
    required this.tag,
    required this.isPrevision,
    this.interestRate,
    this.isTransfer = false,
    this.transferDetails,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        amount,
        category,
        date,
        description,
        periodicity,
        tag,
        interestRate,
        isPrevision,
        isTransfer,
        transferDetails,
      ];
}
