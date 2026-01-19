import 'package:dartz/dartz.dart';
import 'package:myapp/core/errors/exceptions.dart';
import 'package:myapp/core/utils/typedef.dart';
import 'package:myapp/features/saving_goal/data/datasources/saving_goal_remote_data_source.dart';
import 'package:myapp/features/saving_goal/domain/entities/saving_goal.dart';
import 'package:myapp/features/saving_goal/domain/repositories/saving_goal_repository.dart';

import '../../../../core/errors/firebase_failure.dart';
import '../models/saving_goal_model.dart';

class SavingGoalRepositoryImpl implements SavingGoalRepository {
  final SavingGoalRemoteDataSource _remoteDataSource;

  SavingGoalRepositoryImpl(this._remoteDataSource);

  @override
  ResultVoid addSavingGoal(SavingGoal savingGoal) async {
    try {
      await _remoteDataSource.addSavingGoal(savingGoal as SavingGoalModel);
      return const Right(null);
    } on FirebaseExceptions catch (e) {
      return Left(
        FirebaseFailure(message: e.message, statusCode: e.statusCode),
      );
    }
  }

  @override
  ResultVoid deleteSavingGoal(String savingGoalId) async {
    try {
      await _remoteDataSource.deleteSavingGoal(savingGoalId);
      return const Right(null);
    } on FirebaseExceptions catch (e) {
      return Left(
        FirebaseFailure(message: e.message, statusCode: e.statusCode),
      );
    }
  }

  @override
  ResultFuture<List<SavingGoal>> getSavingGoals(String userId) async {
    try {
      final result = await _remoteDataSource.getSavingGoals(userId);
      return Right(result);
    } on FirebaseExceptions catch (e) {
      return Left(
        FirebaseFailure(message: e.message, statusCode: e.statusCode),
      );
    }
  }

  @override
  ResultVoid updateSavingGoal(SavingGoal savingGoal) async {
    try {
      await _remoteDataSource.updateSavingGoal(savingGoal as SavingGoalModel);
      return const Right(null);
    } on FirebaseExceptions catch (e) {
      return Left(
        FirebaseFailure(message: e.message, statusCode: e.statusCode),
      );
    }
  }
}
