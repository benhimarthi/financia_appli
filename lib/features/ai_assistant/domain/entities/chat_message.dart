import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String text;
  final bool isMe;
  final DateTime timestamp;

  const ChatMessage({
        required this.text,
        required this.isMe,
        required this.timestamp
      });

  @override
  List<Object> get props => [text, isMe, timestamp];
}
