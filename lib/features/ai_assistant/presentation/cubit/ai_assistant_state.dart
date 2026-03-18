import 'package:equatable/equatable.dart';
import 'package:myapp/features/ai_assistant/domain/entities/chat_message.dart';

abstract class AIAssistantState extends Equatable {
  const AIAssistantState();

  @override
  List<Object> get props => [];
}

class AIAssistantInitial extends AIAssistantState {
  const AIAssistantInitial();
}

class AIAssistantLoading extends AIAssistantState {
  const AIAssistantLoading();
}

class AIAssistantLoaded extends AIAssistantState {
  const AIAssistantLoaded(this.messages);

  final List<ChatMessage> messages;

  @override
  List<Object> get props => [messages];
}

class AIAssistantError extends AIAssistantState {
  const AIAssistantError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
