import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:myapp/features/saving_goal/domain/entities/saving_goal.dart';
import 'package:myapp/features/saving_goal/domain/usecases/add_saving_goal.dart';
import 'package:myapp/features/saving_goal/domain/usecases/delete_saving_goal.dart';
import 'package:myapp/features/saving_goal/domain/usecases/get_saving_goals.dart';
import 'package:myapp/features/saving_goal/domain/usecases/update_saving_goal.dart';

part 'saving_goal_state.dart';

class SavingGoalCubit extends Cubit<SavingGoalState> {
  final GetSavingGoals _getSavingGoals;
  final AddSavingGoal _addSavingGoal;
  final UpdateSavingGoal _updateSavingGoal;
  final DeleteSavingGoal _deleteSavingGoal;

  SavingGoalCubit({
    required GetSavingGoals getSavingGoals,
    required AddSavingGoal addSavingGoal,
    required UpdateSavingGoal updateSavingGoal,
    required DeleteSavingGoal deleteSavingGoal,
  })  : _getSavingGoals = getSavingGoals,
        _addSavingGoal = addSavingGoal,
        _updateSavingGoal = updateSavingGoal,
        _deleteSavingGoal = deleteSavingGoal,
        super(SavingGoalInitial());

  Future<void> getSavingGoals(String userId) async {
    emit(SavingGoalLoading());
    final result = await _getSavingGoals(userId);
    result.fold(
      (failure) => emit(SavingGoalError(failure.errorMessage)),
      (savingGoals) => emit(SavingGoalLoaded(savingGoals)),
    );
  }

  Future<void> addSavingGoal(SavingGoal savingGoal) async {
    emit(SavingGoalLoading());
    final result = await _addSavingGoal(savingGoal);
    result.fold(
      (failure) => emit(SavingGoalError(failure.errorMessage)),
      (_) => getSavingGoals(savingGoal.userId),
    );
  }

  Future<void> updateSavingGoal(SavingGoal savingGoal) async {
    emit(SavingGoalLoading());
    final result = await _updateSavingGoal(savingGoal);
    result.fold(
      (failure) => emit(SavingGoalError(failure.errorMessage)),
      (_) => getSavingGoals(savingGoal.userId),
    );
  }

  Future<void> deleteSavingGoal(SavingGoal savingGoal) async {
    emit(SavingGoalLoading());
    final result = await _deleteSavingGoal(savingGoal.id);
    result.fold(
      (failure) => emit(SavingGoalError(failure.errorMessage)),
      (_) => getSavingGoals(savingGoal.userId),
    );
  }
}
