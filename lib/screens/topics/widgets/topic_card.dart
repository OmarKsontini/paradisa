import 'package:flutter/material.dart';
import '../../../models/topic.dart';
import '../../../theme/app_theme.dart';

class TopicCard extends StatelessWidget {
  final Topic topic;
  final Color accentColor;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onManageQuestions;
  final VoidCallback onArchive;

  const TopicCard({
    super.key,
    required this.topic,
    required this.accentColor,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onManageQuestions,
    required this.onArchive,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.space16),
        decoration: AppTheme.cardDecoration(accentGlow: accentColor),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 40,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: AppTheme.space16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(topic.title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 3),
                  Text(
                    topic.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.quiz_outlined, color: AppTheme.textSecondary, size: 20),
              tooltip: 'Manage questions',
              onPressed: onManageQuestions,
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppTheme.textMuted, size: 20),
              color: AppTheme.surfaceElevated,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusSmall)),
              onSelected: (value) {
                if (value == 'edit') onEdit();
                if (value == 'delete') onDelete();
                if (value == 'archive') onArchive();
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'archive',
                  child: Row(children: [
                    Icon(Icons.check_circle_outline, size: 18, color: AppTheme.success),
                    SizedBox(width: 10),
                    Text('Mark as done'),
                  ]),
                ),
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(children: [
                    Icon(Icons.edit_outlined, size: 18, color: AppTheme.textSecondary),
                    SizedBox(width: 10),
                    Text('Edit'),
                  ]),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(children: [
                    Icon(Icons.delete_outline, size: 18, color: AppTheme.error),
                    SizedBox(width: 10),
                    Text('Delete'),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}