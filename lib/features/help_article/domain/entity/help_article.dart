import 'package:equatable/equatable.dart';

enum ArticleType {
  faq,
  howTo,
  tip,
  video,
}

class HelpArticle extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final ArticleType type;
  final List<String> content;

  const HelpArticle({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.content,
  });

  @override
  List<Object?> get props => [id, title, subtitle, type, content];
}