
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myapp/locale_provider.dart';
import 'package:provider/provider.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.formKey,
    required this.title,
    required this.fields,
    required this.submitButtonText,
    required this.onSubmit,
    required this.switchButtonText,
    required this.onSwitch,
  });

  final GlobalKey<FormState> formKey;
  final String title;
  final List<Widget> fields;
  final String submitButtonText;
  final VoidCallback onSubmit;
  final String switchButtonText;
  final VoidCallback onSwitch;

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                if (localeProvider.locale.languageCode == 'en') {
                  localeProvider.setLocale(const Locale('fr', 'FR'));
                  context.setLocale(const Locale('fr', 'FR'));
                } else {
                  localeProvider.setLocale(const Locale('en', 'US'));
                  context.setLocale(const Locale('en', 'US'));
                }
              },
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "EN",
                      style: TextStyle(
                        color: localeProvider.locale.languageCode == 'en'
                            ? Theme.of(context).primaryColor
                            : Colors.black26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: " / "),
                    TextSpan(
                      text: "FR",
                      style: TextStyle(
                        color: localeProvider.locale.languageCode == 'fr'
                            ? Theme.of(context).primaryColor
                            : Colors.black26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  style: const TextStyle(
                    color: Colors.black26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...fields,
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: onSubmit,
                  child: Text(submitButtonText),
                ),
                if (switchButtonText.isNotEmpty)
                  TextButton(
                    onPressed: onSwitch,
                    child: Text(switchButtonText),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
