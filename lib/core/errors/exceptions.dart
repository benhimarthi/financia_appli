import 'package:equatable/equatable.dart';

class FirebaseExceptions extends Equatable implements Exception {
  const FirebaseExceptions({required this.message, required this.statusCode});

  final String message;
  final int statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}
