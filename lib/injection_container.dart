import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:myapp/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:myapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:myapp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:myapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:myapp/features/auth/domain/usecases/delete_user.dart';
import 'package:myapp/features/auth/domain/usecases/forgot_password.dart';
import 'package:myapp/features/auth/domain/usecases/is_logged_in.dart';
import 'package:myapp/features/auth/domain/usecases/sign_in.dart';
import 'package:myapp/features/auth/domain/usecases/sign_out.dart';
import 'package:myapp/features/auth/domain/usecases/sign_up.dart';
import 'package:myapp/features/auth/domain/usecases/update_user.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:myapp/features/saving_goal/data/datasources/saving_goal_remote_data_source.dart';
import 'package:myapp/features/saving_goal/data/datasources/saving_goal_remote_data_source_impl.dart';
import 'package:myapp/features/saving_goal/data/repositories/saving_goal_repository_impl.dart';
import 'package:myapp/features/saving_goal/domain/repositories/saving_goal_repository.dart';
import 'package:myapp/features/saving_goal/domain/usecases/add_saving_goal.dart';
import 'package:myapp/features/saving_goal/domain/usecases/delete_saving_goal.dart';
import 'package:myapp/features/saving_goal/domain/usecases/get_saving_goals.dart';
import 'package:myapp/features/saving_goal/domain/usecases/update_saving_goal.dart';
import 'package:myapp/features/saving_goal/presentation/cubit/saving_goal_cubit.dart';
import 'package:myapp/features/transaction/data/datasources/transaction_remote_data_source.dart';
import 'package:myapp/features/transaction/data/datasources/transaction_remote_data_source_impl.dart';
import 'package:myapp/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:myapp/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:myapp/features/transaction/domain/usecases/add_transaction.dart';
import 'package:myapp/features/transaction/domain/usecases/delete_transaction.dart';
import 'package:myapp/features/transaction/domain/usecases/get_transaction_by_id.dart';
import 'package:myapp/features/transaction/domain/usecases/get_transactions.dart';
import 'package:myapp/features/transaction/domain/usecases/update_transaction.dart';
import 'package:myapp/features/transaction/presentation/bloc/transaction_cubit.dart';

import 'features/auth/data/datasources/auth_remote_data_source_impl.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory(
    () => AuthCubit(
      signIn: sl(),
      signUp: sl(),
      forgotPassword: sl(),
      isLoggedIn: sl(),
      signOut: sl(),
      updateUser: sl(),
      deleteUser: sl(),
    ),
  );
  sl.registerFactory(
    () => TransactionCubit(
      addTransactionUseCase: sl(),
      deleteTransactionUseCase: sl(),
      getTransactionByIdUseCase: sl(),
      getTransactionsUseCase: sl(),
      updateTransactionUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => SavingGoalCubit(
      getSavingGoals: sl(),
      addSavingGoal: sl(),
      updateSavingGoal: sl(),
      deleteSavingGoal: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => ForgotPassword(sl()));
  sl.registerLazySingleton(() => IsLoggedIn(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => UpdateUser(sl()));
  sl.registerLazySingleton(() => DeleteUser(sl()));

  sl.registerLazySingleton(() => AddTransaction(sl()));
  sl.registerLazySingleton(() => DeleteTransaction(sl()));
  sl.registerLazySingleton(() => GetTransactionById(sl()));
  sl.registerLazySingleton(() => GetTransactions(sl()));
  sl.registerLazySingleton(() => UpdateTransaction(sl()));

  sl.registerLazySingleton(() => GetSavingGoals(sl()));
  sl.registerLazySingleton(() => AddSavingGoal(sl()));
  sl.registerLazySingleton(() => UpdateSavingGoal(sl()));
  sl.registerLazySingleton(() => DeleteSavingGoal(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<SavingGoalRepository>(
    () => SavingGoalRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(auth: sl(), firestore: sl()),
  );
  sl.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<SavingGoalRemoteDataSource>(
    () => SavingGoalRemoteDataSourceImpl(sl()),
  );

  //External Datas
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => AuthLocalDataSource());
}
