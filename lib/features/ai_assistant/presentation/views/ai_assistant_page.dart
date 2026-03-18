import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/ai_assistant/domain/usecases/send_message.dart';
import 'package:myapp/features/ai_assistant/presentation/cubit/ai_assistant_cubit.dart';
import 'package:myapp/features/ai_assistant/presentation/cubit/ai_assistant_state.dart';
import 'package:myapp/features/ai_assistant/presentation/widgets/chat_bubble.dart';
import 'package:myapp/features/ai_assistant/presentation/widgets/message_input.dart';

class AIAssistantPage extends StatefulWidget {
  const AIAssistantPage({super.key});

  @override
  State<AIAssistantPage> createState() => _AIAssistantPageState();
}

class _AIAssistantPageState extends State<AIAssistantPage> {
  @override
  void initState() {
    super.initState();
    context.read<AIAssistantCubit>().startChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<AIAssistantCubit>().getHistory(),
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => context.read<AIAssistantCubit>().clearChat(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<AIAssistantCubit, AIAssistantState>(
              builder: (context, state) {
                if (state is AIAssistantLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AIAssistantLoaded) {
                  return ListView.builder(
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      return ChatBubble(message: state.messages[index]);
                    },
                  );
                } else if (state is AIAssistantError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text('Welcome to the AI Assistant!'));
                }
              },
            ),
          ),
          MessageInput(
            onSendMessage: (message) {
              context.read<AIAssistantCubit>().sendMessage(message, "");
            },
          ),
        ],
      ),
    );
  }
}
