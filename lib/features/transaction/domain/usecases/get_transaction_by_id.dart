import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/core/utils/typedef.dart';
import 'package:myapp/features/transaction/domain/entities/transaction.dart';
import 'package:myapp/features/transaction/domain/repositories/transaction_repository.dart';

class GetTransactionById extends UseCaseWithParam<Transaction, String> {
  final TransactionRepository _repository;

  GetTransactionById(this._repository);

  @override
  ResultFuture<Transaction> call(String params) {
    return _repository.getTransactionById(params);
  }
}
