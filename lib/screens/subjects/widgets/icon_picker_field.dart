import 'package:flutter/material.dart';
import '../../../models/subject.dart';
import '../../../theme/app_theme.dart';

class IconPickerField extends StatelessWidget {
  final String selectedKey;
  final Color accentColor;
  final ValueChanged<String> onChanged;

  const IconPickerField({
    super.key,
    required this.selectedKey,
    required this.accentColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Icon',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: iconMap.entries.map((entry) {
            final isSelected = entry.key == selectedKey;
            return GestureDetector(
              onTap: () => onChanged(entry.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected ? accentColor.withOpacity(0.15) : AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? accentColor : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Icon(
                  entry.value,
                  color: isSelected ? accentColor : AppTheme.textSecondary,
                  size: 24,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}