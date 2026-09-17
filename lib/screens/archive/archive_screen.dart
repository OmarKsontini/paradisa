import 'package:flutter/material.dart';
import '../../models/subject.dart';
import '../../models/topic.dart';
import '../../services/archive_service.dart';
import '../../services/local_store.dart';
import '../../theme/app_theme.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  List<Subject> archivedSubjects = [];
  List<Topic> archivedTopics = [];
  Map<int, Subject> subjectById = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final allSubjects = await LocalStore.getSubjects();
    final allTopics = await LocalStore.getAllTopics();
    final archivedSubjectIds = await ArchiveService.getArchivedSubjectIds();
    final archivedTopicIds = await ArchiveService.getArchivedTopicIds();
    

    if (!mounted) return;
    setState(() {
      subjectById = {for (final s in allSubjects) s.id: s};
      archivedSubjects = allSubjects.where((s) => archivedSubjectIds.contains(s.id)).toList();
      archivedTopics = allTopics.where((t) => archivedTopicIds.contains(t.id)).toList();
      loading = false;
    });
  }

  Future<void> _restoreSubject(Subject subject) async {
    await ArchiveService.unarchiveSubject(subject.id);
    _load();
  }



  Future<void> _restoreTopic(Topic topic) async {
    await ArchiveService.unarchiveTopic(topic.id);
    _load();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Archive')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : (archivedSubjects.isEmpty && archivedTopics.isEmpty)
              ? const Center(
                  child: Text('Nothing archived yet.',
                      style: TextStyle(color: AppTheme.textSecondary)))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (archivedSubjects.isNotEmpty) ...[
                      const Text('Subjects',
                          style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      for (final subject in archivedSubjects)
                        _ArchivedTile(
                          color: subject.color,
                          icon: subject.icon,
                          title: subject.name,
                          subtitle: subject.description,
                          onRestore: () => _restoreSubject(subject),
                        ),
                      const SizedBox(height: 20),
                    ],
                    if (archivedTopics.isNotEmpty) ...[
                      const Text('Topics',
                          style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      for (final topic in archivedTopics)
                        _ArchivedTile(
                          color: subjectById[topic.subjectId]?.color ?? AppTheme.accent,
                          icon: Icons.topic_outlined,
                          title: topic.title,
                          subtitle: topic.description,
                          onRestore: () => _restoreTopic(topic),
                        ),
                    ],
                  ],
                ),
    );
  }
}

class _ArchivedTile extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onRestore;

  const _ArchivedTile({
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onRestore,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceLight),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: AppTheme.textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.unarchive_outlined, color: AppTheme.accent, size: 20),
            tooltip: 'Restore',
            onPressed: onRestore,
          ),
        ],
      ),
    );
  }
}