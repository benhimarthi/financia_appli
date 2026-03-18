
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/app_life_cycle_observer.dart';
import 'package:myapp/core/theme/theme.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:myapp/features/auth/presentation/pages/sign_in_page.dart';
import 'package:myapp/features/auth/presentation/pages/splash_page.dart';
import 'package:myapp/features/home/presentation/pages/home_page.dart';
import 'package:myapp/features/saving_goal/presentation/cubit/saving_goal_cubit.dart';
import 'package:myapp/features/settings/presentation/cubit/session_cubit.dart';
import 'package:myapp/features/transaction/presentation/bloc/transaction_cubit.dart';
import 'package:myapp/injection_container.dart';
import 'package:myapp/locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/auth/presentation/pages/app_lock_page.dart';
import 'features/help_article/presentation/cubit/help_article_cubit.dart';
import 'features/settings/Data/security_preferences.dart';
import 'features/settings/presentation/cubit/export_data_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await init();
  // === APPLY PRIVACY SETTING HERE ===
  final prefs = await SharedPreferences.getInstance();
  // Default to true if the user has not made a choice yet.
  final bool isAnalyticsEnabled = prefs.getBool('analytics') ?? true;
  // Set the collection state for the entire app session.
  // This persists across app restarts. [1]
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(isAnalyticsEnabled);
  runApp(
    EasyLocalization(
      supportedLocales: [const Locale('en', 'US'), const Locale('fr', 'FR')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
          ChangeNotifierProvider(create: (context) => LocaleProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void setTheme(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setSystemTheme() {
    _themeMode = ThemeMode.system;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => sl<AuthCubit>()..isLoggedIn()),
        BlocProvider<TransactionCubit>(create: (_) => sl<TransactionCubit>()),
        BlocProvider<SavingGoalCubit>(create: (_) => sl<SavingGoalCubit>()),
        BlocProvider<ExportDataCubit>(create: (_) => sl<ExportDataCubit>()),
        BlocProvider<SessionCubit>(create: (_) => sl<SessionCubit>()),
        BlocProvider<HelpArticleCubit>(create: (_) => sl<HelpArticleCubit>()),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, child) {
          return AppLifecycleObserver(
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'app_title'.tr(),
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: themeProvider.themeMode,
              locale: localeProvider.locale,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              home: const SplashPage(),
            )
          );
        },
      ),
    );
  }
}

class AuthRouter extends StatefulWidget {
  const AuthRouter({super.key});

  @override
  State<AuthRouter> createState() => _AuthRouterState();
}

class _AuthRouterState extends State<AuthRouter> {
  bool? _biometricLockEnabled;
  bool _isUnlocked = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricLock();
  }

  void _onUnlocked() {
    setState(() {
      _isUnlocked = true;
    });
  }

  Future<void> _checkBiometricLock() async {
    final prefs = SecurityPreferences();
    final isEnabled = await prefs.getBiometricLock();
    setState(() {
      _biometricLockEnabled = isEnabled;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (_biometricLockEnabled == null) {
      // Show a loading indicator while checking the setting
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_biometricLockEnabled! && !_isUnlocked) {
      return AppLockPage(onUnlocked: _onUnlocked);
    }
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          return const HomePage();
        } else if (state is AuthInitial) {
          return const SignInPage();
        } else {
          return const SignInPage();
        }
      },
    );
  }
}
