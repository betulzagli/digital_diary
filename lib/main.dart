import 'package:flutter/material.dart';
import 'core/storage/diary_controller.dart';
import 'core/theme/app_theme.dart';
import 'feature/screens/main_navigation_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DiaryController.instance.initSampleData();
  runApp(const DearyApp());
}

class DearyApp extends StatelessWidget {
  const DearyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: DiaryController.instance.themeModeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: 'Deary',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: const MainNavigationScreen(),
        );
      },
    );
  }
}
