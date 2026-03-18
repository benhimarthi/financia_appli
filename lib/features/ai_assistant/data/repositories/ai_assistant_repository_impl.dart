import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/core/errors/firebase_failure.dart';
import 'package:myapp/core/utils/typedef.dart';
import 'package:myapp/features/ai_assistant/data/datasources/ai_assistant_remote_data_source.dart';
import 'package:myapp/features/ai_assistant/domain/entities/chat_message.dart';
import 'package:myapp/features/ai_assistant/domain/repositories/ai_assistant_repository.dart';

class AIAssistantRepositoryImpl implements AIAssistantRepository {
  const AIAssistantRepositoryImpl(this._remoteDataSource);

  final AIAssistantRemoteDataSource _remoteDataSource;

  @override
  ResultVoid startChatSession() async {
    try {
      await _remoteDataSource.startChatSession();
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(message: e.message ?? 'Unknown Error', statusCode: 500));
    } on Exception catch (e) {
      return Left(FirebaseFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  ResultFuture<ChatMessage> sendMessage(String message, String contextPrompt) async {
    try {
      final result = await _remoteDataSource.sendMessage(message, contextPrompt);
      return Right(result);
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(message: e.message ?? 'Unknown Error', statusCode: 500));
    } on Exception catch (e) {
      return Left(FirebaseFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  ResultFuture<List<ChatMessage>> getChatHistory() async {
    try {
      final result = await _remoteDataSource.getChatHistory();
      return Right(result);
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(message: e.message ?? 'Unknown Error', statusCode: 500));
    } on Exception catch (e) {
      return Left(FirebaseFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  ResultVoid clearChatSession() async {
    try {
      await _remoteDataSource.clearChatSession();
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(message: e.message ?? 'Unknown Error', statusCode: 500));
    } on Exception catch (e) {
      return Left(FirebaseFailure(message: e.toString(), statusCode: 500));
    }
  }
}
