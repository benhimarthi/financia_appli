import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/core/utils/typedef.dart';
import '../entity/help_article.dart';
import '../repository/help_article_repository.dart';

class GetHelpArticleById extends UseCaseWithParam<HelpArticle, String> {
  final HelpArticleRepository _repository;

  GetHelpArticleById(this._repository);

  @override
  ResultFuture<HelpArticle> call(String params) async =>
      _repository.getHelpArticleById(params);
}
