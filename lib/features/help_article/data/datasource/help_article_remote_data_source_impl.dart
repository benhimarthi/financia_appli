import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/core/errors/exceptions.dart';
import 'package:myapp/features/help_article/domain/entity/help_article.dart';
import '../model/help_article_model.dart';
import 'help_article_remote_data_source.dart';

class HelpArticleRemoteDataSourceImpl implements HelpArticleRemoteDataSource {
  final FirebaseFirestore _firestore;

  HelpArticleRemoteDataSourceImpl(this._firestore);

  @override
  Future<List<HelpArticleModel>> getHelpArticles() async {
    try {
      final snapshot = await _firestore.collection('help_articles').get();
      return snapshot.docs
          .map((doc) => HelpArticleModel.fromMap(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw FirebaseExceptions(message: e.message ?? 'Unknown Error', statusCode: 400);
    }
  }

  @override
  Future<HelpArticleModel> getHelpArticleById(String id) async {
    try {
      final doc = await _firestore.collection('help_articles').doc(id).get();
      if (doc.exists) {
        return HelpArticleModel.fromMap(doc.data()!);
      } else {
        throw const FirebaseExceptions(message: 'Article not found', statusCode: 404);
      }
    } on FirebaseException catch (e) {
      throw FirebaseExceptions(message: e.message ?? 'Unknown Error', statusCode: 400);
    }
  }

  @override
  Future<void> addHelpArticle(HelpArticle helpArticle) async {
    try{
      final helpArticleModel = HelpArticleModel.fromEntity(helpArticle);
      await _firestore.collection('help_articles').add(helpArticleModel.toMap());
    }
    on FirebaseException catch (e) {
      throw FirebaseExceptions(message: e.message ?? 'Unknown Error', statusCode: 400);
    }
  }
}
