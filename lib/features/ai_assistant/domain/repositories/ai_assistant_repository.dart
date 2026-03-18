import 'package:myapp/core/utils/typedef.dart';
import 'package:myapp/features/ai_assistant/domain/entities/chat_message.dart';

abstract class AIAssistantRepository {
  ResultVoid startChatSession();

  ResultFuture<ChatMessage> sendMessage(String message, String contextPrompt);

  ResultFuture<List<ChatMessage>> getChatHistory();
  
  ResultVoid clearChatSession();
}
