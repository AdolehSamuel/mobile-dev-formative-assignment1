import 'package:flutter/material.dart';
import 'user_profile.dart';

/// The kind of activity a [Post] represents.
enum PostCategory {
  event,
  opportunity,
  workshop,
  studyGroup,
  announcement;

  String get label {
    switch (this) {
      case PostCategory.event:
        return 'Event';
      case PostCategory.opportunity:
        return 'Opportunity';
      case PostCategory.workshop:
        return 'Workshop';
      case PostCategory.studyGroup:
        return 'Study Group';
      case PostCategory.announcement:
        return 'Announcement';
    }
  }

  IconData get icon {
    switch (this) {
      case PostCategory.event:
        return Icons.celebration_rounded;
      case PostCategory.opportunity:
        return Icons.work_outline_rounded;
      case PostCategory.workshop:
        return Icons.handyman_rounded;
      case PostCategory.studyGroup:
        return Icons.groups_2_rounded;
      case PostCategory.announcement:
        return Icons.campaign_rounded;
    }
  }

  Color get color {
    switch (this) {
      case PostCategory.event:
        return const Color(0xFFF5A623);
      case PostCategory.opportunity:
        return const Color(0xFF8C7CF6);
      case PostCategory.workshop:
        return const Color(0xFF36C2CE);
      case PostCategory.studyGroup:
        return const Color(0xFF4ADE80);
      case PostCategory.announcement:
        return const Color(0xFFEF6F8E);
    }
  }

  /// Whether this category uses the Going/Interested RSVP flow.
  bool get supportsRsvp =>
      this == PostCategory.event ||
      this == PostCategory.workshop ||
      this == PostCategory.studyGroup;

  /// Whether this category shows an application deadline + "Apply" action.
  bool get isOpportunity => this == PostCategory.opportunity;
}

/// Going / interested status the current user has set for a [Post].
enum RsvpStatus { none, going, interested }

/// A single feed item: an event, opportunity, workshop, study group or
/// announcement.
class Post {
  final String id;
  String title;
  String description;
  PostCategory category;
  Campus campus;
  DateTime dateTime;
  String location;
  String organizerName;
  UserRole organizerRole;
  String? clubId;
  String coverThemeKey;
  List<String> tags;
  int goingCount;
  int interestedCount;
  DateTime? deadline;
  final bool isUserCreated;

  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.campus,
    required this.dateTime,
    required this.location,
    required this.organizerName,
    required this.organizerRole,
    this.clubId,
    required this.coverThemeKey,
    this.tags = const [],
    this.goingCount = 0,
    this.interestedCount = 0,
    this.deadline,
    this.isUserCreated = false,
  });

  /// Whether this post gets a "Verified Organizer" badge.
  bool get isVerified => organizerRole.isVerifiedPoster;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category.name,
        'campus': campus.name,
        'dateTime': dateTime.toIso8601String(),
        'location': location,
        'organizerName': organizerName,
        'organizerRole': organizerRole.name,
        'clubId': clubId,
        'coverThemeKey': coverThemeKey,
        'tags': tags,
        'goingCount': goingCount,
        'interestedCount': interestedCount,
        'deadline': deadline?.toIso8601String(),
        'isUserCreated': isUserCreated,
      };

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        category: PostCategory.values.firstWhere(
          (c) => c.name == json['category'],
          orElse: () => PostCategory.event,
        ),
        campus: Campus.values.firstWhere(
          (c) => c.name == json['campus'],
          orElse: () => Campus.kigali,
        ),
        dateTime: DateTime.tryParse(json['dateTime'] as String? ?? '') ??
            DateTime.now(),
        location: json['location'] as String,
        organizerName: json['organizerName'] as String,
        organizerRole: UserRole.values.firstWhere(
          (r) => r.name == json['organizerRole'],
          orElse: () => UserRole.student,
        ),
        clubId: json['clubId'] as String?,
        coverThemeKey: json['coverThemeKey'] as String? ?? 'leadership',
        tags: (json['tags'] as List<dynamic>? ?? []).cast<String>(),
        goingCount: json['goingCount'] as int? ?? 0,
        interestedCount: json['interestedCount'] as int? ?? 0,
        deadline: json['deadline'] != null
            ? DateTime.tryParse(json['deadline'] as String)
            : null,
        isUserCreated: json['isUserCreated'] as bool? ?? false,
      );
}
