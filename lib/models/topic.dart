class Topic {
  final int id;
  final int subjectId;
  final String title;
  final String description;

  const Topic({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.description,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'],
      subjectId: json['subject_id'],
      title: json['title'],
      description: json['description'],
    );
  }
}