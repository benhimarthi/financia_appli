import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/core/utils/typedef.dart';
import 'package:myapp/features/ai_assistant/domain/entities/chat_message.dart';
import 'package:myapp/features/ai_assistant/domain/repositories/ai_assistant_repository.dart';

class SendMessage extends UseCaseWithParam<ChatMessage, SendMessageParams> {
  const SendMessage(this._repo);

  final AIAssistantRepository _repo;

  @override
  ResultFuture<ChatMessage> call(SendMessageParams params) async => _repo.sendMessage(params.message, params.contextPrompt);
}

class SendMessageParams{
  final String message;
  final String contextPrompt;

  const SendMessageParams(this.message, this.contextPrompt);
}
