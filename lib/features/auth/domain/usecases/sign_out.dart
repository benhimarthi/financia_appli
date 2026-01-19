import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/core/utils/typedef.dart';
import 'package:myapp/features/auth/domain/repositories/auth_repository.dart';

class SignOut extends UseCaseWithoutParam<void> {
  const SignOut(this._repository);

  final AuthRepository _repository;

  @override
  ResultVoid call() => _repository.signOut();
}
