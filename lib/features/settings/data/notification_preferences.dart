import 'package:shared_preferences/shared_preferences.dart';

class NotificationPreferences {
  static const _allNotifications = 'all_notifications';
  static const _financialInsights = 'financial_insights';
  static const _paymentReminders = 'payment_reminders';
  static const _goalProgress = 'goal_progress';
  static const _budgetAlerts = 'budget_alerts';
  static const _securityAlerts = 'security_alerts';

  Future<void> setAllNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_allNotifications, value);
  }

  Future<bool> getAllNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_allNotifications) ?? false;
  }

  Future<void> setFinancialInsights(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_financialInsights, value);
  }

  Future<bool> getFinancialInsights() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_financialInsights) ?? true;
  }

  Future<void> setPaymentReminders(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_paymentReminders, value);
  }

  Future<bool> getPaymentReminders() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_paymentReminders) ?? true;
  }

  Future<void> setGoalProgress(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_goalProgress, value);
  }

  Future<bool> getGoalProgress() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_goalProgress) ?? true;
  }

  Future<void> setBudgetAlerts(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_budgetAlerts, value);
  }

  Future<bool> getBudgetAlerts() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_budgetAlerts) ?? false;
  }

  Future<void> setSecurityAlerts(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_securityAlerts, value);
  }

  Future<bool> getSecurityAlerts() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_securityAlerts) ?? true;
  }
}
