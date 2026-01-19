import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/main.dart';
import 'package:myapp/features/auth/presentation/pages/profile_page.dart';
import 'package:myapp/features/settings/presentation/pages/language_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:myapp/locale_provider.dart';

import '../../../auth/presentation/bloc/auth_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: ListView(
        children: [
          Builder(
            builder: (context) {
              final authState = context.read<AuthCubit>().state;
              bool isAuth = authState is AuthSuccess;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          isAuth ? authState.user.name[0].toUpperCase() : 'G',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAuth ? authState.user.name : 'guest_user'.tr(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          isAuth
                              ? authState.user.accountType.name
                              : 'personal_account'.tr(),
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),
          _buildSectionHeader(context, 'account'.tr()),
          _buildAccountSection(context),
          _buildSectionHeader(context, 'preferences'.tr()),
          _buildPreferencesSection(context),
          _buildSectionHeader(context, 'data_privacy'.tr()),
          _buildDataPrivacySection(context),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLocale = localeProvider.locale;
    final language = currentLocale.languageCode == 'en' ? 'English' : 'Français';
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          _buildListTile(
            context,
            icon: Icons.person_outline,
            title: 'profile'.tr(),
            subtitle: 'manage_personal_information'.tr(),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          _buildListTile(
            context,
            icon: Icons.language,
            title: 'language'.tr(),
            subtitle: language,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LanguagePage()),
              );
            },
          ),
          _buildListTile(
            context,
            icon: Icons.attach_money,
            title: 'currency'.tr(),
            subtitle: 'USD (\$)',
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesSection(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: Text('theme'.tr()),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.light_mode,
                    color: themeProvider.themeMode == ThemeMode.light
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                  ),
                  onPressed: () =>
                      Provider.of<ThemeProvider>(context, listen: false)
                          .setTheme(ThemeMode.light),
                ),
                IconButton(
                  icon: Icon(
                    Icons.dark_mode,
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                  ),
                  onPressed: () =>
                      Provider.of<ThemeProvider>(context, listen: false)
                          .setTheme(ThemeMode.dark),
                ),
              ],
            ),
          ),
          _buildListTile(
            context,
            icon: Icons.notifications_outlined,
            title: 'notifications'.tr(),
            subtitle: 'manage_alerts_reminders'.tr(),
          ),
        ],
      ),
    );
  }

  Widget _buildDataPrivacySection(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          _buildListTile(
            context,
            icon: Icons.lock_outline,
            title: 'security'.tr(),
            subtitle: 'manage_account_security'.tr(),
          ),
          _buildListTile(
            context,
            icon: Icons.privacy_tip_outlined,
            title: 'privacy_policy'.tr(),
            subtitle: 'read_privacy_policy'.tr(),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}
