import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/features/ai_assistant/domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  const ChatMessageModel({
    required super.text,
    required super.isMe,
    required super.timestamp,
  });

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      text: map['text'] as String,
      isMe: map['isMe'] as bool,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  factory ChatMessageModel.fromJson(String source) =>
      ChatMessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'isMe': isMe,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  String toJson() => json.encode(toMap());

  ChatMessageModel copyWith({
    String? text,
    bool? isMe,
    DateTime? timestamp,
  }) {
    return ChatMessageModel(
      text: text ?? this.text,
      isMe: isMe ?? this.isMe,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
