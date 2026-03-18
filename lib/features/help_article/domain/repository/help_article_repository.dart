import 'package:myapp/core/utils/typedef.dart';
import 'package:myapp/features/help_article/domain/entities/help_article.dart';

abstract class HelpArticleRepository {
  ResultFuture<List<HelpArticle>> getHelpArticles();
  ResultFuture<HelpArticle> getHelpArticleById(String id);
}
