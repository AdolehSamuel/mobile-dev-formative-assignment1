import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/post.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import 'attendee_avatars.dart';
import 'category_chip.dart';

/// A small pill showing how much time is left to apply, e.g. "3 days left".
/// Turns red when the deadline is close.
class DeadlineChip extends StatelessWidget {
  final DateTime deadline;

  const DeadlineChip({super.key, required this.deadline});

  @override
  Widget build(BuildContext context) {
    final daysLeft = DateTime(deadline.year, deadline.month, deadline.day)
        .difference(DateTime.now())
        .inDays;
    final urgent = daysLeft <= 2;
    final color = urgent ? AppColors.danger : AppColors.accentOpportunity;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.alarm_rounded, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            formatDeadline(deadline),
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

/// The standard feed list item: cover icon, category, title, schedule and
/// either an attendee count or an application deadline.
class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;

  const PostCard({
    super.key,
    required this.post,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cover = coverThemeFor(post.coverThemeKey);
    final appState = context.watch<AppState>();
    final rsvp = appState.rsvpFor(post.id);
    final saved = appState.isSaved(post.id);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: cover.gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(cover.icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CategoryTag(category: post.category),
                        const Spacer(),
                        if (rsvp == RsvpStatus.going)
                          const Icon(Icons.check_circle_rounded,
                              size: 18, color: AppColors.going)
                        else if (rsvp == RsvpStatus.interested)
                          const Icon(Icons.star_rounded,
                              size: 18, color: AppColors.interested),
                        if (saved) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.bookmark_rounded,
                              size: 18, color: AppColors.primary),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      post.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    _IconText(
                      icon: Icons.schedule_rounded,
                      text: formatEventDate(post.dateTime),
                    ),
                    const SizedBox(height: 2),
                    _IconText(
                      icon: Icons.location_on_outlined,
                      text: post.location,
                    ),
                    const SizedBox(height: 8),
                    if (post.category.isOpportunity && post.deadline != null)
                      DeadlineChip(deadline: post.deadline!)
                    else if (post.category.supportsRsvp)
                      AttendeeAvatars(count: post.goingCount)
                    else
                      _IconText(
                        icon: Icons.campaign_outlined,
                        text: post.organizerName,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String text;

  const _IconText({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Theme.of(context).textTheme.bodySmall?.color),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
