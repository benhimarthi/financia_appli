import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/core/utils/typedef.dart';
import 'package:myapp/features/transaction/domain/entities/transaction.dart';
import 'package:myapp/features/transaction/domain/repositories/transaction_repository.dart';

class AddTransaction extends UseCaseWithParam<void, Transaction> {
  final TransactionRepository _repository;

  AddTransaction(this._repository);

  @override
  ResultVoid call(Transaction params) {
    return _repository.addTransaction(params);
  }
}
