import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ArchiveService {
  static const _subjectsKey = 'archived_subject_ids';
  static const _topicsKey = 'archived_topic_ids';

  static Future<Set<int>> _getSet(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null) return {};
    return (jsonDecode(raw) as List).cast<int>().toSet();
  }

  static Future<void> _saveSet(String key, Set<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(ids.toList()));
  }

  static Future<Set<int>> getArchivedSubjectIds() => _getSet(_subjectsKey);
  static Future<Set<int>> getArchivedTopicIds() => _getSet(_topicsKey);

  static Future<void> archiveSubject(int id) async {
    final ids = await getArchivedSubjectIds();
    ids.add(id);
    await _saveSet(_subjectsKey, ids);
  }

  static Future<void> unarchiveSubject(int id) async {
    final ids = await getArchivedSubjectIds();
    ids.remove(id);
    await _saveSet(_subjectsKey, ids);
  }

  static Future<void> archiveTopic(int id) async {
    final ids = await getArchivedTopicIds();
    ids.add(id);
    await _saveSet(_topicsKey, ids);
  }

  static Future<void> unarchiveTopic(int id) async {
    final ids = await getArchivedTopicIds();
    ids.remove(id);
    await _saveSet(_topicsKey, ids);
  }
  
  static Future<int> getTotalArchivedCount() async {
  final subjects = await getArchivedSubjectIds();
  final topics = await getArchivedTopicIds();
  return subjects.length + topics.length;
}
}