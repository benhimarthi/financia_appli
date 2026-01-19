import 'package:myapp/core/errors/exceptions.dart';
import 'package:myapp/core/errors/failure.dart';

class FirebaseFailure extends Failure {
  const FirebaseFailure({required super.statusCode, required super.message});
  FirebaseFailure.fromException(FirebaseExceptions exception)
    : this(message: exception.message, statusCode: exception.statusCode);
}
