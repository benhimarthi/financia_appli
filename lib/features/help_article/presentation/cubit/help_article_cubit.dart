import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entity/help_article.dart';
import '../../domain/usecase/create_help_article.dart';
import '../../domain/usecase/get_help_article_by_id.dart';
import '../../domain/usecase/get_help_articles.dart';
part 'help_article_state.dart';

class HelpArticleCubit extends Cubit<HelpArticleState> {
  final GetHelpArticles _getHelpArticles;
  final GetHelpArticleById _getHelpArticleById;
  final CreateHelpArticle _createHelpArticle;

  HelpArticleCubit({
    required GetHelpArticles getHelpArticles,
    required GetHelpArticleById getHelpArticleById,
    required CreateHelpArticle createHelpArticle,
  })  : _getHelpArticles = getHelpArticles,
        _getHelpArticleById = getHelpArticleById,
        _createHelpArticle = createHelpArticle,
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
  Future<void> createHelpArticle(HelpArticle helpArticle) async {
    emit(const HelpArticleLoading());
    final result = await _createHelpArticle(helpArticle);
    result.fold(
          (failure) => emit(HelpArticleError(failure.errorMessage)),
          (_) => emit(const CreateHelpArticleSuccessful())
          );
  }
}
