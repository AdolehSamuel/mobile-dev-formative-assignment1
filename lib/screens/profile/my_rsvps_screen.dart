import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';
import '../../state/app_state.dart';
import '../../utils/formatters.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/post_card.dart';
import '../../widgets/section_header.dart';
import '../home/post_detail_screen.dart';

/// "My Schedule": posts the user RSVP'd to, split into Going and
/// Interested tabs and grouped by day.
class MyRsvpsScreen extends StatefulWidget {
  const MyRsvpsScreen({super.key});

  @override
  State<MyRsvpsScreen> createState() => _MyRsvpsScreenState();
}

class _MyRsvpsScreenState extends State<MyRsvpsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final going = appState.postsWithRsvp(RsvpStatus.going);
    final interested = appState.postsWithRsvp(RsvpStatus.interested);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My RSVPs'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Going (${going.length})'),
            Tab(text: 'Interested (${interested.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ScheduleList(
            posts: going,
            emptyIcon: Icons.event_available_rounded,
            emptyTitle: 'Nothing on your schedule yet',
            emptyMessage:
                'RSVP "Going" to events and workshops to build your '
                'personal schedule.',
          ),
          _ScheduleList(
            posts: interested,
            emptyIcon: Icons.star_outline_rounded,
            emptyTitle: 'No interests yet',
            emptyMessage:
                'Mark events or opportunities as "Interested" to keep '
                'track of them here.',
          ),
        ],
      ),
    );
  }
}

class _ScheduleList extends StatelessWidget {
  final List<Post> posts;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptyMessage;

  const _ScheduleList({
    required this.posts,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return EmptyState(
        icon: emptyIcon,
        title: emptyTitle,
        message: emptyMessage,
      );
    }

    final sorted = [...posts];
    sorted.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    final items = <Widget>[];
    String? lastHeader;
    for (final post in sorted) {
      final header = formatDayHeader(post.dateTime);
      if (header != lastHeader) {
        if (lastHeader != null) items.add(const SizedBox(height: 20));
        items.add(SectionHeader(title: header));
        items.add(const SizedBox(height: 12));
        lastHeader = header;
      } else {
        items.add(const SizedBox(height: 12));
      }

      items.add(PostCard(
        post: post,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PostDetailScreen(post: post),
          ),
        ),
      ));
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: items,
    );
  }
}
