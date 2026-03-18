// In a stateful widget that wraps your main app (e.g., a HomePage or a ShellRoute body)

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppLifecycleObserver extends StatefulWidget {
  final Widget child;

  const AppLifecycleObserver({super.key, required this.child});

  @override
  State<AppLifecycleObserver> createState() => _AppLifecycleObserverState();
}

class _AppLifecycleObserverState extends State<AppLifecycleObserver>
    with WidgetsBindingObserver {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // When the app comes back to the foreground, check the session.
    if (state == AppLifecycleState.resumed) {
      _checkSessionValidity();
    }
  }

  Future<void> _checkSessionValidity() async {
    final user = _auth.currentUser;
    if (user == null) return; // Not logged in, nothing to do.

    try {
      final deviceId = await _getCurrentDeviceId();
      final sessionDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('sessions')
          .doc(deviceId)
          .get();

      if (!sessionDoc.exists) {
        // The session has been revoked! Force logout.
        await _auth.signOut();
        // Navigate to login screen and show a message
        // This requires access to your Navigator. Use a global key or a BLoC event.
        // For example:
        // navigatorKey.currentState?.pushAndRemoveUntil(
        //   MaterialPageRoute(builder: (_) => LoginPage()),
        //   (route) => false,
        // );
        // ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        //   SnackBar(content: Text('Your session was logged out from another device.'))
        // );
      } else {
        // Optional: Update 'lastSeen' timestamp
        await sessionDoc.reference.update(
            {'lastSeen': FieldValue.serverTimestamp()});
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<String> _getCurrentDeviceId() async {
    // (Same helper method as in the SessionCubit)
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) return (await deviceInfo.androidInfo).id;
    if (Platform.isIOS)
      return (await deviceInfo.iosInfo).identifierForVendor ?? 'ios_device';
    return 'unknown';
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}