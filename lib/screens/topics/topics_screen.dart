import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/subject.dart';
import '../../models/topic.dart';
import '../../services/api_service.dart';
import '../../services/archive_service.dart';
import '../../services/local_store.dart';
import '../../services/sync_service.dart';
import '../../theme/app_theme.dart';
import '../question/question_screen.dart';
import '../question/questions_manage_screen.dart';
import 'widgets/topic_card.dart';
import 'widgets/topic_form_dialog.dart';

class TopicsScreen extends StatefulWidget {
  final Subject subject;

  const TopicsScreen({super.key, required this.subject});

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  List<Topic> topics = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final all = await LocalStore.getTopicsBySubject(widget.subject.id);
    final archivedIds = await ArchiveService.getArchivedTopicIds();
    if (!mounted) return;
    setState(() {
      topics = all.where((t) => !archivedIds.contains(t.id)).toList();
      loading = false;
    });
  }

  Future<void> _refresh() async {
    await SyncService.syncAll();
    await _load();
  }

  Future<void> _openAddDialog() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const TopicFormDialog(),
    );
    if (result == null) return;
    await LocalStore.addPendingTopic(
      subjectId: widget.subject.id,
      title: result['title']!,
      description: result['description']!,
    );
    await _load();
    unawaited(_refresh());
  }

  Future<void> _openEditDialog(Topic topic) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => TopicFormDialog(topic: topic),
    );
    if (result == null) return;
    await ApiService.updateTopic(
      id: topic.id,
      title: result['title'],
      description: result['description'],
    );
    _refresh();
  }

  Future<void> _confirmDelete(Topic topic) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Delete topic?', style: TextStyle(color: AppTheme.textPrimary)),
        content: Text(
          'This will also delete all questions under "${topic.title}".',
          style: const TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ApiService.deleteTopic(topic.id);
      _refresh();
    }
  }

  Future<void> _confirmArchive(Topic topic) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Mark as done?', style: TextStyle(color: AppTheme.textPrimary)),
        content: Text('"${topic.title}" will move to your Archive. You can restore it anytime.',
            style: const TextStyle(color: AppTheme.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true),
              child: const Text('Done', style: TextStyle(color: AppTheme.success))),
        ],
      ),
    );
    if (confirmed == true) {
      await ArchiveService.archiveTopic(topic.id);
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.subject.name)),
      floatingActionButton: FloatingActionButton(
        backgroundColor: widget.subject.color,
        onPressed: _openAddDialog,
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : topics.isEmpty
              ? const Center(
                  child: Text('No topics yet. Tap + to add one.',
                      style: TextStyle(color: AppTheme.textSecondary)))
              : RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                    itemCount: topics.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final topic = topics[index];
                      return TopicCard(
                        topic: topic,
                        accentColor: widget.subject.color,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  QuestionScreen(topic: topic, accentColor: widget.subject.color),
                            ),
                          );
                        },
                        onEdit: () => _openEditDialog(topic),
                        onDelete: () => _confirmDelete(topic),
                        onArchive: () => _confirmArchive(topic),
                        onManageQuestions: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => QuestionsManageScreen(
                                  topic: topic, accentColor: widget.subject.color),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
    );
  }
}