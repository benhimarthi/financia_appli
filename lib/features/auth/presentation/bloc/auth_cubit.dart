import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:myapp/features/auth/data/models/user_model.dart';
import 'package:myapp/features/auth/domain/entities/user.dart';
import 'package:myapp/features/auth/domain/usecases/change_email.dart';
import 'package:myapp/features/auth/domain/usecases/delete_user.dart';
import 'package:myapp/features/auth/domain/usecases/forgot_password.dart';
import 'package:myapp/features/auth/domain/usecases/get_user_by_id.dart';
import 'package:myapp/features/auth/domain/usecases/is_logged_in.dart';
import 'package:myapp/features/auth/domain/usecases/sign_in.dart';
import 'package:myapp/features/auth/domain/usecases/sign_out.dart';
import 'package:myapp/features/auth/domain/usecases/sign_up.dart';
import 'package:myapp/features/auth/domain/usecases/update_user.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required SignIn signIn,
    required SignUp signUp,
    required ForgotPassword forgotPassword,
    required IsLoggedIn isLoggedIn,
    required SignOut signOut,
    required UpdateUser updateUser,
    required DeleteUser deleteUser,
    required ChangeEmail changeEmail,
    required GetUserById getUserById,
  }) : _signIn = signIn,
       _signUp = signUp,
       _forgotPassword = forgotPassword,
       _isLoggedIn = isLoggedIn,
       _signOut = signOut,
       _updateUser = updateUser,
       _deleteUser = deleteUser,
        _changeEmail = changeEmail,
  _getUserById = getUserById,
       super(const AuthInitial());

  final SignIn _signIn;
  final SignUp _signUp;
  final ForgotPassword _forgotPassword;
  final IsLoggedIn _isLoggedIn;
  final SignOut _signOut;
  final UpdateUser _updateUser;
  final DeleteUser _deleteUser;
  final ChangeEmail _changeEmail;
  final GetUserById _getUserById;

  Future<void> signIn({required String email, required String password}) async {
    emit(const AuthLoading());
    final result = await _signIn(
      SignInParams(email: email, password: password),
    );
    result.fold(
      (failure) => emit(AuthError(message: failure.errorMessage)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  Future<void> signUp({
    required UserModel userMd,
    required String password,
  }) async {
    emit(const AuthLoading());
    final result = await _signUp(
      SignUpParams(user: userMd, password: password),
    );
    result.fold(
      (failure) => emit(AuthError(message: failure.errorMessage)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  Future<void> forgotPassword(String email) async {
    emit(const AuthLoading());
    final result = await _forgotPassword(email);
    result.fold(
      (failure) => emit(AuthError(message: failure.errorMessage)),
      (_) => emit(const AuthInitial()),
    );
  }

  Future<void> isLoggedIn() async {
    emit(const AuthLoading());
    final result = await _isLoggedIn();
    result.fold((failure) => emit(const AuthInitial()), (user) {
      if (user != null) {
        emit(AuthSuccess(user: user));
      } else {
        emit(const AuthInitial());
      }
    });
  }

  Future<void> signOut() async {
    emit(const AuthLoading());
    final result = await _signOut();
    result.fold(
      (failure) => emit(AuthError(message: failure.errorMessage)),
      (_) => emit(const AuthInitial()),
    );
  }

  Future<void> updateUser(UserModel updates) async {
    emit(const AuthLoading());
    final result = await _updateUser(updates);
    result.fold(
      (failure) => emit(AuthError(message: failure.errorMessage)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  Future<void> deleteUser(String id) async {
    emit(const AuthLoading());
    final result = await _deleteUser(id);
    result.fold(
      (failure) => emit(AuthError(message: failure.errorMessage)),
      (_) => emit(const AuthInitial()),
    );
  }

  Future<void> changeEmail(String newEmail, String password) async {
    emit(const AuthLoading());
    final result = await _changeEmail(ChangeEmailParams(newEmail, password));
    result.fold(
      (failure) => emit(AuthError(message: failure.errorMessage)),
      (_) => emit(const EmailChangedSuccessfully()),
    );
  }

  Future<void> getUserById(String id)async{
    emit(const AuthLoading());
    final result = await _getUserById(id);
    result.fold(
      (failure) => emit(AuthError(message: failure.errorMessage)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  Future<void> emitRandomELement(Map<String, dynamic> datas) async {
    emit(const AuthInitial());
    emit(EmitRandomELement(elements: datas));
  }
}
