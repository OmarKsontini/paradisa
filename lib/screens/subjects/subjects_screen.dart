import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/subject.dart';
import '../../services/api_service.dart';
import '../../services/archive_service.dart';
import '../../services/local_store.dart';
import '../../services/sync_service.dart';
import '../../theme/app_theme.dart';
import '../archive/archive_screen.dart';
import '../settings/settings_screen.dart';
import '../topics/topics_screen.dart';
import 'widgets/subject_card.dart';
import 'widgets/subject_form_dialog.dart';
import 'widgets/archive_button.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  List<Subject> subjects = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final all = await LocalStore.getSubjects();
    final archivedIds = await ArchiveService.getArchivedSubjectIds();
    if (!mounted) return;
    setState(() {
      subjects = all.where((s) => !archivedIds.contains(s.id)).toList();
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
      builder: (context) => const SubjectFormDialog(),
    );
    if (result == null) return;
    await LocalStore.addPendingSubject(
      name: result['name']!, description: result['description']!,
      color: result['color']!, icon: result['icon']!,
    );
    await _load();
    unawaited(_refresh());
  }

  Future<void> _openEditDialog(Subject subject) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => SubjectFormDialog(subject: subject),
    );
    if (result == null) return;
    await ApiService.updateSubject(
      id: subject.id, name: result['name'], description: result['description'],
      color: result['color'], icon: result['icon'],
    );
    _refresh();
  }

  Future<void> _confirmDelete(Subject subject) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Delete subject?', style: TextStyle(color: AppTheme.textPrimary)),
        content: Text('This will also delete all topics and questions under "${subject.name}".',
            style: const TextStyle(color: AppTheme.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete', style: TextStyle(color: AppTheme.error))),
        ],
      ),
    );
    if (confirmed == true) {
      await ApiService.deleteSubject(subject.id);
      _refresh();
    }
  }

  Future<void> _confirmArchive(Subject subject) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Mark as done?', style: TextStyle(color: AppTheme.textPrimary)),
        content: Text('"${subject.name}" will move to your Archive. You can restore it anytime.',
            style: const TextStyle(color: AppTheme.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true),
              child: const Text('Done', style: TextStyle(color: AppTheme.success))),
        ],
      ),
    );
    if (confirmed == true) {
      await ArchiveService.archiveSubject(subject.id);
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subjects'),
        actions: [
          const ArchiveButton(),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const SettingsScreen())),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.accent,
        onPressed: _openAddDialog,
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : subjects.isEmpty
              ? const Center(
                  child: Text('No subjects yet. Tap + to add one.',
                      style: TextStyle(color: AppTheme.textSecondary)))
              : RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                    itemCount: subjects.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final subject = subjects[index];
                      return SubjectCard(
                        subject: subject,
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => TopicsScreen(subject: subject))),
                        onEdit: () => _openEditDialog(subject),
                        onDelete: () => _confirmDelete(subject),
                        onArchive: () => _confirmArchive(subject),
                      );
                    },
                  ),
                ),
    );
  }
}