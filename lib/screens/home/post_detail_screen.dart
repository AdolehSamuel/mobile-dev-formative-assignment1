import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';
import '../../widgets/attendee_avatars.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/post_card.dart';
import '../../widgets/role_badge.dart';
import '../communities/club_detail_screen.dart';

/// Full detail view for a single post. The bottom action bar changes based
/// on the post's category: events/workshops/study groups get
/// Interested/Going buttons, opportunities get an Apply Now button plus
/// Interested, and announcements have no action bar.
class PostDetailScreen extends StatelessWidget {
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final cover = coverThemeFor(post.coverThemeKey);
    final saved = appState.isSaved(post.id);
    final club = post.clubId != null ? appState.clubById(post.clubId!) : null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            ),
            color: saved ? AppColors.primary : null,
            onPressed: () => appState.toggleSaved(post.id),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cover.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Icon(
                cover.icon,
                size: 96,
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CategoryTag(category: post.category),
                const SizedBox(height: 10),
                Text(post.title,
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: cover.gradient.first.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(post.organizerRole.icon,
                          size: 20, color: cover.gradient.first),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post.organizerName,
                              style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(height: 4),
                          RoleBadge(role: post.organizerRole),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _InfoRow(
                  icon: Icons.schedule_rounded,
                  text: formatEventDate(post.dateTime),
                ),
                const SizedBox(height: 10),
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  text: post.location,
                ),
                const SizedBox(height: 16),
                if (post.category.supportsRsvp)
                  Row(
                    children: [
                      AttendeeAvatars(count: post.goingCount),
                      const SizedBox(width: 16),
                      Icon(Icons.star_rounded,
                          size: 16, color: AppColors.interested),
                      const SizedBox(width: 4),
                      Text('${post.interestedCount} interested',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  )
                else if (post.category.isOpportunity) ...[
                  if (post.deadline != null) ...[
                    DeadlineChip(deadline: post.deadline!),
                    const SizedBox(height: 8),
                    Text(
                      'Applications close ${formatFullDate(post.deadline!)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                  ],
                  Row(
                    children: [
                      Icon(Icons.star_rounded,
                          size: 16, color: AppColors.interested),
                      const SizedBox(width: 4),
                      Text('${post.interestedCount} interested',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 16),
                Text('About', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(post.description,
                    style: Theme.of(context).textTheme.bodyMedium),
                if (post.tags.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: post.tags
                        .map((tagText) => _TagChip(label: tagText))
                        .toList(),
                  ),
                ],
                if (club != null) ...[
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ClubDetailScreen(clubId: club.id),
                      ),
                    ),
                    icon: Icon(club.icon, size: 18, color: club.color),
                    label: Text('View ${club.name}'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context, appState),
    );
  }

  Widget? _buildBottomBar(BuildContext context, AppState appState) {
    final rsvp = appState.rsvpFor(post.id);

    if (post.category.supportsRsvp) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: 'Interested',
                  icon: Icons.star_rounded,
                  color: AppColors.interested,
                  selected: rsvp == RsvpStatus.interested,
                  onTap: () => appState.setRsvpStatus(
                    post.id,
                    rsvp == RsvpStatus.interested
                        ? RsvpStatus.none
                        : RsvpStatus.interested,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  label: 'Going',
                  icon: Icons.check_circle_rounded,
                  color: AppColors.going,
                  selected: rsvp == RsvpStatus.going,
                  filled: true,
                  onTap: () => appState.setRsvpStatus(
                    post.id,
                    rsvp == RsvpStatus.going
                        ? RsvpStatus.none
                        : RsvpStatus.going,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (post.category.isOpportunity) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: 'Interested',
                  icon: Icons.star_rounded,
                  color: AppColors.interested,
                  selected: rsvp == RsvpStatus.interested,
                  onTap: () => appState.setRsvpStatus(
                    post.id,
                    rsvp == RsvpStatus.interested
                        ? RsvpStatus.none
                        : RsvpStatus.interested,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _ActionButton(
                  label: 'Apply Now',
                  icon: Icons.open_in_new_rounded,
                  color: AppColors.primary,
                  selected: true,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "This is a demo, so there's no real application "
                          "link, but we've noted your interest!",
                        ),
                      ),
                    );
                    if (rsvp != RsvpStatus.interested) {
                      appState.setRsvpStatus(post.id, RsvpStatus.interested);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    return null;
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;

  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text('#$label', style: Theme.of(context).textTheme.bodySmall),
    );
  }
}

/// A bottom-bar action button that's either filled (selected/primary) or
/// outlined (unselected), used for RSVP and Apply actions.
class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final bool filled;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final useFilled = selected && filled;
    final fg = useFilled ? const Color(0xFF1A1300) : color;

    return Material(
      color: useFilled ? color : color.withValues(alpha: selected ? 0.14 : 0.0),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? color : border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: fg),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
