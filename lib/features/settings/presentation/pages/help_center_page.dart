import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  late String selectedOp = "chat";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedOp = "chat";
  }

  Future<void> sendEmail(String email) async {
    final Uri uri = Uri(scheme: 'mailto', path: email);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch email app';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help center'.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Row(
            children: [
              Expanded(
                child: _buildContactCard(
                  context,
                  icon: Icons.chat_bubble_outline,
                  title: 'Live chat'.tr(),
                  isSelected: selectedOp == "chat", // As per the design
                  onTap: () {
                    setState(() {
                      selectedOp = "chat";
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildContactCard(
                  context,
                  icon: Icons.email_outlined,
                  title: 'Email us'.tr(),
                  isSelected: selectedOp == "email", // As per the design,
                  onTap: () {
                    setState(() {
                      selectedOp = "email";
                      sendEmail("technov009@gmail.com");
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Resources'.tr(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                _buildResourceTile(
                  context,
                  icon: Icons.book_outlined,
                  title: 'User guides'.tr(),
                  subtitle: 'Step by step tutorials'.tr(),
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _buildResourceTile(
                  context,
                  icon: Icons.videocam_outlined,
                  title: 'Video tutorials'.tr(),
                  subtitle: 'Learn with visual guides'.tr(),
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _buildResourceTile(
                  context,
                  icon: Icons.lightbulb_outlined,
                  title: 'Tips and tricks'.tr(),
                  subtitle: 'Get the most out of FYN'.tr(),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              const Icon(Icons.help_outline, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                'Frequently asked questions'.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFaqTile(context, 'How do i add a transaction'.tr()),
          _buildFaqTile(context, 'How do i switch between profiles'.tr()),
          _buildFaqTile(context, 'How do i set savings goals'.tr()),
          _buildFaqTile(context, 'Is my data secure'.tr()),
          _buildFaqTile(context, 'How do i plan future expenses'.tr()),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text('Still need help'.tr(), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    text: 'support@fyn.app',
                    style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: ' • ${ 'Response within 24h'.tr() }',
                        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(
      BuildContext context,
      {
        required IconData icon,
        required String title,
        required bool isSelected,
        required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Theme.of(context).primaryColor,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceTile(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.grey[600]),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      trailing: const Icon(Icons.open_in_new, color: Colors.grey, size: 20),
      onTap: onTap,
    );
  }

  Widget _buildFaqTile(BuildContext context, String title) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10.0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: ListTile(
        leading: const Icon(Icons.article_outlined, color: Colors.grey),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}
