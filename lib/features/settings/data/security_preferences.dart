import 'package:shared_preferences/shared_preferences.dart';

class SecurityPreferences {
  static const _hideBalances = 'hideBalances';
  static const _biometricLock = 'biometricLock';
  static const _analytics = 'analytics';

  Future<void> setHideBalances(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hideBalances, value);
  }

  Future<bool> getHideBalances() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hideBalances) ?? false;
  }

  Future<void> setBiometricLock(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricLock, value);
  }

  Future<bool> getBiometricLock() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricLock) ?? false;
  }

  Future<void> setAnalytics(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_analytics, value);
  }

  Future<bool> getAnalytics() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_analytics) ?? true;
  }
}
