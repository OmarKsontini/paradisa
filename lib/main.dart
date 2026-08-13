import 'package:flutter/material.dart';
import 'screens/subjects/subjects_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ScienceApp());
}

class ScienceApp extends StatelessWidget {
  const ScienceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Science App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme(),
      home: const SubjectsScreen(),
    );
  }
}