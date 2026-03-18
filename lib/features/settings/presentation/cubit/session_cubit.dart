import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Define a simple model for a device session
class DeviceSession {
  final String id;
  final String deviceName;
  final DateTime lastSeen;

  DeviceSession(
      {required this.id, required this.deviceName, required this.lastSeen});

  factory DeviceSession.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DeviceSession(
      id: doc.id,
      deviceName: data['deviceName'] ?? 'Unknown Device',
      lastSeen: (data['lastSeen'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

// --- Cubit States ---
abstract class SessionState {}

class SessionInitial extends SessionState {}

class SessionLoading extends SessionState {}

class SessionLoaded extends SessionState {
  final List<DeviceSession> sessions;
  final String currentDeviceId;

  SessionLoaded(this.sessions, this.currentDeviceId);
}

class SessionFailure extends SessionState {
  final String message;

  SessionFailure(this.message);
}

// --- Cubit Implementation ---
class SessionCubit extends Cubit<SessionState> {
  final FirebaseFirestore _firestore; //= FirebaseFirestore.instance;
  final FirebaseAuth _auth; //= FirebaseAuth.instance;

  SessionCubit(this._firestore, this._auth) : super(SessionInitial());

  Future<void> getConnectedDevices() async {
    emit(SessionLoading());
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in.');

      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('sessions')
          .orderBy('lastSeen', descending: true)
          .get();

      final sessions = snapshot.docs.map((doc) =>
          DeviceSession.fromFirestore(doc)).toList();

      // Get the ID of the current device to mark it in the UI
      final currentDeviceId = await _getCurrentDeviceId();

      emit(SessionLoaded(sessions, currentDeviceId));
    } catch (e) {
      emit(SessionFailure(e.toString()));
    }
  }

  Future<void> logoutDevice(String deviceId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in.');

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('sessions')
          .doc(deviceId)
          .delete();

      // Refresh the list after deleting
      await getConnectedDevices();
    } catch (e) {
      // Handle error, maybe emit a failure state
    }
  }

  // Helper to get the current device's ID
  Future<String> _getCurrentDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      return (await deviceInfo.androidInfo).id;
    } else if (Platform.isIOS) {
      return (await deviceInfo.iosInfo).identifierForVendor ?? 'ios_device';
    }
    return 'unknown';
  }
}