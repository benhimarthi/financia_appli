import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:myapp/core/errors/exceptions.dart';
import 'package:myapp/features/ai_assistant/data/datasources/ai_assistant_remote_data_source.dart';
import 'package:myapp/features/ai_assistant/data/models/chat_message_model.dart';

class AIAssistantRemoteDataSourceImpl implements AIAssistantRemoteDataSource {
  final FirebaseVertexAI firebaseAI;
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  AIAssistantRemoteDataSourceImpl(
      {required this.firebaseAI, required this.firestore, required this.auth});

  @override
  Future<void> startChatSession() async {
    // No need to do anything here as a new chat session is implicitly started
    // when a new user logs in or when the chat history is cleared.
  }

  @override
  Future<ChatMessageModel> sendMessage(String message, String contextPrompt) async {
    final user = auth.currentUser;
    if (user == null) {
      throw const FirebaseExceptions(message: 'User not authenticated', statusCode:  500);
    }

    final userMessage = ChatMessageModel(
      text: message,
      isMe: true,
      timestamp: DateTime.now(),
    );

    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('chats')
        .add(userMessage.toMap());

    final model = firebaseAI.generativeModel(
      model: 'gemini-2.5-flash',
      systemInstruction: Content.system(
          "You are a precise financial assistant. You analyze structured financial data and return concise, actionable insights. Never give generic advice. Always base your answer strictly on the provided data. Always respond in JSON format only."
      ),
    );
    final chat = model.startChat(history: await _getHistory(user.uid));
    final response = await chat.sendMessage(Content.text(message));

    if (response.text == null) {
      throw const FirebaseExceptions(message: 'Failed to get a response from the model.', statusCode: 500);
    }

    final aiMessage = ChatMessageModel(
      text: response.text!,
      isMe: false,
      timestamp: DateTime.now(),
    );

    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('chats')
        .add(aiMessage.toMap());

    return aiMessage;
  }

  @override
  Future<List<ChatMessageModel>> getChatHistory() async {
    final user = auth.currentUser;
    if (user == null) {
      throw const FirebaseExceptions(message: 'User not authenticated', statusCode: 500);
    }

    final snapshot = await firestore
        .collection('users')
        .doc(user.uid)
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => ChatMessageModel.fromMap(doc.data()))
        .toList();
  }

  @override
  Future<void> clearChatSession() async {
    final user = auth.currentUser;
    if (user == null) {
      throw const FirebaseExceptions(message: 'User not authenticated', statusCode: 500);
    }

    final snapshot = await firestore
        .collection('users')
        .doc(user.uid)
        .collection('chats')
        .get();

    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<List<Content>> _getHistory(String uid) async {
    final snapshot = await firestore
        .collection('users')
        .doc(uid)
        .collection('chats')
        .orderBy('timestamp', descending: false)
        .get();

    final history = <Content>[];
    for (final doc in snapshot.docs) {
      final message = ChatMessageModel.fromMap(doc.data());
      history.add(Content(message.isMe ? 'user' : 'model', [TextPart(message.text)]));
    }
    return history;
  }
}
