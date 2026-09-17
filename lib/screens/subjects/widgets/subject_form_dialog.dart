import 'package:flutter/material.dart';
import '../../../models/subject.dart';
import '../../../theme/app_theme.dart';
import 'color_picker_field.dart';
import 'icon_picker_field.dart';

class SubjectFormDialog extends StatefulWidget {
  final Subject? subject;

  const SubjectFormDialog({super.key, this.subject});

  @override
  State<SubjectFormDialog> createState() => _SubjectFormDialogState();
}

class _SubjectFormDialogState extends State<SubjectFormDialog> {
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late String selectedColorHex;
  late String selectedIcon;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.subject?.name ?? '');
    descriptionController = TextEditingController(text: widget.subject?.description ?? '');
    selectedColorHex = widget.subject != null
        ? '#${widget.subject!.color.value.toRadixString(16).substring(2).toUpperCase()}'
        : subjectColorPalette.first;
    selectedIcon = widget.subject != null
        ? iconMap.entries
            .firstWhere((e) => e.value == widget.subject!.icon, orElse: () => iconMap.entries.first)
            .key
        : iconMap.keys.first;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.subject != null;
    return AlertDialog(
      backgroundColor: AppTheme.surface,
      title: Text(isEditing ? 'Edit Subject' : 'New Subject',
          style: const TextStyle(color: AppTheme.textPrimary)),
      content: SizedBox(
        width: 340,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: AppTheme.space16),
              TextField(
                controller: descriptionController,
                style: const TextStyle(color: AppTheme.textPrimary),
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: AppTheme.space20),
              ColorPickerField(
                selectedHex: selectedColorHex,
                onChanged: (hex) => setState(() => selectedColorHex = hex),
              ),
              const SizedBox(height: AppTheme.space20),
              IconPickerField(
                selectedKey: selectedIcon,
                accentColor: colorFromHex(selectedColorHex),
                onChanged: (key) => setState(() => selectedIcon = key),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        TextButton(
          onPressed: () {
            if (nameController.text.trim().isEmpty) return;
            Navigator.pop(context, {
              'name': nameController.text.trim(),
              'description': descriptionController.text.trim(),
              'color': selectedColorHex,
              'icon': selectedIcon,
            });
          },
          child: Text(isEditing ? 'Save' : 'Create'),
        ),
      ],
    );
  }
}