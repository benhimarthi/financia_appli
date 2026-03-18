import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/core/utils/typedef.dart';
import '../entity/help_article.dart';
import '../repository/help_article_repository.dart';

class GetHelpArticles extends UseCaseWithoutParam<List<HelpArticle>> {
  final HelpArticleRepository _repository;

  GetHelpArticles(this._repository);

  @override
  ResultFuture<List<HelpArticle>> call() async => _repository.getHelpArticles();
}
