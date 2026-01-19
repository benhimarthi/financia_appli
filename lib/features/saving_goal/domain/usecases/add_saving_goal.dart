import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/core/utils/typedef.dart';
import 'package:myapp/features/saving_goal/domain/entities/saving_goal.dart';
import 'package:myapp/features/saving_goal/domain/repositories/saving_goal_repository.dart';

class AddSavingGoal implements UseCaseWithParam<void, SavingGoal> {
  final SavingGoalRepository _repository;

  AddSavingGoal(this._repository);

  @override
  ResultVoid call(SavingGoal params) {
    return _repository.addSavingGoal(params);
  }
}
