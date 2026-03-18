import 'package:myapp/features/help_article/data/models/help_article_model.dart';

abstract class HelpArticleRemoteDataSource {
  Future<List<HelpArticleModel>> getHelpArticles();
  Future<HelpArticleModel> getHelpArticleById(String id);
}
