import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/transaction/domain/usecases/add_transaction.dart';
import 'package:myapp/features/transaction/domain/usecases/delete_transaction.dart';
import 'package:myapp/features/transaction/domain/usecases/get_transaction_by_id.dart';
import 'package:myapp/features/transaction/domain/usecases/get_transactions.dart';
import 'package:myapp/features/transaction/domain/usecases/update_transaction.dart';
import 'package:myapp/features/transaction/presentation/bloc/transaction_state.dart';

import '../../domain/entities/transaction.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final AddTransaction addTransactionUseCase;
  final DeleteTransaction deleteTransactionUseCase;
  final GetTransactionById getTransactionByIdUseCase;
  final GetTransactions getTransactionsUseCase;
  final UpdateTransaction updateTransactionUseCase;

  String? _userId;

  TransactionCubit({
    required this.addTransactionUseCase,
    required this.deleteTransactionUseCase,
    required this.getTransactionByIdUseCase,
    required this.getTransactionsUseCase,
    required this.updateTransactionUseCase,
  }) : super(TransactionInitial());

  void setUserId(String userId) {
    _userId = userId;
  }

  Future<void> addTransaction(Transaction transaction) async {
    emit(TransactionLoading());
    final failureOrVoid = await addTransactionUseCase(transaction);
    failureOrVoid.fold(
      (failure) => emit(TransactionError(failure.errorMessage)),
      (_) => getTransactions(),
    );
  }

  Future<void> deleteTransaction(String transactionId) async {
    emit(TransactionLoading());
    final failureOrVoid = await deleteTransactionUseCase(transactionId);
    failureOrVoid.fold(
      (failure) => emit(TransactionError(failure.errorMessage)),
      (_) => getTransactions(),
    );
  }

  Future<void> getTransactionById(String transactionId) async {
    emit(TransactionLoading());
    final failureOrTransaction = await getTransactionByIdUseCase(transactionId);
    failureOrTransaction.fold(
      (failure) => emit(TransactionError(failure.errorMessage)),
      (transaction) => emit(TransactionLoaded([transaction])),
    );
  }

  Future<void> getTransactions() async {
    emit(TransactionLoading());
    if (_userId == null) {
      emit(TransactionError('User ID not set'));
      return;
    }
    final failureOrTransactions = await getTransactionsUseCase(_userId!);
    failureOrTransactions.fold(
      (failure) => emit(TransactionError(failure.errorMessage)),
      (transactions) => emit(TransactionLoaded(transactions)),
    );
  }

  Future<void> updateTransaction(Transaction transaction) async {
    emit(TransactionLoading());
    final failureOrVoid = await updateTransactionUseCase(transaction);
    failureOrVoid.fold(
      (failure) => emit(TransactionError(failure.errorMessage)),
      (_) => getTransactions(),
    );
  }

  Future<void> emitRandomELement(Map<String, dynamic> data) async {
    emit(TransactionLoading());
    emit(TransactionRandomEmit(data));
  }
}
