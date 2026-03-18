import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:myapp/features/help_article/domain/entities/help_article.dart';
import 'package:myapp/features/help_article/domain/usecases/get_help_articles.dart';
import 'package:myapp/features/help_article/domain/usecases/get_help_article_by_id.dart';

part 'help_article_state.dart';

class HelpArticleCubit extends Cubit<HelpArticleState> {
  final GetHelpArticles _getHelpArticles;
  final GetHelpArticleById _getHelpArticleById;

  HelpArticleCubit({
    required GetHelpArticles getHelpArticles,
    required GetHelpArticleById getHelpArticleById,
  })  : _getHelpArticles = getHelpArticles,
        _getHelpArticleById = getHelpArticleById,
        super(const HelpArticleInitial());

  Future<void> getHelpArticles() async {
    emit(const HelpArticleLoading());
    final result = await _getHelpArticles();
    result.fold(
      (failure) => emit(HelpArticleError(failure.errorMessage)),
      (articles) => emit(HelpArticlesLoaded(articles)),
    );
  }

  Future<void> getHelpArticleById(String id) async {
    emit(const HelpArticleLoading());
    final result = await _getHelpArticleById(id);
    result.fold(
      (failure) => emit(HelpArticleError(failure.errorMessage)),
      (article) => emit(HelpArticleLoaded(article)),
    );
  }
}
