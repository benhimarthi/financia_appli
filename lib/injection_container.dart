import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:get_it/get_it.dart';
import 'package:myapp/features/ai_assistant/domain/usecases/start_chat_session.dart';
import 'package:myapp/features/ai_assistant/presentation/cubit/ai_assistant_cubit.dart';
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
import 'package:myapp/features/help_article/domain/usecase/get_help_articles.dart';
import 'package:myapp/features/help_article/presentation/cubit/help_article_cubit.dart';
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

import 'features/ai_assistant/data/datasources/ai_assistant_remote_data_source.dart';
import 'features/ai_assistant/data/datasources/ai_assistant_remote_data_source_impl.dart';
import 'features/ai_assistant/data/repositories/ai_assistant_repository_impl.dart';
import 'features/ai_assistant/domain/repositories/ai_assistant_repository.dart';
import 'features/ai_assistant/domain/usecases/clear_chat_session.dart';
import 'features/ai_assistant/domain/usecases/get_chat_history.dart';
import 'features/ai_assistant/domain/usecases/send_message.dart';
import 'features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'features/auth/domain/usecases/change_email.dart';
import 'features/auth/domain/usecases/get_user_by_id.dart';
import 'features/help_article/data/datasource/help_article_remote_data_source.dart';
import 'features/help_article/data/datasource/help_article_remote_data_source_impl.dart';
import 'features/help_article/data/repository/help_article_repository_impl.dart';
import 'features/help_article/domain/repository/help_article_repository.dart';
import 'features/help_article/domain/usecase/create_help_article.dart';
import 'features/help_article/domain/usecase/get_help_article_by_id.dart';
import 'features/settings/presentation/cubit/export_data_cubit.dart';
import 'features/settings/presentation/cubit/session_cubit.dart';

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
      changeEmail: sl(),
      getUserById: sl(),
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
  sl.registerFactory(
      ()=> HelpArticleCubit(
          getHelpArticles: sl(),
          getHelpArticleById: sl(),
        createHelpArticle: sl(),
      )
  );
  sl.registerFactory(() => ExportDataCubit());
  sl.registerFactory(()=> SessionCubit(sl(), sl()));
  sl.registerFactory(() => AIAssistantCubit(
      startChatSession: sl(),
      sendMessage: sl(),
      getChatHistory: sl(),
      clearChatSession: sl()
  ));

  // Use cases
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => ForgotPassword(sl()));
  sl.registerLazySingleton(() => IsLoggedIn(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => UpdateUser(sl()));
  sl.registerLazySingleton(() => DeleteUser(sl()));
  sl.registerLazySingleton(() => ChangeEmail(sl()));
  sl.registerLazySingleton(() => GetUserById(sl()));

  sl.registerLazySingleton(() => AddTransaction(sl()));
  sl.registerLazySingleton(() => DeleteTransaction(sl()));
  sl.registerLazySingleton(() => GetTransactionById(sl()));
  sl.registerLazySingleton(() => GetTransactions(sl()));
  sl.registerLazySingleton(() => UpdateTransaction(sl()));

  sl.registerLazySingleton(() => GetSavingGoals(sl()));
  sl.registerLazySingleton(() => AddSavingGoal(sl()));
  sl.registerLazySingleton(() => UpdateSavingGoal(sl()));
  sl.registerLazySingleton(() => DeleteSavingGoal(sl()));

  sl.registerLazySingleton(() => GetHelpArticles(sl()));
  sl.registerLazySingleton(() => GetHelpArticleById(sl()));
  sl.registerLazySingleton(() => CreateHelpArticle(sl()));
  
  sl.registerLazySingleton(() => StartChatSession(sl()));
  sl.registerLazySingleton(() => SendMessage(sl()));
  sl.registerLazySingleton(() => GetChatHistory(sl()));
  sl.registerLazySingleton(() => ClearChatSession(sl()));

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
  sl.registerLazySingleton<HelpArticleRepository>(()=> HelpArticleRepositoryImpl(sl()));
  sl.registerLazySingleton<AIAssistantRepository>(()=> AIAssistantRepositoryImpl(sl()));

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
  sl.registerLazySingleton<HelpArticleRemoteDataSource>(
    () => HelpArticleRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AIAssistantRemoteDataSource>(
    () => AIAssistantRemoteDataSourceImpl(
      firebaseAI: sl(),
      firestore: sl(),
      auth: sl(),
    ),
  );

  //External Data
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(()=> FirebaseVertexAI.instance);
  sl.registerLazySingleton(() => AuthLocalDataSource());
}
