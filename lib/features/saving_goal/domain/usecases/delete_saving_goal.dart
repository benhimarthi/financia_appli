import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/core/utils/typedef.dart';
import 'package:myapp/features/saving_goal/domain/repositories/saving_goal_repository.dart';

class DeleteSavingGoal implements UseCaseWithParam<void, String> {
  final SavingGoalRepository _repository;

  DeleteSavingGoal(this._repository);

  @override
  ResultVoid call(String params) {
    return _repository.deleteSavingGoal(params);
  }
}
