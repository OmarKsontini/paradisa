import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/subject.dart';
import '../models/topic.dart';
import '../models/question.dart';

class LocalStore {
  static const _subjectsKey = 'local_all_subjects';
  static const _topicsKey = 'local_all_topics';
  static const _questionsKey = 'local_all_questions';
  static const _tempCounterKey = 'local_temp_id_counter';

  static Future<List<Map<String, dynamic>>> _readList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null) return [];
    return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
  }

  static Future<void> _writeList(String key, List<Map<String, dynamic>> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(list));
  }

  static Future<int> _nextTempId() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_tempCounterKey) ?? 0;
    final next = current - 1; // -1, -2, -3 ... never collides with real positive DB ids
    await prefs.setInt(_tempCounterKey, next);
    return next;
  }

  // ---------------- Reads (fully offline-capable) ----------------

  static Future<List<Subject>> getSubjects() async =>
      (await _readList(_subjectsKey)).map((e) => Subject.fromJson(e)).toList();

  static Future<List<Topic>> getTopicsBySubject(int subjectId) async =>
      (await _readList(_topicsKey))
          .where((e) => e['subject_id'] == subjectId)
          .map((e) => Topic.fromJson(e))
          .toList();
  static Future<List<Topic>> getAllTopics() async =>
    (await _readList(_topicsKey)).map((e) => Topic.fromJson(e)).toList();
  
  static Future<List<Question>> getQuestionsByTopic(int topicId) async =>
      (await _readList(_questionsKey))
          .where((e) => e['topic_id'] == topicId)
          .map((e) => Question.fromJson(e))
          .toList();

  // ---------------- Merge fresh server data (keeps unsynced pending items) ----------------

  static Future<void> mergeServerSubjects(List<dynamic> serverData) async {
    final pending = (await _readList(_subjectsKey)).where((e) => e['_pending'] == true);
    await _writeList(_subjectsKey, [...serverData.cast<Map<String, dynamic>>(), ...pending]);
  }

  static Future<void> mergeServerTopics(List<dynamic> serverData) async {
    final pending = (await _readList(_topicsKey)).where((e) => e['_pending'] == true);
    await _writeList(_topicsKey, [...serverData.cast<Map<String, dynamic>>(), ...pending]);
  }

  static Future<void> mergeServerQuestions(List<dynamic> serverData) async {
    final pending = (await _readList(_questionsKey)).where((e) => e['_pending'] == true);
    await _writeList(_questionsKey, [...serverData.cast<Map<String, dynamic>>(), ...pending]);
  }

  // ---------------- Offline creates ----------------

  static Future<Subject> addPendingSubject({
    required String name,
    required String description,
    required String color,
    required String icon,
  }) async {
    final id = await _nextTempId();
    final map = {
      'id': id, 'name': name, 'description': description,
      'color': color, 'icon': icon,
      'created_at': DateTime.now().toIso8601String(), '_pending': true,
    };
    final list = await _readList(_subjectsKey);
    list.add(map);
    await _writeList(_subjectsKey, list);
    return Subject.fromJson(map);
  }

  static Future<Topic> addPendingTopic({
    required int subjectId,
    required String title,
    required String description,
  }) async {
    final id = await _nextTempId();
    final map = {
      'id': id, 'subject_id': subjectId, 'title': title, 'description': description,
      'created_at': DateTime.now().toIso8601String(), '_pending': true,
    };
    final list = await _readList(_topicsKey);
    list.add(map);
    await _writeList(_topicsKey, list);
    return Topic.fromJson(map);
  }

  static Future<Question> addPendingQuestion({
    required int topicId,
    required String prompt,
    required String type,
    required List<String> options,
    required int correctOptionIndex,
  }) async {
    final id = await _nextTempId();
    final map = {
      'id': id, 'topic_id': topicId, 'prompt': prompt, 'type': type,
      'options': options, 'correct_option_index': correctOptionIndex,
      'created_at': DateTime.now().toIso8601String(), '_pending': true,
    };
    final list = await _readList(_questionsKey);
    list.add(map);
    await _writeList(_questionsKey, list);
    return Question.fromJson(map);
  }

  // ---------------- Used by SyncService ----------------

  static Future<List<Map<String, dynamic>>> getPendingSubjects() async =>
      (await _readList(_subjectsKey)).where((e) => e['_pending'] == true).toList();

  static Future<List<Map<String, dynamic>>> getPendingTopics() async =>
      (await _readList(_topicsKey)).where((e) => e['_pending'] == true).toList();

  static Future<List<Map<String, dynamic>>> getPendingQuestions() async =>
      (await _readList(_questionsKey)).where((e) => e['_pending'] == true).toList();

  static Future<void> replaceSubject(int tempId, Map<String, dynamic> real) async {
    final list = await _readList(_subjectsKey);
    list.removeWhere((e) => e['id'] == tempId);
    list.add(real);
    await _writeList(_subjectsKey, list);

    final topics = await _readList(_topicsKey);
    for (final t in topics) {
      if (t['subject_id'] == tempId) t['subject_id'] = real['id'];
    }
    await _writeList(_topicsKey, topics);
  }

  static Future<void> replaceTopic(int tempId, Map<String, dynamic> real) async {
    final list = await _readList(_topicsKey);
    list.removeWhere((e) => e['id'] == tempId);
    list.add(real);
    await _writeList(_topicsKey, list);

    final questions = await _readList(_questionsKey);
    for (final q in questions) {
      if (q['topic_id'] == tempId) q['topic_id'] = real['id'];
    }
    await _writeList(_questionsKey, questions);
  }

  static Future<void> replaceQuestion(int tempId, Map<String, dynamic> real) async {
    final list = await _readList(_questionsKey);
    list.removeWhere((e) => e['id'] == tempId);
    list.add(real);
    await _writeList(_questionsKey, list);
  }

  static Future<int> pendingCount() async {
    return (await getPendingSubjects()).length +
        (await getPendingTopics()).length +
        (await getPendingQuestions()).length;
  }
}