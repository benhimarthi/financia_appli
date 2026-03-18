import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/core/utils/typedef.dart';
import 'package:myapp/features/help_article/domain/entities/help_article.dart';
import 'package:myapp/features/help_article/domain/repositories/help_article_repository.dart';

class GetHelpArticleById extends UseCaseWithParam<HelpArticle, String> {
  final HelpArticleRepository _repository;

  GetHelpArticleById(this._repository);

  @override
  ResultFuture<HelpArticle> call(String params) async =>
      _repository.getHelpArticleById(params);
}
