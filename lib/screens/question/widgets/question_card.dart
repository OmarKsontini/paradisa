import 'package:flutter/material.dart';
import '../../../models/question.dart';
import '../../../theme/app_theme.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  final int? selectedIndex;
  final int? revealedCorrectIndex;
  final Color accentColor;
  final void Function(int) onSelect;

  const QuestionCard({
    super.key,
    required this.question,
    required this.selectedIndex,
    required this.revealedCorrectIndex,
    required this.accentColor,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.prompt,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 24),
        for (int i = 0; i < question.options.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _OptionTile(
              text: question.options[i],
              isSelected: selectedIndex == i,
              isCorrect: revealedCorrectIndex != null &&
                  i == question.correctOptionIndex,
              isWrong: revealedCorrectIndex != null &&
                  selectedIndex == i &&
                  i != question.correctOptionIndex,
              accentColor: accentColor,
              onTap: revealedCorrectIndex == null ? () => onSelect(i) : null,
            ),
          ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final Color accentColor;
  final VoidCallback? onTap;

  const _OptionTile({
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.isWrong,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = AppTheme.surfaceLight;
    Color bgColor = AppTheme.surface;

    if (isCorrect) {
      borderColor = AppTheme.success;
      bgColor = AppTheme.success.withOpacity(0.12);
    } else if (isWrong) {
      borderColor = AppTheme.error;
      bgColor = AppTheme.error.withOpacity(0.12);
    } else if (isSelected) {
      borderColor = accentColor;
      bgColor = accentColor.withOpacity(0.12);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
      ),
    );
  }
}