import 'package:myapp/features/ai_assistant/domain/entities/chat_message.dart';

abstract class AIAssistantRemoteDataSource {
  Future<void> startChatSession();

  Future<ChatMessage> sendMessage(String message, String contextPrompt);

  Future<List<ChatMessage>> getChatHistory();

  Future<void> clearChatSession();
}
