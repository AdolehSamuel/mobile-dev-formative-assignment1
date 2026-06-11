import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/club.dart';
import '../../state/app_state.dart';
import '../../widgets/club_card.dart';
import '../../widgets/empty_state.dart';
import 'club_detail_screen.dart';

/// Club directory with "All Clubs" and "My Clubs" tabs.
class CommunitiesScreen extends StatefulWidget {
  final int initialTabIndex;

  const CommunitiesScreen({super.key, this.initialTabIndex = 0});

  @override
  State<CommunitiesScreen> createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Communities'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'All Clubs'), Tab(text: 'My Clubs')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ClubList(clubs: appState.clubs),
          appState.myClubs.isEmpty
              ? const EmptyState(
                  icon: Icons.groups_outlined,
                  title: 'No clubs yet',
                  message:
                      'Join clubs from the "All Clubs" tab to see them here '
                      'and access their group chats.',
                )
              : _ClubList(clubs: appState.myClubs),
        ],
      ),
    );
  }
}

class _ClubList extends StatelessWidget {
  final List<Club> clubs;

  const _ClubList({required this.clubs});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: clubs.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final club = clubs[index];
        return ClubCard(
          club: club,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ClubDetailScreen(clubId: club.id),
            ),
          ),
        );
      },
    );
  }
}
