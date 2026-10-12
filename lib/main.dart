import 'package:flutter/material.dart';
import 'core/databases/cache_helper.dart';
import 'core/di/service_locator.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences caching layer
  await CacheHelper.init();

  // Initialize GetIt dependency injection
  await initServiceLocator();

  runApp(const SkillPilotApp());
}

class SkillPilotApp extends StatelessWidget {
  const SkillPilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const InitialPlaceholderScreen(),
    );
  }
}

class InitialPlaceholderScreen extends StatelessWidget {
  const InitialPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                size: 72,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                'Clean Architecture Foundation Ready',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Core networking, caching, and dependency injection have been bootstrapped successfully.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
