import 'package:flutter/material.dart';
import '../../data/placeholder_data.dart';
import '../../models/subject.dart';
import '../question/question_screen.dart';
import 'widgets/topic_card.dart';

class TopicsScreen extends StatelessWidget {
  final Subject subject;

  const TopicsScreen({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    final topics = placeholderTopics
        .where((t) => t.subjectId == subject.id)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(subject.name),
      ),
      body: topics.isEmpty
          ? const Center(
              child: Text(
                'No topics yet.',
                style: TextStyle(color: Colors.white54),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: topics.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final topic = topics[index];
                return TopicCard(
                  topic: topic,
                  accentColor: subject.color,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => QuestionScreen(
                          topic: topic,
                          accentColor: subject.color,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}