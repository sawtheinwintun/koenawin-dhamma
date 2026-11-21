import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/dhamma/logic/reading_settings.dart';
import 'features/koenawin/data/progress_store.dart';
import 'features/koenawin/logic/koenawin_controller.dart';
import 'features/koenawin/logic/reminder_service.dart';
import 'features/splash/screens/splash_screen.dart';

class KoeNaWinApp extends StatelessWidget {
  const KoeNaWinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => KoeNaWinController(
            store: ProgressStore(),
            reminders: NotificationReminders(),
          )..init(),
        ),
        ChangeNotifierProvider(create: (_) => ReadingSettings()..load()),
      ],
      child: MaterialApp(
        title: 'ကိုးနဝင်း',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        themeMode: ThemeMode.light,
        home: const SplashScreen(),
      ),
    );
  }
}
