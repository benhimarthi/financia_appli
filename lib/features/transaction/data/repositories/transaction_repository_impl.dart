import 'package:dartz/dartz.dart';
import 'package:myapp/core/errors/exceptions.dart';
import 'package:myapp/features/transaction/data/datasources/transaction_remote_data_source.dart';
import 'package:myapp/features/transaction/data/models/transaction_model.dart';
import 'package:myapp/features/transaction/domain/entities/transaction.dart';
import 'package:myapp/features/transaction/domain/repositories/transaction_repository.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/firebase_failure.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> addTransaction(Transaction transaction) async {
    try {
      final transactionModel = TransactionModel.fromTransaction(transaction);
      final result = await remoteDataSource.addTransaction(transactionModel);
      return Right(result);
    } on FirebaseExceptions catch (e) {
      return Left(FirebaseFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(String transactionId) async {
    try {
      final result = await remoteDataSource.deleteTransaction(transactionId);
      return Right(result);
    } on FirebaseExceptions catch (e) {
      return Left(FirebaseFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactions(String userId) async {
    try {
      final result = await remoteDataSource.getTransactions(userId);
      return Right(result);
    } on FirebaseExceptions catch (e) {
      return Left(FirebaseFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Transaction>> getTransactionById(
    String transactionId,
  ) async {
    try {
      final result = await remoteDataSource.getTransactionById(transactionId);
      return Right(result);
    } on FirebaseExceptions catch (e) {
      return Left(FirebaseFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateTransaction(
    Transaction transaction,
  ) async {
    try {
      final transactionModel = TransactionModel.fromTransaction(transaction);
      final result = await remoteDataSource.updateTransaction(transactionModel);
      return Right(result);
    } on FirebaseExceptions catch (e) {
      return Left(FirebaseFailure.fromException(e));
    }
  }
}
