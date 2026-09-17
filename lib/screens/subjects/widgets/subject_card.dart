import 'package:flutter/material.dart';
import '../../../models/subject.dart';
import '../../../theme/app_theme.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onArchive;

  const SubjectCard({
    super.key,
    required this.subject,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onArchive,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.space16),
        decoration: AppTheme.cardDecoration(accentGlow: subject.color),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: subject.color.withOpacity(0.16),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall + 4),
              ),
              child: Icon(subject.icon, color: subject.color, size: 26),
            ),
            const SizedBox(width: AppTheme.space16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subject.name, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 3),
                  Text(
                    subject.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
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