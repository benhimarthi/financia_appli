import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/core/utils/typedef.dart';
import 'package:myapp/features/saving_goal/domain/entities/saving_goal.dart';
import 'package:myapp/features/saving_goal/domain/repositories/saving_goal_repository.dart';

class GetSavingGoals implements UseCaseWithParam<List<SavingGoal>, String> {
  final SavingGoalRepository _repository;

  GetSavingGoals(this._repository);

  @override
  ResultFuture<List<SavingGoal>> call(String params) {
    return _repository.getSavingGoals(params);
  }
}
