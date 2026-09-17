enum QuestionType { multipleChoice, trueFalse }

QuestionType questionTypeFromString(String type) {
  switch (type) {
    case 'multiple_choice':
      return QuestionType.multipleChoice;
    case 'true_false':
      return QuestionType.trueFalse;
    default:
      throw Exception('Unknown question type: $type');
  }
}

class Question {
  final int id;
  final int topicId;
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

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      topicId: json['topic_id'],
      prompt: json['prompt'],
      type: questionTypeFromString(json['type']),
      options: List<String>.from(json['options']),
      correctOptionIndex: json['correct_option_index'],
    );
  }
}

String questionTypeToString(QuestionType type) {
  switch (type) {
    case QuestionType.multipleChoice:
      return 'multiple_choice';
    case QuestionType.trueFalse:
      return 'true_false';
  }
}