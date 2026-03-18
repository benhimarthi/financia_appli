part of 'help_article_cubit.dart';

abstract class HelpArticleState extends Equatable {
  const HelpArticleState();

  @override
  List<Object> get props => [];
}

class HelpArticleInitial extends HelpArticleState {
  const HelpArticleInitial();
}

class HelpArticleLoading extends HelpArticleState {
  const HelpArticleLoading();
}

class HelpArticlesLoaded extends HelpArticleState {
  final List<HelpArticle> articles;

  const HelpArticlesLoaded(this.articles);

  @override
  List<Object> get props => [articles];
}

class HelpArticleLoaded extends HelpArticleState {
  final HelpArticle article;

  const HelpArticleLoaded(this.article);

  @override
  List<Object> get props => [article];
}

class HelpArticleError extends HelpArticleState {
  final String message;

  const HelpArticleError(this.message);

  @override
  List<Object> get props => [message];
}
