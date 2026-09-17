import 'package:flutter/material.dart';
import 'screens/subjects/subjects_screen.dart';
import 'services/api_service.dart';
import 'services/sync_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService.init();
  SyncService.syncAll(); // fire-and-forget — don't block app startup on the network
  runApp(const ScienceApp());
}

class ScienceApp extends StatelessWidget {
  const ScienceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paradisa',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme(),
      home: const SubjectsScreen(),
    );
  }
}