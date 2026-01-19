
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/locale_provider.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLocale = localeProvider.locale;

    return Scaffold(
      appBar: AppBar(
        title: Text('language'.tr()),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'select_preferred_language'.tr(),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  _buildLanguageTile(
                    context: context,
                    code: 'US',
                    language: 'English',
                    nativeName: 'English',
                    isSelected: currentLocale.languageCode == 'en',
                    onTap: () {
                      final newLocale = const Locale('en', 'US');
                      Provider.of<LocaleProvider>(context, listen: false)
                          .setLocale(newLocale);
                      context.setLocale(newLocale);
                    },
                  ),
                  const Divider(height: 1),
                  _buildLanguageTile(
                    context: context,
                    code: 'FR',
                    language: 'Français',
                    nativeName: 'French',
                    isSelected: currentLocale.languageCode == 'fr',
                    onTap: () {
                      final newLocale = const Locale('fr', 'FR');
                      Provider.of<LocaleProvider>(context, listen: false)
                          .setLocale(newLocale);
                      context.setLocale(newLocale);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageTile({
    required BuildContext context,
    required String code,
    required String language,
    required String nativeName,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Text(
        code,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
      title: Text(language, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(nativeName),
      trailing: isSelected
          ? const Icon(Icons.check, color: Color(0xFF003366))
          : null,
    );
  }
}
