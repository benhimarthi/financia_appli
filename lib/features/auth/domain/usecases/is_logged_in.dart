import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/core/utils/typedef.dart';
import 'package:myapp/features/auth/domain/entities/user.dart';
import 'package:myapp/features/auth/domain/repositories/auth_repository.dart';

class IsLoggedIn extends UseCaseWithoutParam<User?> {
  const IsLoggedIn(this._repository);

  final AuthRepository _repository;

  @override
  ResultFuture<User?> call() => _repository.isLoggedIn();
}
