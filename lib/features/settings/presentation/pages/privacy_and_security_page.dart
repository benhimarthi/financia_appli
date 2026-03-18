import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:myapp/features/settings/presentation/pages/privacy_policy_page.dart';

import '../../../auth/data/auth_service.dart';
import '../../../auth/presentation/pages/forgot_password_page.dart';
import '../../Data/security_preferences.dart';


class PrivacyAndSecurityPage extends StatefulWidget {
  const PrivacyAndSecurityPage({super.key});

  @override
  State<PrivacyAndSecurityPage> createState() => _PrivacyAndSecurityPageState();
}

class _PrivacyAndSecurityPageState extends State<PrivacyAndSecurityPage> {
  final SecurityPreferences _prefs = SecurityPreferences();
  final AuthService _authService = AuthService();

  bool _hideBalances = false;
  bool _biometricLock = false;
  bool _analytics = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final hideBalances = await _prefs.getHideBalances();
    final biometricLock = await _prefs.getBiometricLock();
    final analytics = await _prefs.getAnalytics();

    setState(() {
      _hideBalances = hideBalances;
      _biometricLock = biometricLock;
      _analytics = analytics;
    });
  }

  Future<void> _handleBiometricToggle(bool value) async {
    if (value) {
      final isAvailable = await _authService.isBiometricAvailable();
      if (!isAvailable) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Biometric authentication is not available on this device.')),
          );
        }
        return;
      }
      final isAuthenticated = await _authService
          .authenticate('Please authenticate to enable Biometric Lock');
      if (isAuthenticated) {
        setState(() => _biometricLock = true);
        await _prefs.setBiometricLock(true);
      }
    } else {
      setState(() => _biometricLock = false);
      await _prefs.setBiometricLock(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('privacy'.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader(context, 'Security'.tr()),
          Card(
            elevation: 10,
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              children: [
                _buildSwitchTile(
                  icon: Icons.visibility_off_outlined,
                  title: 'Hide balances'.tr(),
                  subtitle: 'Show ••• instead of amounts',
                  value: _hideBalances,
                  onChanged: (value) {
                    setState(() => _hideBalances = value);
                    _prefs.setHideBalances(value);
                  },
                ),
                const Divider(),
                _buildSwitchTile(
                  icon: Icons.fingerprint,
                  title: 'Biometric lock',
                  subtitle: 'Use finger print or FaceId',
                  value: _biometricLock,
                  onChanged: _handleBiometricToggle,
                ),
                const Divider(),
                _buildInfoTile(
                  icon: Icons.lock_outline,
                  title: 'Change password',
                  subtitle: 'Update your password'.tr(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                    );
                  },
                ),
              ],
            ),
          ),
          _buildSectionHeader(context, 'data'.tr()),
          Card(
            elevation: 10,
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              children: [
                _buildSwitchTile(
                  icon: Icons.shield_outlined,
                  title: 'Analytics'.tr(),
                  subtitle: 'Help improve FYN'.tr(),
                  value: _analytics,
                  onChanged: (value) {
                    setState(() => _analytics = value);
                    _prefs.setAnalytics(value);
                  },
                ),
                const Divider(),
                _buildInfoTile(
                  icon: Icons.article_outlined,
                  title: 'Privacy policy'.tr(),
                  subtitle: 'Read our privacy terms'.tr(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.black87),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: Theme.of(context).colorScheme.primary,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.black87),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    );
  }
}
