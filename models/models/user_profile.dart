import 'package:flutter/material.dart';

/// The campuses / hubs ALU Connect users belong to.
enum Campus {
  kigali,
  mauritius,
  online;

  String get label {
    switch (this) {
      case Campus.kigali:
        return 'Kigali Campus';
      case Campus.mauritius:
        return 'Mauritius Campus';
      case Campus.online:
        return 'Cross-Campus / Online';
    }
  }

  String get shortLabel {
    switch (this) {
      case Campus.kigali:
        return 'Kigali';
      case Campus.mauritius:
        return 'Mauritius';
      case Campus.online:
        return 'Online';
    }
  }
}

/// The role a user signs up with. Affects post badges and which
/// categories they're encouraged to use.
enum UserRole {
  student,
  clubLeader,
  eventOrganizer,
  academicRep;

  String get label {
    switch (this) {
      case UserRole.student:
        return 'Student';
      case UserRole.clubLeader:
        return 'Club Leader';
      case UserRole.eventOrganizer:
        return 'Event Organizer';
      case UserRole.academicRep:
        return 'Academic Rep';
    }
  }

  String get description {
    switch (this) {
      case UserRole.student:
        return 'Browse, RSVP, and share student-led posts and study groups.';
      case UserRole.clubLeader:
        return 'Run a club or society and post on its behalf with a verified badge.';
      case UserRole.eventOrganizer:
        return 'Organize campus-wide events, hackathons, and competitions.';
      case UserRole.academicRep:
        return 'Share academic deadlines, resources, and faculty announcements.';
    }
  }

  /// Whether this role's posts are marked as "Verified Organizer" content.
  bool get isVerifiedPoster => this != UserRole.student;

  IconData get icon {
    switch (this) {
      case UserRole.student:
        return Icons.school_rounded;
      case UserRole.clubLeader:
        return Icons.groups_rounded;
      case UserRole.eventOrganizer:
        return Icons.event_available_rounded;
      case UserRole.academicRep:
        return Icons.menu_book_rounded;
    }
  }
}

/// The signed-in user's profile.
class UserProfile {
  final String id;
  String name;
  String email;
  Campus campus;
  UserRole role;
  String bio;
  final DateTime joinedAt;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.campus,
    required this.role,
    this.bio = '',
    DateTime? joinedAt,
  }) : joinedAt = joinedAt ?? DateTime.now();

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'campus': campus.name,
        'role': role.name,
        'bio': bio,
        'joinedAt': joinedAt.toIso8601String(),
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        campus: Campus.values.firstWhere(
          (c) => c.name == json['campus'],
          orElse: () => Campus.kigali,
        ),
        role: UserRole.values.firstWhere(
          (r) => r.name == json['role'],
          orElse: () => UserRole.student,
        ),
        bio: json['bio'] as String? ?? '',
        joinedAt: DateTime.tryParse(json['joinedAt'] as String? ?? '') ??
            DateTime.now(),
      );
}
