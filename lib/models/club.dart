import 'package:flutter/material.dart';
import 'user_profile.dart';

/// A student club / community.
class Club {
  final String id;
  final String name;
  final String description;
  final String category;
  final Campus campus;
  final IconData icon;
  final Color color;
  final int memberCount;

  const Club({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.campus,
    required this.icon,
    required this.color,
    required this.memberCount,
  });
}
