import 'package:flutter/material.dart';
import '../../data/placeholder_data.dart';
import '../../theme/app_theme.dart';
import '../topics/topics_screen.dart';
import 'widgets/subject_card.dart';

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subjects'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: placeholderSubjects.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final subject = placeholderSubjects[index];
          return SubjectCard(
            subject: subject,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TopicsScreen(subject: subject),
                ),
              );
            },
          );
        },
      ),
    );
  }
}