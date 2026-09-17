import 'package:flutter/material.dart';
import '../../../services/archive_service.dart';
import '../../../theme/app_theme.dart';
import '../../archive/archive_screen.dart';

class ArchiveButton extends StatefulWidget {
  const ArchiveButton({super.key});

  @override
  State<ArchiveButton> createState() => _ArchiveButtonState();
}

class _ArchiveButtonState extends State<ArchiveButton> {
  int count = 0;

  @override
  void initState() {
    super.initState();
    _loadCount();
  }

  Future<void> _loadCount() async {
    final c = await ArchiveService.getTotalArchivedCount();
    if (!mounted) return;
    setState(() => count = c);
  }

  Future<void> _open() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ArchiveScreen()),
    );
    _loadCount();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: _open,
        child: Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.archive_rounded, color: AppTheme.textSecondary, size: 20),
              if (count > 0)
                Positioned(
                  top: -6,
                  right: -6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: AppTheme.success,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.background, width: 1.5),
                    ),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      count > 99 ? '99+' : '$count',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}