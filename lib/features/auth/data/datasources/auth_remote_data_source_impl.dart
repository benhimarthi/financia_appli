import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/core/errors/exceptions.dart';
import 'package:myapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:myapp/features/auth/data/models/user_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  }) : _auth = auth,
       _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  CollectionReference get _users => _firestore.collection('users');

  @override
  Future<void> deleteUser(String id) async {
    try {
      await _users.doc(id).delete();
      await _auth.currentUser?.delete();
    } on FirebaseException catch (e) {
      throw FirebaseExceptions(message: e.message ?? e.code, statusCode: 500);
    } on Exception {
      throw const FirebaseExceptions(
        message: 'An unexpected error occurred',
        statusCode: 500,
      );
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseException catch (e) {
      throw FirebaseExceptions(message: e.message ?? e.code, statusCode: 500);
    } on Exception {
      throw const FirebaseExceptions(
        message: 'An unexpected error occurred',
        statusCode: 500,
      );
    }
  }

  @override
  Future<UserModel> getUserById(String id) async {
    try {
      final doc = await _firestore.collection('users').doc(id).get();
      if (!doc.exists) {
        throw const FirebaseExceptions(
          message: 'User not found',
          statusCode: 404,
        );
      }
      return UserModel.fromSnap(doc);
    } on FirebaseAuthException catch (e) {
      throw FirebaseExceptions(
        message: e.message ?? 'An error occurred',
        statusCode: 500,
      );
    } on FirebaseExceptions {
      rethrow;
    } catch (e) {
      throw FirebaseExceptions(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      print("Entruuuuuuuuuuuuuuuuuuuuuuuuuuyyyy");
      final credentials = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("^^^^^^^^^^^^^^^^^^^^^^^55555555555555");
      final doc = await _users.doc(credentials.user!.uid).get();
      return UserModel.fromSnap(doc);
    } on FirebaseException catch (e) {
      print(e);
      throw FirebaseExceptions(message: e.message ?? e.code, statusCode: 500);
    } on Exception {
      throw const FirebaseExceptions(
        message: 'An unexpected error occurred',
        statusCode: 500,
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseException catch (e) {
      throw FirebaseExceptions(message: e.message ?? e.code, statusCode: 500);
    } on Exception {
      throw const FirebaseExceptions(
        message: 'An unexpected error occurred',
        statusCode: 500,
      );
    }
  }

  @override
  Future<UserModel> signUp({
    required UserModel userMd,
    required String password,
  }) async {
    try {
      final credentials = await _auth.createUserWithEmailAndPassword(
        email: userMd.email,
        password: password,
      );

      final user = UserModel(
        id: credentials.user!.uid,
        email: userMd.email,
        name: userMd.name,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
        accountType: userMd.accountType, // Default to regular
      );
      await _users.doc(user.id).set(user.toJson());
      return user;
    } on FirebaseException catch (e) {
      throw FirebaseExceptions(message: e.message ?? e.code, statusCode: 500);
    } on Exception {
      throw const FirebaseExceptions(
        message: 'An unexpected error occurred',
        statusCode: 500,
      );
    }
  }

  @override
  Future<UserModel> updateUser(UserModel updates) async {
    try {
      final uid = _auth.currentUser!.uid;
      await _users.doc(uid).update(updates.toJson());
      final doc = await _users.doc(uid).get();
      return UserModel.fromSnap(doc);
    } on FirebaseException catch (e) {
      throw FirebaseExceptions(message: e.message ?? e.code, statusCode: 500);
    } on Exception {
      throw const FirebaseExceptions(
        message: 'An unexpected error occurred',
        statusCode: 500,
      );
    }
  }
}
