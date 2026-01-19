import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/core/utils/typedef.dart';
import 'package:myapp/features/auth/domain/repositories/auth_repository.dart';

class DeleteUser extends UseCaseWithParam<void, String> {
  const DeleteUser(this._repository);

  final AuthRepository _repository;

  @override
  ResultVoid call(String params) => _repository.deleteUser(params);
}
