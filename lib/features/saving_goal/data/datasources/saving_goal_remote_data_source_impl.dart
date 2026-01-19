import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/core/errors/exceptions.dart';
import 'package:myapp/features/saving_goal/data/datasources/saving_goal_remote_data_source.dart';
import 'package:myapp/features/saving_goal/data/models/saving_goal_model.dart';

class SavingGoalRemoteDataSourceImpl implements SavingGoalRemoteDataSource {
  final FirebaseFirestore _firestore;

  SavingGoalRemoteDataSourceImpl(this._firestore);

  @override
  Future<void> addSavingGoal(SavingGoalModel savingGoal) async {
    try {
      await _firestore
          .collection('saving_goals')
          .doc(savingGoal.id)
          .set(savingGoal.toMap());
    } on FirebaseException catch (e) {
      throw FirebaseExceptions(message: e.message ?? 'Unknown error', statusCode: int.tryParse(e.code) ?? 500);
    }
  }

  @override
  Future<void> deleteSavingGoal(String savingGoalId) async {
    try {
      await _firestore.collection('saving_goals').doc(savingGoalId).delete();
    } on FirebaseException catch (e) {
      throw FirebaseExceptions(message: e.message ?? 'Unknown error', statusCode: int.tryParse(e.code) ?? 500);
    }
  }

  @override
  Future<List<SavingGoalModel>> getSavingGoals(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('saving_goals')
          .where('userId', isEqualTo: userId)
          .get();
      return snapshot.docs
          .map((doc) => SavingGoalModel.fromMap(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw FirebaseExceptions(message: e.message ?? 'Unknown error', statusCode: int.tryParse(e.code) ?? 500);
    }
  }

  @override
  Future<void> updateSavingGoal(SavingGoalModel savingGoal) async {
    try {
      await _firestore
          .collection('saving_goals')
          .doc(savingGoal.id)
          .update(savingGoal.toMap());
    } on FirebaseException catch (e) {
      throw FirebaseExceptions(message: e.message ?? 'Unknown error', statusCode: int.tryParse(e.code) ?? 500);
    }
  }
}
