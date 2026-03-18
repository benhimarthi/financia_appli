import '../../domain/entity/help_article.dart';
import '../model/help_article_model.dart';

abstract class HelpArticleRemoteDataSource {
  Future<void> addHelpArticle(HelpArticle helpArticle);
  Future<List<HelpArticleModel>> getHelpArticles();
  Future<HelpArticleModel> getHelpArticleById(String id);
}
