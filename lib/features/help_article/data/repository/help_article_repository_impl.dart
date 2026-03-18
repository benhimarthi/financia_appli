import 'package:dartz/dartz.dart';
import 'package:myapp/core/errors/exceptions.dart';
import 'package:myapp/core/errors/firebase_failure.dart';
import 'package:myapp/core/utils/typedef.dart';
import '../../domain/entity/help_article.dart';
import '../../domain/repository/help_article_repository.dart';
import '../datasource/help_article_remote_data_source.dart';

class HelpArticleRepositoryImpl implements HelpArticleRepository {
  final HelpArticleRemoteDataSource _remoteDataSource;

  HelpArticleRepositoryImpl(this._remoteDataSource);

  @override
  ResultFuture<List<HelpArticle>> getHelpArticles() async {
    try {
      final result = await _remoteDataSource.getHelpArticles();
      return Right(result);
    } on FirebaseExceptions catch (e) {
      return Left(
        FirebaseFailure(message: e.message, statusCode: e.statusCode),
      );
    }
  }

  @override
  ResultFuture<HelpArticle> getHelpArticleById(String id) async {
    try {
      final result = await _remoteDataSource.getHelpArticleById(id);
      return Right(result);
    } on FirebaseExceptions catch (e) {
      return Left(
        FirebaseFailure(message: e.message, statusCode: e.statusCode),
      );
    }
  }

  @override
  ResultVoid addHelpArticle(HelpArticle helpArticle) async {
    try{
      _remoteDataSource.getHelpArticles();
      return const Right(unit);
    }on FirebaseExceptions catch (e) {
      return Left(
        FirebaseFailure(message: e.message, statusCode: e.statusCode),
      );
    }
  }
}
