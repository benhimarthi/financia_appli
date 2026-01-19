import 'package:myapp/features/saving_goal/data/models/saving_goal_model.dart';

abstract class SavingGoalRemoteDataSource {
  Future<List<SavingGoalModel>> getSavingGoals(String userId);
  Future<void> addSavingGoal(SavingGoalModel savingGoal);
  Future<void> updateSavingGoal(SavingGoalModel savingGoal);
  Future<void> deleteSavingGoal(String savingGoalId);
}
