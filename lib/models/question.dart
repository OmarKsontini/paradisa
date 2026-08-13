enum QuestionType { multipleChoice, trueFalse }

class Question {
  final String id;
  final String topicId;
  final String prompt;
  final QuestionType type;
  final List<String> options;
  final int correctOptionIndex;

  const Question({
    required this.id,
    required this.topicId,
    required this.prompt,
    required this.type,
    required this.options,
    required this.correctOptionIndex,
  });
}