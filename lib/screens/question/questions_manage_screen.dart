import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/topic.dart';
import '../../models/question.dart';
import '../../services/api_service.dart';
import '../../services/local_store.dart';
import '../../services/sync_service.dart';
import '../../theme/app_theme.dart';
import 'widgets/question_form_dialog.dart';

class QuestionsManageScreen extends StatefulWidget {
  final Topic topic;
  final Color accentColor;

  const QuestionsManageScreen({super.key, required this.topic, required this.accentColor});

  @override
  State<QuestionsManageScreen> createState() => _QuestionsManageScreenState();
}

class _QuestionsManageScreenState extends State<QuestionsManageScreen> {
  List<Question> questions = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await LocalStore.getQuestionsByTopic(widget.topic.id);
    if (!mounted) return;
    setState(() {
      questions = list;
      loading = false;
    });
  }

  Future<void> _refresh() async {
    await SyncService.syncAll();
    await _load();
  }

  Future<void> _openAddDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const QuestionFormDialog(),
    );
    if (result == null) return;
    await LocalStore.addPendingQuestion(
      topicId: widget.topic.id,
      prompt: result['prompt'],
      type: result['type'],
      options: List<String>.from(result['options']),
      correctOptionIndex: result['correctOptionIndex'],
    );
    await _load();
    unawaited(_refresh());
  }

  Future<void> _openEditDialog(Question question) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => QuestionFormDialog(question: question),
    );
    if (result == null) return;
    await ApiService.updateQuestion(
      id: question.id,
      prompt: result['prompt'],
      type: result['type'],
      options: List<String>.from(result['options']),
      correctOptionIndex: result['correctOptionIndex'],
    );
    _refresh();
  }

  Future<void> _confirmDelete(Question question) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Delete question?', style: TextStyle(color: AppTheme.textPrimary)),
        content:
            const Text('This cannot be undone.', style: TextStyle(color: AppTheme.textSecondary)),
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
      await ApiService.deleteQuestion(question.id);
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.topic.title} — Questions')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: widget.accentColor,
        onPressed: _openAddDialog,
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : questions.isEmpty
              ? const Center(
                  child: Text('No questions yet. Tap + to add one.',
                      style: TextStyle(color: AppTheme.textSecondary)))
              : RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                    itemCount: questions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final question = questions[index];
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.surfaceLight),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(question.prompt,
                                  style:
                                      const TextStyle(color: AppTheme.textPrimary, fontSize: 14)),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined,
                                  color: AppTheme.textSecondary, size: 20),
                              onPressed: () => _openEditDialog(question),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: AppTheme.error, size: 20),
                              onPressed: () => _confirmDelete(question),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}