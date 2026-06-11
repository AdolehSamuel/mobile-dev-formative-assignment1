import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/club.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

/// A list row for a club: icon, name, category, member count, and a
/// Join/Joined button.
class ClubCard extends StatelessWidget {
  final Club club;
  final VoidCallback onTap;

  const ClubCard({super.key, required this.club, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final joined = appState.isJoined(club.id);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: club.color.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(club.icon, color: club.color, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(club.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      '${club.category} • ${club.campus.shortLabel}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 2),
                    Text('${club.memberCount} members',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _JoinButton(
                joined: joined,
                onTap: () => appState.toggleJoinClub(club.id),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JoinButton extends StatelessWidget {
  final bool joined;
  final VoidCallback onTap;

  const _JoinButton({required this.joined, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Material(
      color: joined ? Colors.transparent : AppColors.primary,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: joined ? border : AppColors.primary),
          ),
          child: Text(
            joined ? 'Joined' : 'Join',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: joined
                  ? Theme.of(context).textTheme.bodyMedium?.color
                  : const Color(0xFF1A1300),
            ),
          ),
        ),
      ),
    );
  }
}
