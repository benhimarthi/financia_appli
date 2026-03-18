import 'package:myapp/core/utils/typedef.dart';
import '../../../../core/usecase/usecase.dart';
import '../entity/help_article.dart';
import '../repository/help_article_repository.dart';

class CreateHelpArticle extends UseCaseWithParam<void, HelpArticle>{
  final HelpArticleRepository _repository;

  CreateHelpArticle(this._repository);

  @override
  ResultVoid call(HelpArticle params) {
    return _repository.addHelpArticle(params);
  }
}