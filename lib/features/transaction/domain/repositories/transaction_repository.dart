import 'package:myapp/core/utils/typedef.dart';
import 'package:myapp/features/transaction/domain/entities/transaction.dart';

abstract class TransactionRepository {
  ResultFuture<List<Transaction>> getTransactions(String userId);
  ResultFuture<Transaction> getTransactionById(String id);
  ResultVoid addTransaction(Transaction transaction);
  ResultVoid updateTransaction(Transaction transaction);
  ResultVoid deleteTransaction(String id);
}
