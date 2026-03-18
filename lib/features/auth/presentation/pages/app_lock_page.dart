/*import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:myapp/features/auth/data/auth_service.dart';

class AppLockPage extends StatefulWidget {
  final VoidCallback onUnlocked;
  const AppLockPage({super.key, required this.onUnlocked});

  @override
  State<AppLockPage> createState() => _AppLockPageState();
}

class _AppLockPageState extends State<AppLockPage> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    // Immediately try to authenticate when the page loads
    _authenticate();
  }

  Future<void> _authenticate() async {
    final isAuthenticated = await _authService.authenticate('Unlock app'.tr());
    if (isAuthenticated && mounted) {
      Navigator.of(context).pop();
      widget.onUnlocked();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Blurred background (optional, for effect)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withAlpha(23),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'App locked'.tr(),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Text(
                  'Authenticate to unlock'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  icon: const Icon(Icons.fingerprint),
                  label: Text('Unlock'.tr()),
                  onPressed: _authenticate,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:myapp/features/auth/data/auth_service.dart';

class AppLockPage extends StatefulWidget {
  final VoidCallback onUnlocked;

  const AppLockPage({super.key, required this.onUnlocked});

  @override
  State<AppLockPage> createState() => _AppLockPageState();
}

class _AppLockPageState extends State<AppLockPage> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    // Immediately try to authenticate when the page loads
    _authenticate();
  }

  Future<void> _authenticate() async {
    final isAuthenticated = await _authService.authenticate('unlock_app'.tr());
    if (isAuthenticated && mounted) {
      widget.onUnlocked();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'App locked'.tr(),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              'Authenticate to unlock'.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.fingerprint),
              label: Text('Unlock'.tr()),
              onPressed: _authenticate,
              style: ElevatedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
