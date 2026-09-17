import 'package:flutter/material.dart';
import '../../models/topic.dart';
import '../../models/question.dart';
import '../../services/local_store.dart';
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
  List<Question>? questions;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await LocalStore.getQuestionsByTopic(widget.topic.id);
    if (!mounted) return;
    setState(() => questions = list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.topic.title)),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (questions == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (questions!.isEmpty) {
      return const Center(
        child: Text(
          'No questions yet for this topic.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
      );
    }

    return QuizBody(
      questions: questions!,
      accentColor: widget.accentColor,
    );
  }
}

class QuizBody extends StatefulWidget {
  final List<Question> questions;
  final Color accentColor;

  const QuizBody({
    super.key,
    required this.questions,
    required this.accentColor,
  });

  @override
  State<QuizBody> createState() => _QuizBodyState();
}

class _QuizBodyState extends State<QuizBody> {
  late final List<Question> queue = List.of(widget.questions);
  final Set<int> masteredIds = {};

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
    final hasAnswered = revealedCorrectIndex != null;
    final progress = masteredIds.length / widget.questions.length;

    return Column(
      children: [
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppTheme.surfaceLight,
          color: widget.accentColor,
          minHeight: 6,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: QuestionCard(
              question: currentQuestion,
              selectedIndex: selectedIndex,
              revealedCorrectIndex: revealedCorrectIndex,
              accentColor: widget.accentColor,
              onSelect: _onSelect,
            ),
          ),
        ),
        SafeArea(
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
      ],
    );
  }
}