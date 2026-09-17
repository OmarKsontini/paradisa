import 'package:flutter/material.dart';

const Map<String, IconData> iconMap = {
  'bolt': Icons.bolt,
  'biotech': Icons.biotech,
  'science': Icons.science,
  'directions_run': Icons.directions_run,
  'security': Icons.security,
  'psychology': Icons.psychology,
  'memory': Icons.memory,
  'public': Icons.public,
  'calculate': Icons.calculate,
  'language': Icons.language,
  'palette': Icons.palette,
  'music_note': Icons.music_note,
  'sports_soccer': Icons.sports_soccer,
  'history_edu': Icons.history_edu,
  'terrain': Icons.terrain,
  'water_drop': Icons.water_drop,
  'local_fire_department': Icons.local_fire_department,
  'rocket_launch': Icons.rocket_launch,
  'code': Icons.code,
  'storage': Icons.storage,
  'wifi': Icons.wifi,
  'monitor_heart': Icons.monitor_heart,
  'restaurant': Icons.restaurant,
  'agriculture': Icons.agriculture,
  'architecture': Icons.architecture,
  'auto_awesome': Icons.auto_awesome,
  'explore': Icons.explore,
  'menu_book': Icons.menu_book,
  'gavel': Icons.gavel,
  'account_balance': Icons.account_balance,
};

const IconData fallbackIcon = Icons.help_outline;

Color colorFromHex(String hex) {
  final cleaned = hex.replaceFirst('#', '');
  return Color(int.parse('FF$cleaned', radix: 16));
}

class Subject {
  final int id;
  final String name;
  final String description;
  final Color color;
  final IconData icon;

  const Subject({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.icon,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      color: colorFromHex(json['color']),
      icon: iconMap[json['icon']] ?? fallbackIcon,
    );
  }
}