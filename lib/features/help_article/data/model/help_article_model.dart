import 'package:myapp/core/utils/typedef.dart';
import 'package:myapp/features/help_article/domain/entities/help_article.dart';

class HelpArticleModel extends HelpArticle {
  const HelpArticleModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.type,
    required super.content,
  });

  HelpArticleModel.fromEntity(HelpArticle entity)
      : super(
          id: entity.id,
          title: entity.title,
          subtitle: entity.subtitle,
          type: entity.type,
          content: entity.content,
        );

  const HelpArticleModel.empty()
      : this(
          id: '_empty.id',
          title: '_empty.title',
          subtitle: '_empty.subtitle',
          type: ArticleType.faq,
          content: const [],
        );

  factory HelpArticleModel.fromMap(DataMap map) {
    return HelpArticleModel(
      id: map['id'] as String,
      title: map['title'] as String,
      subtitle: map['subtitle'] as String,
      type: ArticleType.values
          .firstWhere((e) => e.toString() == 'ArticleType.${map['type']}'),
      content: List<String>.from(map['content'] as List),
    );
  }

  DataMap toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'type': type.toString().split('.').last,
      'content': content,
    };
  }

  HelpArticleModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    ArticleType? type,
    List<String>? content,
  }) {
    return HelpArticleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      type: type ?? this.type,
      content: content ?? this.content,
    );
  }
}
