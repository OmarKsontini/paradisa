import 'package:flutter/material.dart';
import '../../../models/question.dart';
import '../../../theme/app_theme.dart';

class QuestionFormDialog extends StatefulWidget {
  final Question? question; // null = create mode

  const QuestionFormDialog({super.key, this.question});

  @override
  State<QuestionFormDialog> createState() => _QuestionFormDialogState();
}

class _QuestionFormDialogState extends State<QuestionFormDialog> {
  late final TextEditingController promptController;
  late QuestionType selectedType;
  late List<TextEditingController> optionControllers;
  late int correctIndex;

  @override
  void initState() {
    super.initState();
    promptController = TextEditingController(text: widget.question?.prompt ?? '');
    selectedType = widget.question?.type ?? QuestionType.multipleChoice;
    optionControllers = (widget.question?.options ?? ['', ''])
        .map((o) => TextEditingController(text: o))
        .toList();
    correctIndex = widget.question?.correctOptionIndex ?? 0;
  }

  @override
  void dispose() {
    promptController.dispose();
    for (final c in optionControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _setType(QuestionType type) {
    setState(() {
      selectedType = type;
      if (type == QuestionType.trueFalse) {
        for (final c in optionControllers) {
          c.dispose();
        }
        optionControllers = [
          TextEditingController(text: 'True'),
          TextEditingController(text: 'False'),
        ];
        correctIndex = 0;
      }
    });
  }

  void _addOption() {
    setState(() => optionControllers.add(TextEditingController()));
  }

  void _removeOption(int index) {
    if (optionControllers.length <= 2) return;
    setState(() {
      optionControllers.removeAt(index).dispose();
      if (correctIndex >= optionControllers.length) correctIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.question != null;
    return AlertDialog(
      backgroundColor: AppTheme.surface,
      title: Text(isEditing ? 'Edit Question' : 'New Question',
          style: const TextStyle(color: AppTheme.textPrimary)),
      content: SizedBox(
        width: 360,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: promptController,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(labelText: 'Prompt'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<QuestionType>(
                initialValue: selectedType,
                dropdownColor: AppTheme.surface,
                style: const TextStyle(color: AppTheme.textPrimary),
                items: const [
                  DropdownMenuItem(value: QuestionType.multipleChoice, child: Text('Multiple choice')),
                  DropdownMenuItem(value: QuestionType.trueFalse, child: Text('True / False')),
                ],
                onChanged: (value) => _setType(value!),
                decoration: const InputDecoration(labelText: 'Type'),
              ),
              const SizedBox(height: 12),
              const Text('Options (tap the circle for the correct one)',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              for (int i = 0; i < optionControllers.length; i++)
                Row(
                  children: [
                    Radio<int>(
                      value: i,
                      groupValue: correctIndex,
                      activeColor: AppTheme.success,
                      onChanged: (value) => setState(() => correctIndex = value!),
                    ),
                    Expanded(
                      child: TextField(
                        controller: optionControllers[i],
                        enabled: selectedType == QuestionType.multipleChoice,
                        style: const TextStyle(color: AppTheme.textPrimary),
                        decoration: InputDecoration(labelText: 'Option ${i + 1}'),
                      ),
                    ),
                    if (selectedType == QuestionType.multipleChoice && optionControllers.length > 2)
                      IconButton(
                        icon: const Icon(Icons.close, size: 18, color: AppTheme.textSecondary),
                        onPressed: () => _removeOption(i),
                      ),
                  ],
                ),
              if (selectedType == QuestionType.multipleChoice)
                TextButton.icon(
                  onPressed: _addOption,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add option'),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        TextButton(
          onPressed: () {
            final options = optionControllers.map((c) => c.text.trim()).toList();
            if (promptController.text.trim().isEmpty || options.any((o) => o.isEmpty)) return;
            Navigator.pop(context, {
              'prompt': promptController.text.trim(),
              'type': questionTypeToString(selectedType),
              'options': options,
              'correctOptionIndex': correctIndex,
            });
          },
          child: Text(isEditing ? 'Save' : 'Create'),
        ),
      ],
    );
  }
}