import 'package:flutter/material.dart';
import '../../data/placeholder_data.dart';
import '../../models/topic.dart';
import '../../models/question.dart';
import '../../theme/app_theme.dart';
import 'widgets/question_card.dart';

class QuestionScreen extends StatefulWidget {
  final Topic topic;
  final Color accentColor;

  const QuestionScreen({
    super.key,
    required this.topic,
    required this.accentColor,
  });

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  late final List<Question> originalQuestions = placeholderQuestions
      .where((q) => q.topicId == widget.topic.id)
      .toList();

  late final List<Question> queue = List.of(originalQuestions);
  final Set<String> masteredIds = {};

  int? selectedIndex;
  int? revealedCorrectIndex;

  Question get currentQuestion => queue.first;

  void _onSelect(int index) {
    setState(() => selectedIndex = index);
  }

  void _onCheck() {
    if (selectedIndex == null) return;
    final isCorrect = selectedIndex == currentQuestion.correctOptionIndex;
    setState(() {
      revealedCorrectIndex = currentQuestion.correctOptionIndex;
      if (isCorrect) masteredIds.add(currentQuestion.id);
    });
  }

  void _onContinue() {
    final wasCorrect = selectedIndex == currentQuestion.correctOptionIndex;
    final finished = queue.removeAt(0);

    if (!wasCorrect) {
      queue.add(finished);
    }

    if (queue.isEmpty) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      selectedIndex = null;
      revealedCorrectIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (originalQuestions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.topic.title)),
        body: const Center(
          child: Text(
            'No questions yet for this topic.',
            style: TextStyle(color: Colors.white54),
          ),
        ),
      );
    }

    final hasAnswered = revealedCorrectIndex != null;
    final progress = masteredIds.length / originalQuestions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppTheme.surfaceLight,
            color: widget.accentColor,
            minHeight: 6,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: QuestionCard(
          question: currentQuestion,
          selectedIndex: selectedIndex,
          revealedCorrectIndex: revealedCorrectIndex,
          accentColor: widget.accentColor,
          onSelect: _onSelect,
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: hasAnswered
                    ? (selectedIndex == currentQuestion.correctOptionIndex
                        ? AppTheme.success
                        : AppTheme.error)
                    : widget.accentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: selectedIndex == null
                  ? null
                  : hasAnswered
                      ? _onContinue
                      : _onCheck,
              child: Text(
                hasAnswered ? 'CONTINUE' : 'CHECK',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}