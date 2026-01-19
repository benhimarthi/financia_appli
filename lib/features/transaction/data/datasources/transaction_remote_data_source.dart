import 'package:myapp/features/transaction/data/models/transaction_model.dart';

abstract class TransactionRemoteDataSource {
  Future<void> addTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String transactionId);
  Future<List<TransactionModel>> getTransactions(String userId);
  Future<TransactionModel> getTransactionById(String transactionId);
  Future<void> updateTransaction(TransactionModel transaction);
}
