
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../Data/notification_preferences.dart';


class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationPreferences _prefs = NotificationPreferences();

  bool allNotifications = false;
  bool financialInsights = true;
  bool paymentReminders = true;
  bool goalProgress = true;
  bool budgetAlerts = false;
  bool securityAlerts = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final all = await _prefs.getAllNotifications();
    final financial = await _prefs.getFinancialInsights();
    final payment = await _prefs.getPaymentReminders();
    final goal = await _prefs.getGoalProgress();
    final budget = await _prefs.getBudgetAlerts();
    final security = await _prefs.getSecurityAlerts();

    setState(() {
      allNotifications = all;
      financialInsights = financial;
      paymentReminders = payment;
      goalProgress = goal;
      budgetAlerts = budget;
      securityAlerts = security;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('notifications'.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        //padding: const EdgeInsets.all(9.0),
        children: [
          const Divider(),
          Card(
            elevation: 3,
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 2, horizontal: 10),
              child: _buildNotificationSwitch(
                icon: Icons.notifications_none,
                title: 'All notifications'.tr(),
                subtitle: 'Master toggle'.tr(),
                value: allNotifications,
                onChanged: (value) {
                  setState(() {
                    allNotifications = value;
                    financialInsights = value;
                    paymentReminders = value;
                    goalProgress = value;
                    budgetAlerts = value;
                    securityAlerts = value;
                  });
                  _prefs.setAllNotifications(value);
                  _prefs.setFinancialInsights(value);
                  _prefs.setPaymentReminders(value);
                  _prefs.setGoalProgress(value);
                  _prefs.setBudgetAlerts(value);
                  _prefs.setSecurityAlerts(value);
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 3,
            child: Padding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 2, horizontal: 10),
              child: Column(
                children: [
                  _buildNotificationSwitch(
                    icon: Icons.trending_up,
                    title: 'Financial insights'.tr(),
                    subtitle: 'Weekly spending analysis'.tr(),
                    value: financialInsights,
                    onChanged: (value) {
                      setState(() => financialInsights = value);
                      _prefs.setFinancialInsights(value);
                    },
                  ),
                  const Divider(),
                  _buildNotificationSwitch(
                    icon: Icons.calendar_today,
                    title: 'Payment reminders'.tr(),
                    subtitle: 'Upcoming bills and subscriptions'.tr(),
                    value: paymentReminders,
                    onChanged: (value) {
                      setState(() => paymentReminders = value);
                      _prefs.setPaymentReminders(value);
                    },
                  ),
                  const Divider(),
                  _buildNotificationSwitch(
                    icon: Icons.track_changes,
                    title: 'Goal progress'.tr(),
                    subtitle: 'Updates on your saving goals'.tr(),
                    value: goalProgress,
                    onChanged: (value) {
                      setState(() => goalProgress = value);
                      _prefs.setGoalProgress(value);
                    },
                  ),
                  const Divider(),
                  _buildNotificationSwitch(
                    icon: Icons.wallet_giftcard,
                    title: 'Budget alerts'.tr(),
                    subtitle: 'When you are close to budget limits'.tr(),
                    value: budgetAlerts,
                    onChanged: (value) {
                      setState(() => budgetAlerts = value);
                      _prefs.setBudgetAlerts(value);
                    },
                  ),
                  const Divider(),
                  _buildNotificationSwitch(
                    icon: Icons.security,
                    title: 'Security alerts'.tr(),
                    subtitle: 'Unusual activity notifications'.tr(),
                    value: securityAlerts,
                    onChanged: (value) {
                      setState(() => securityAlerts = value);
                      _prefs.setSecurityAlerts(value);
                    },
                  ),
                ],
              )
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'you can change these settings at any time'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600], fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSwitch({
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
        activeThumbColor : Theme.of(context).colorScheme.primary,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
    );
  }
}
