part of 'saving_goal_cubit.dart';

abstract class SavingGoalState extends Equatable {
  const SavingGoalState();

  @override
  List<Object> get props => [];
}

class SavingGoalInitial extends SavingGoalState {}

class SavingGoalLoading extends SavingGoalState {}

class SavingGoalLoaded extends SavingGoalState {
  final List<SavingGoal> savingGoals;

  const SavingGoalLoaded(this.savingGoals);

  @override
  List<Object> get props => [savingGoals];
}

class SavingGoalError extends SavingGoalState {
  final String message;

  const SavingGoalError(this.message);

  @override
  List<Object> get props => [message];
}
