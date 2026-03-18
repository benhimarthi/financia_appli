import 'package:myapp/core/utils/typedef.dart';
import '../entity/help_article.dart';

abstract class HelpArticleRepository {
  ResultVoid addHelpArticle(HelpArticle helpArticle);
  ResultFuture<List<HelpArticle>> getHelpArticles();
  ResultFuture<HelpArticle> getHelpArticleById(String id);
}
