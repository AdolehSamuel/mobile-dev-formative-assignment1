import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chat_models.dart';
import '../../state/app_state.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/post_card.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/section_header.dart';
import '../chats/chat_detail_screen.dart';
import '../home/post_detail_screen.dart';

/// About page for a single club: description, join/leave action, group
/// chat shortcut, and its posts.
class ClubDetailScreen extends StatelessWidget {
  final String clubId;

  const ClubDetailScreen({super.key, required this.clubId});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final club = appState.clubById(clubId);

    if (club == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const EmptyState(
          icon: Icons.error_outline_rounded,
          title: 'Club not found',
          message: 'This club may no longer be available.',
        ),
      );
    }

    final joined = appState.isJoined(club.id);
    final relatedPosts = appState.postsForClub(club.id);

    Conversation? conversation;
    for (final c in appState.conversations) {
      if (c.clubId == club.id) {
        conversation = c;
        break;
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(club.name)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: club.color.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(club.icon, color: club.color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(club.name,
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      '${club.category} • ${club.campus.shortLabel}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 2),
                    Text('${club.memberCount} members',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          joined
              ? SecondaryButton(
                  label: 'Joined',
                  icon: Icons.check_circle_rounded,
                  onPressed: () => appState.toggleJoinClub(club.id),
                )
              : PrimaryButton(
                  label: 'Join Club',
                  icon: Icons.group_add_rounded,
                  onPressed: () => appState.toggleJoinClub(club.id),
                ),
          if (conversation != null) ...[
            const SizedBox(height: 12),
            SecondaryButton(
              label: 'Open Group Chat',
              icon: Icons.chat_bubble_outline_rounded,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      ChatDetailScreen(conversationId: conversation!.id),
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          Text('About', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(club.description, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          SectionHeader(title: 'Posts from this club'),
          const SizedBox(height: 12),
          if (relatedPosts.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'This club hasn\'t posted anything yet.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          else
            ...relatedPosts.map((post) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: PostCard(
                  post: post,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PostDetailScreen(post: post),
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
