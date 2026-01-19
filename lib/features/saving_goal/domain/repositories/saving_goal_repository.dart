import 'package:myapp/core/utils/typedef.dart';
import 'package:myapp/features/saving_goal/domain/entities/saving_goal.dart';

abstract class SavingGoalRepository {
  ResultFuture<List<SavingGoal>> getSavingGoals(String userId);
  ResultVoid addSavingGoal(SavingGoal savingGoal);
  ResultVoid updateSavingGoal(SavingGoal savingGoal);
  ResultVoid deleteSavingGoal(String savingGoalId);
}
