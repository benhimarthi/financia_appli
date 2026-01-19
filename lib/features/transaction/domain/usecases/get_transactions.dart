import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/core/utils/typedef.dart';
import 'package:myapp/features/transaction/domain/entities/transaction.dart';
import 'package:myapp/features/transaction/domain/repositories/transaction_repository.dart';

class GetTransactions extends UseCaseWithParam<List<Transaction>, String> {
  final TransactionRepository _repository;

  GetTransactions(this._repository);

  @override
  ResultFuture<List<Transaction>> call(String params) {
    return _repository.getTransactions(params);
  }
}
