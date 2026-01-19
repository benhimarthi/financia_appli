import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/core/utils/typedef.dart';
import 'package:myapp/features/auth/data/models/user_model.dart';
import 'package:myapp/features/auth/domain/entities/user.dart';
import 'package:myapp/features/auth/domain/repositories/auth_repository.dart';

class UpdateUser extends UseCaseWithParam<User, UserModel> {
  const UpdateUser(this._repository);

  final AuthRepository _repository;

  @override
  ResultFuture<User> call(UserModel params) => _repository.updateUser(params);
}
