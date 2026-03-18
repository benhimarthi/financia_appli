import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/ai_assistant/domain/usecases/clear_chat_session.dart';
import 'package:myapp/features/ai_assistant/domain/usecases/get_chat_history.dart';
import 'package:myapp/features/ai_assistant/domain/usecases/send_message.dart';
import 'package:myapp/features/ai_assistant/domain/usecases/start_chat_session.dart';
import 'package:myapp/features/ai_assistant/presentation/cubit/ai_assistant_state.dart';

class AIAssistantCubit extends Cubit<AIAssistantState> {
  AIAssistantCubit({
    required StartChatSession startChatSession,
    required SendMessage sendMessage,
    required GetChatHistory getChatHistory,
    required ClearChatSession clearChatSession,
  })  : _startChatSession = startChatSession,
        _sendMessage = sendMessage,
        _getChatHistory = getChatHistory,
        _clearChatSession = clearChatSession,
        super(const AIAssistantInitial());

  final StartChatSession _startChatSession;
  final SendMessage _sendMessage;
  final GetChatHistory _getChatHistory;
  final ClearChatSession _clearChatSession;

  Future<void> startChat() async {
    emit(const AIAssistantLoading());
    final result = await _startChatSession();
    result.fold(
      (failure) => emit(AIAssistantError(failure.errorMessage)),
      (_) async => await getHistory(),
    );
  }

  Future<void> sendMessage(String message, String contextPrompt) async {
    emit(const AIAssistantLoading());
    final result = await _sendMessage(SendMessageParams(message, contextPrompt));
    result.fold(
      (failure) => emit(AIAssistantError(failure.errorMessage)),
      (_) async => await getHistory(),
    );
  }

  Future<void> getHistory() async {
    emit(const AIAssistantLoading());
    final result = await _getChatHistory();
    result.fold(
      (failure) => emit(AIAssistantError(failure.errorMessage)),
      (messages) => emit(AIAssistantLoaded(messages)),
    );
  }

  Future<void> clearChat() async {
    emit(const AIAssistantLoading());
    final result = await _clearChatSession();
    result.fold(
      (failure) => emit(AIAssistantError(failure.errorMessage)),
      (_) => emit(const AIAssistantLoaded([])),
    );
  }
}
