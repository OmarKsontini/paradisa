import 'api_service.dart';
import 'connectivity_service.dart';
import 'local_store.dart';

class SyncService {
  static bool _syncing = false;

  static Future<void> syncAll() async {
    if (_syncing) return;
    _syncing = true;
    try {
      if (!await ConnectivityService.isOnline()) return;

      // 1. Push pending creates — subjects first, since topics/questions
      //    may reference a subject's/topic's real id once it exists.
      for (final s in await LocalStore.getPendingSubjects()) {
        try {
          final real = await ApiService.createSubjectRaw(
            name: s['name'], description: s['description'],
            color: s['color'], icon: s['icon'],
          );
          await LocalStore.replaceSubject(s['id'], real);
        } catch (_) {
          // still offline or request failed — leave pending, retry next sync
        }
      }

      for (final t in await LocalStore.getPendingTopics()) {
        try {
          final real = await ApiService.createTopicRaw(
            subjectId: t['subject_id'], title: t['title'], description: t['description'],
          );
          await LocalStore.replaceTopic(t['id'], real);
        } catch (_) {}
      }

      for (final q in await LocalStore.getPendingQuestions()) {
        try {
          final real = await ApiService.createQuestionRaw(
            topicId: q['topic_id'], prompt: q['prompt'], type: q['type'],
            options: List<String>.from(q['options']),
            correctOptionIndex: q['correct_option_index'],
          );
          await LocalStore.replaceQuestion(q['id'], real);
        } catch (_) {}
      }

      // 2. Pull the full fresh dataset from the server and merge it in,
      //    keeping anything still pending (e.g. if a later step above failed).
      final subjects = await ApiService.getSubjectsRaw();
      await LocalStore.mergeServerSubjects(subjects);

      final allTopics = <dynamic>[];
      for (final s in subjects) {
        allTopics.addAll(await ApiService.getTopicsBySubjectRaw(s['id']));
      }
      await LocalStore.mergeServerTopics(allTopics);

      final allQuestions = <dynamic>[];
      for (final t in allTopics) {
        allQuestions.addAll(await ApiService.getQuestionsByTopicRaw(t['id']));
      }
      await LocalStore.mergeServerQuestions(allQuestions);
    } finally {
      _syncing = false;
    }
  }
}