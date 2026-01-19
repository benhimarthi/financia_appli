import 'package:equatable/equatable.dart';
import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/core/utils/typedef.dart';
import 'package:myapp/features/auth/domain/entities/user.dart';
import 'package:myapp/features/auth/domain/repositories/auth_repository.dart';

class SignIn extends UseCaseWithParam<User, SignInParams> {
  const SignIn(this._repository);

  final AuthRepository _repository;

  @override
  ResultFuture<User> call(SignInParams params) =>
      _repository.signIn(email: params.email, password: params.password);
}

class SignInParams extends Equatable {
  const SignInParams({required this.email, required this.password});

  const SignInParams.empty() : this(email: ' ', password: ' ');

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
