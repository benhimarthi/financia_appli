import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/core/utils/typedef.dart';
import 'package:myapp/features/auth/data/models/user_model.dart';
import 'package:myapp/features/auth/domain/entities/user.dart';
import 'package:myapp/features/auth/domain/repositories/auth_repository.dart';

class SignUp extends UseCaseWithParam<User, SignUpParams> {
  const SignUp(this._repository);

  final AuthRepository _repository;

  @override
  ResultFuture<User> call(SignUpParams params) =>
      _repository.signUp(userMd: params.user, password: params.password);
}

class SignUpParams {
  const SignUpParams({required this.user, required this.password});
  final UserModel user;
  final String password;
}
