import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/core/errors/exceptions.dart';
import 'package:myapp/features/transaction/data/datasources/transaction_remote_data_source.dart';
import 'package:myapp/features/transaction/data/models/transaction_model.dart';

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final FirebaseFirestore _firestore;

  TransactionRemoteDataSourceImpl(this._firestore);

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await _firestore
          .collection('transactions')
          .doc(transaction.id)
          .set(transaction.toJson());
    } on FirebaseException {
      rethrow;
    }
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _firestore.collection('transactions').doc(transactionId).delete();
    } on FirebaseException {
      rethrow;
    }
  }

  @override
  Future<List<TransactionModel>> getTransactions(String userId) async {
    try {
      var t = await _firestore
          .collection('transactions')
          .where('userId', isEqualTo: userId)
          .get();
      return t.docs.map((e) => TransactionModel.fromJson(e.data())).toList();
    } on FirebaseExceptions catch (e) {
      throw FirebaseExceptions(message: e.message, statusCode: 500);
    }
  }

  @override
  Future<TransactionModel> getTransactionById(String transactionId) async {
    try {
      final doc = await _firestore
          .collection('transactions')
          .doc(transactionId)
          .get();
      if (doc.exists) {
        return TransactionModel.fromJson(doc.data()!);
      } else {
        throw FirebaseException(
          plugin: 'Firestore',
          message: 'Transaction not found',
        );
      }
    } on FirebaseException {
      rethrow;
    }
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      await _firestore
          .collection('transactions')
          .doc(transaction.id)
          .update(transaction.toJson());
    } on FirebaseException {
      rethrow;
    }
  }
}
