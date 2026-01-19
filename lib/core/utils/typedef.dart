import 'package:dartz/dartz.dart';
import 'package:myapp/core/errors/failure.dart';

typedef ResultVoid = Future<Either<Failure, void>>;
typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef ResultStream<T> = Stream<Either<Failure, T>>;
typedef DataMap = Map<String, dynamic>;
