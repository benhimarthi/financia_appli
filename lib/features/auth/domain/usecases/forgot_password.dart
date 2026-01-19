import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/core/utils/typedef.dart';
import 'package:myapp/features/auth/domain/repositories/auth_repository.dart';

class ForgotPassword extends UseCaseWithParam<void, String> {
  const ForgotPassword(this._repository);

  final AuthRepository _repository;

  @override
  ResultVoid call(String params) => _repository.forgotPassword(params);
}
