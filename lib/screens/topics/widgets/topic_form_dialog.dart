import 'package:flutter/material.dart';
import '../../../models/topic.dart';
import '../../../theme/app_theme.dart';

class TopicFormDialog extends StatefulWidget {
  final Topic? topic;

  const TopicFormDialog({super.key, this.topic});

  @override
  State<TopicFormDialog> createState() => _TopicFormDialogState();
}

class _TopicFormDialogState extends State<TopicFormDialog> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.topic?.title ?? '');
    descriptionController = TextEditingController(text: widget.topic?.description ?? '');
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.topic != null;
    return AlertDialog(
      backgroundColor: AppTheme.surface,
      title: Text(isEditing ? 'Edit Topic' : 'New Topic',
          style: const TextStyle(color: AppTheme.textPrimary)),
      content: SizedBox(
        width: 340,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: AppTheme.space16),
            TextField(
              controller: descriptionController,
              style: const TextStyle(color: AppTheme.textPrimary),
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        TextButton(
          onPressed: () {
            if (titleController.text.trim().isEmpty) return;
            Navigator.pop(context, {
              'title': titleController.text.trim(),
              'description': descriptionController.text.trim(),
            });
          },
          child: Text(isEditing ? 'Save' : 'Create'),
        ),
      ],
    );
  }
}