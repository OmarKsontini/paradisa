import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

const List<String> subjectColorPalette = [
  '#4A90D9', // blue
  '#2ECC71', // green
  '#E67E22', // orange
  '#9B59B6', // purple
  '#E74C3C', // red
  '#00B894', // teal
  '#F1C40F', // yellow
  '#6C5CE7', // indigo
  '#FF6B9D', // pink
  '#1ABC9C', // turquoise
  '#E84393', // magenta
  '#95A5A6', // grey
];

class ColorPickerField extends StatelessWidget {
  final String selectedHex;
  final ValueChanged<String> onChanged;

  const ColorPickerField({
    super.key,
    required this.selectedHex,
    required this.onChanged,
  });

  Color _fromHex(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Color',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: subjectColorPalette.map((hex) {
            final isSelected = hex.toUpperCase() == selectedHex.toUpperCase();
            final color = _fromHex(hex);
            return GestureDetector(
              onTap: () => onChanged(hex),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.transparent,
                    width: 2.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: color.withOpacity(0.6),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}