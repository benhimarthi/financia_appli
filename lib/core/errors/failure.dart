import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int statusCode;

  String get errorMessage => "$statusCode Error: $message";
  const Failure({required this.statusCode, required this.message});

  @override
  List<Object> get props => [message, statusCode];
}
