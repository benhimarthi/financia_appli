import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/core/utils/typedef.dart';
import 'package:myapp/features/auth/data/models/user_model.dart';
import 'package:myapp/features/auth/domain/repositories/auth_repository.dart';

class GetUserById extends UseCaseWithParam<UserModel, String>{
  final AuthRepository _repository;

  GetUserById(this._repository);

  @override
  ResultFuture<UserModel> call(String params) {
    return _repository.getUserById(params);
  }
}