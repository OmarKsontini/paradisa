import 'package:flutter/material.dart';

class Subject {
  final String id;
  final String name;
  final String description;
  final Color color;
  final IconData icon;
  final int topicCount; 

  const Subject({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.icon,
    required this.topicCount,
  });
}