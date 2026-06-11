import 'package:flutter/material.dart';

/// Categories of notifications shown in the Notifications center.
enum NotificationType {
  rsvp,
  message,
  club,
  system;

  IconData get icon {
    switch (this) {
      case NotificationType.rsvp:
        return Icons.event_available_rounded;
      case NotificationType.message:
        return Icons.chat_bubble_rounded;
      case NotificationType.club:
        return Icons.groups_rounded;
      case NotificationType.system:
        return Icons.campaign_rounded;
    }
  }

  Color get color {
    switch (this) {
      case NotificationType.rsvp:
        return const Color(0xFF34D399);
      case NotificationType.message:
        return const Color(0xFF5B9CF6);
      case NotificationType.club:
        return const Color(0xFF8C7CF6);
      case NotificationType.system:
        return const Color(0xFFF5A623);
    }
  }
}

/// A single notification feed item.
class NotificationItem {
  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime time;

  const NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.time,
  });
}
