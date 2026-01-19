import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/core/utils/typedef.dart';
import 'package:myapp/features/transaction/domain/repositories/transaction_repository.dart';

class DeleteTransaction extends UseCaseWithParam<void, String> {
  final TransactionRepository _repository;

  DeleteTransaction(this._repository);

  @override
  ResultVoid call(String params) {
    return _repository.deleteTransaction(params);
  }
}
