import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../theme/app_theme.dart';

/// Small pill shown next to an organizer's name. Shows "Verified Organizer"
/// for staff roles, or "Student" otherwise.
class RoleBadge extends StatelessWidget {
  final UserRole role;
  final bool compact;

  const RoleBadge({super.key, required this.role, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final verified = role.isVerifiedPoster;
    final color = verified ? AppColors.primary : AppColors.darkTextSecondary;
    final label = verified ? role.label : 'Student';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            verified ? Icons.verified_rounded : Icons.school_rounded,
            size: 13,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
