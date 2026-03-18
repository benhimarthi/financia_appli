import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/core/utils/typedef.dart';

import '../repositories/auth_repository.dart';

class ChangeEmail extends UseCaseWithParam<void, ChangeEmailParams> {
  const ChangeEmail(this._repository);

  final AuthRepository _repository;

  @override
  ResultVoid call(ChangeEmailParams params) {
    return _repository.changeEmail(newEmail: params.newEmail, password: params.password);
  }
}

class ChangeEmailParams{
  final String newEmail;
  final String password;
  ChangeEmailParams(this.newEmail, this.password);
}