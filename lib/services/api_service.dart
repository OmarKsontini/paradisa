import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/subject.dart';
import '../models/topic.dart';
import '../models/question.dart';
import 'settings_service.dart';

class ApiService {

  static String baseUrl = SettingsService.defaultBaseUrl;

  static Future<void> init() async {
    baseUrl = await SettingsService.getBaseUrl();
  }



  static const _headers = {'Content-Type': 'application/json'};

  static Future<List<dynamic>> _getListRaw(String path) async {
    final res = await http.get(Uri.parse('$baseUrl$path'));
    if (res.statusCode == 200) return jsonDecode(res.body) as List<dynamic>;
    if (res.statusCode == 404) return [];
    throw Exception('Request failed (${res.statusCode})');
  }

  // ---------------- Subjects ----------------

  static Future<List<dynamic>> getSubjectsRaw() => _getListRaw('/subjects');

  static Future<List<Subject>> getSubjects() async =>
      (await getSubjectsRaw()).map((e) => Subject.fromJson(e)).toList();

  static Future<Subject> createSubject({
    required String name,
    required String description,
    required String color,
    required String icon,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/subject'),
      headers: _headers,
      body: jsonEncode({
        'name': name,
        'description': description,
        'color': color,
        'icon': icon,
      }),
    );
    if (res.statusCode == 201) return Subject.fromJson(jsonDecode(res.body));
    throw Exception('Failed to create subject (${res.statusCode})');
  }

  static Future<Subject> updateSubject({
    required int id,
    String? name,
    String? description,
    String? color,
    String? icon,
  }) async {
    final body = <String, dynamic>{'id': id};
    if (name != null) body['name'] = name;
    if (description != null) body['description'] = description;
    if (color != null) body['color'] = color;
    if (icon != null) body['icon'] = icon;

    final res = await http.put(
      Uri.parse('$baseUrl/subject'),
      headers: _headers,
      body: jsonEncode(body),
    );
    if (res.statusCode == 200) return Subject.fromJson(jsonDecode(res.body));
    throw Exception('Failed to update subject (${res.statusCode})');
  }

  static Future<void> deleteSubject(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/subject/$id'));
    if (res.statusCode != 200) {
      throw Exception('Failed to delete subject (${res.statusCode})');
    }
  }

  // ---------------- Topics ----------------

  static Future<List<dynamic>> getTopicsBySubjectRaw(int subjectId) =>
      _getListRaw('/topic/by-subject/$subjectId');

  static Future<List<Topic>> getTopicsBySubject(int subjectId) async =>
      (await getTopicsBySubjectRaw(subjectId)).map((e) => Topic.fromJson(e)).toList();

  static Future<Topic> createTopic({
    required int subjectId,
    required String title,
    required String description,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/topic'),
      headers: _headers,
      body: jsonEncode({
        'subject_id': subjectId,
        'title': title,
        'description': description,
      }),
    );
    if (res.statusCode == 201) return Topic.fromJson(jsonDecode(res.body));
    throw Exception('Failed to create topic (${res.statusCode})');
  }

  static Future<Topic> updateTopic({
    required int id,
    int? subjectId,
    String? title,
    String? description,
  }) async {
    final body = <String, dynamic>{'id': id};
    if (subjectId != null) body['subject_id'] = subjectId;
    if (title != null) body['title'] = title;
    if (description != null) body['description'] = description;

    final res = await http.put(
      Uri.parse('$baseUrl/topic'),
      headers: _headers,
      body: jsonEncode(body),
    );
    if (res.statusCode == 200) return Topic.fromJson(jsonDecode(res.body));
    throw Exception('Failed to update topic (${res.statusCode})');
  }

  static Future<void> deleteTopic(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/topic/$id'));
    if (res.statusCode != 200) {
      throw Exception('Failed to delete topic (${res.statusCode})');
    }
  }

  // ---------------- Questions ----------------

  static Future<List<dynamic>> getQuestionsByTopicRaw(int topicId) =>
      _getListRaw('/question/by-topic/$topicId');

  static Future<List<Question>> getQuestionsByTopic(int topicId) async =>
      (await getQuestionsByTopicRaw(topicId)).map((e) => Question.fromJson(e)).toList();

  static Future<Question> createQuestion({
    required int topicId,
    required String prompt,
    required String type,
    required List<String> options,
    required int correctOptionIndex,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/question'),
      headers: _headers,
      body: jsonEncode({
        'topic_id': topicId,
        'prompt': prompt,
        'type': type,
        'options': options,
        'correct_option_index': correctOptionIndex,
      }),
    );
    if (res.statusCode == 201) return Question.fromJson(jsonDecode(res.body));
    throw Exception('Failed to create question (${res.statusCode})');
  }

  static Future<Question> updateQuestion({
    required int id,
    int? topicId,
    String? prompt,
    String? type,
    List<String>? options,
    int? correctOptionIndex,
  }) async {
    final body = <String, dynamic>{'id': id};
    if (topicId != null) body['topic_id'] = topicId;
    if (prompt != null) body['prompt'] = prompt;
    if (type != null) body['type'] = type;
    if (options != null) body['options'] = options;
    if (correctOptionIndex != null) body['correct_option_index'] = correctOptionIndex;

    final res = await http.put(
      Uri.parse('$baseUrl/question'),
      headers: _headers,
      body: jsonEncode(body),
    );
    if (res.statusCode == 200) return Question.fromJson(jsonDecode(res.body));
    throw Exception('Failed to update question (${res.statusCode})');
  }

  static Future<void> deleteQuestion(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/question/$id'));
    if (res.statusCode != 200) {
      throw Exception('Failed to delete question (${res.statusCode})');
    }
  }

  static Future<Map<String, dynamic>> createSubjectRaw({
  required String name,
  required String description,
  required String color,
  required String icon,
}) async {
  final res = await http.post(
    Uri.parse('$baseUrl/subject'),
    headers: _headers,
    body: jsonEncode({'name': name, 'description': description, 'color': color, 'icon': icon}),
  );
  if (res.statusCode == 201) return jsonDecode(res.body);
  throw Exception('Failed to create subject (${res.statusCode})');
}

static Future<Map<String, dynamic>> createTopicRaw({
  required int subjectId,
  required String title,
  required String description,
}) async {
  final res = await http.post(
    Uri.parse('$baseUrl/topic'),
    headers: _headers,
    body: jsonEncode({'subject_id': subjectId, 'title': title, 'description': description}),
  );
  if (res.statusCode == 201) return jsonDecode(res.body);
  throw Exception('Failed to create topic (${res.statusCode})');
}

static Future<Map<String, dynamic>> createQuestionRaw({
  required int topicId,
  required String prompt,
  required String type,
  required List<String> options,
  required int correctOptionIndex,
}) async {
  final res = await http.post(
    Uri.parse('$baseUrl/question'),
    headers: _headers,
    body: jsonEncode({
      'topic_id': topicId, 'prompt': prompt, 'type': type,
      'options': options, 'correct_option_index': correctOptionIndex,
    }),
  );
  if (res.statusCode == 201) return jsonDecode(res.body);
  throw Exception('Failed to create question (${res.statusCode})');
}
}

