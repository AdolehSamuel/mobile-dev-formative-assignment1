import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/post_card.dart';
import '../home/post_detail_screen.dart';

/// Bookmarked events, opportunities and announcements.
class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final saved = context.watch<AppState>().savedPosts;

    return Scaffold(
      appBar: AppBar(title: const Text('Saved')),
      body: SafeArea(
        child: saved.isEmpty
            ? const EmptyState(
                icon: Icons.bookmark_border_rounded,
                title: 'Nothing saved yet',
                message:
                    'Tap the bookmark icon on a post to save it here for '
                    'later. Handy for opportunity deadlines.',
              )
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                itemCount: saved.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final post = saved[index];
                  return PostCard(
                    post: post,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PostDetailScreen(post: post),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
