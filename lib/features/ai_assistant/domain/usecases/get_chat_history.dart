import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/core/utils/typedef.dart';
import 'package:myapp/features/ai_assistant/domain/entities/chat_message.dart';
import 'package:myapp/features/ai_assistant/domain/repositories/ai_assistant_repository.dart';

class GetChatHistory extends UseCaseWithoutParam<List<ChatMessage>> {
  const GetChatHistory(this._repo);

  final AIAssistantRepository _repo;

  @override
  ResultFuture<List<ChatMessage>> call() async => _repo.getChatHistory();
}
