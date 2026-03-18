import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
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
      final credentials = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = credentials.user;
      // --- NEW: SESSION TRACKING LOGIC ---
      await _createOrUpdateSession(firebaseUser!.uid);
      // --- END OF NEW LOGIC ---
      final doc = await _users.doc(credentials.user!.uid).get();
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
  // Helper method to create the session document
  Future<void> _createOrUpdateSession(String userId) async {
    final deviceInfo = DeviceInfoPlugin();
    String deviceName;
    String deviceId;

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      deviceName = '${androidInfo.manufacturer} ${androidInfo.model}';
      deviceId = androidInfo.id; // A unique ID for the Android device
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      deviceName = iosInfo.name; // e.g., "John's iPhone"
      deviceId = iosInfo.identifierForVendor ?? 'ios_device'; // A unique ID for the app vendor
    } else {
      deviceName = 'Web Browser';
      deviceId = 'web_session_${DateTime.now().millisecondsSinceEpoch}';
    }

    final sessionDoc = _firestore.collection('users').doc(userId).collection('sessions').doc(deviceId);

    await sessionDoc.set({
      'deviceName': deviceName,
      'lastSeen': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    });
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

  @override
  Future<void> changeEmail({required String newEmail, required String password}) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw const FirebaseExceptions(
          message: 'No user is currently signed in.',
          statusCode: 401, // Unauthorized
        );
      }

      // Step 1: Re-authenticate the user for security. This is crucial.
      final cred = EmailAuthProvider.credential(
        email: currentUser.email!,
        password: password,
      );
      await currentUser.reauthenticateWithCredential(cred);
      // Step 2: If re-authentication is successful, send the verification to the new email.
      await currentUser.verifyBeforeUpdateEmail(newEmail);

      // Note: Firebase handles sending the verification email automatically.
      // The email in FirebaseAuth will only update after the user clicks the link.
      // You may want to update the email in your Firestore 'users' collection
      // via a cloud function triggered by the email verification, or have the user
      // re-login to refresh the data. For now, we only handle the auth part.
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
