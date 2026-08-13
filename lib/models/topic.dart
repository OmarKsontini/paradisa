class Topic {
  final String id;
  final String subjectId;
  final String title;
  final String description;
  final int questionCount; 

  const Topic({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.description,
    required this.questionCount,
  });
}