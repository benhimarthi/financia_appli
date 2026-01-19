import 'package:myapp/core/utils/typedef.dart';
import 'package:myapp/features/auth/data/models/user_model.dart';
import 'package:myapp/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  ResultFuture<User> signUp({
    required UserModel userMd,
    required String password,
  });

  ResultFuture<User> signIn({required String email, required String password});

  ResultFuture<User?> isLoggedIn();

  ResultVoid deleteUser(String id);

  ResultVoid forgotPassword(String email);

  ResultVoid signOut();

  ResultFuture<User> updateUser(UserModel params);
}
