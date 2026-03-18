import 'package:myapp/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signUp({
    required UserModel userMd,
    required String password,
  });

  Future<UserModel> signIn({required String email, required String password});
  Future<UserModel> getUserById(String id);
  Future<void> signOut();

  Future<void> forgotPassword(String email);

  Future<void> deleteUser(String id);

  Future<UserModel> updateUser(UserModel updates);
  Future<void> changeEmail({
    required String newEmail,
    required String password,
  });
}
