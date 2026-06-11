import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';
import '../../models/user_profile.dart';
import '../../state/app_state.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/club_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/post_card.dart';
import '../communities/club_detail_screen.dart';
import '../home/post_detail_screen.dart';

/// Search and discovery across both posts and clubs. Independent of the
/// Home feed's campus filter, and defaults to "all campuses".
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _searchController = TextEditingController();
  String _query = '';
  PostCategory? _categoryFilter;
  Campus? _campusFilter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  bool _matchesCampus(Campus campus) {
    if (_campusFilter == null) return true;
    return campus == _campusFilter || campus == Campus.online;
  }

  void _clearFilters() {
    setState(() {
      _categoryFilter = null;
      _campusFilter = null;
      _query = '';
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final query = _query.trim().toLowerCase();

    final posts = appState.posts.where((p) {
      if (!_matchesCampus(p.campus)) return false;
      if (_categoryFilter != null && p.category != _categoryFilter) {
        return false;
      }
      if (query.isNotEmpty) {
        final haystack =
            '${p.title} ${p.description} ${p.location} ${p.organizerName}'
                .toLowerCase();
        if (!haystack.contains(query)) return false;
      }
      return true;
    }).toList();

    final clubs = appState.clubs.where((c) {
      if (!_matchesCampus(c.campus)) return false;
      if (query.isNotEmpty) {
        final haystack = '${c.name} ${c.description} ${c.category}'
            .toLowerCase();
        if (!haystack.contains(query)) return false;
      }
      return true;
    }).toList();

    final hasFilters =
        _categoryFilter != null || _campusFilter != null || query.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Posts'), Tab(text: 'Clubs')],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value),
                decoration: const InputDecoration(
                  hintText: 'Search posts, clubs, organizers...',
                  prefixIcon: Icon(Icons.search_rounded, size: 22),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    FilterChipPill(
                      label: 'All Campuses',
                      icon: Icons.public_rounded,
                      selected: _campusFilter == null,
                      onTap: () => setState(() => _campusFilter = null),
                    ),
                    const SizedBox(width: 8),
                    for (final campus in Campus.values) ...[
                      FilterChipPill(
                        label: campus.shortLabel,
                        icon: Icons.location_on_outlined,
                        selected: _campusFilter == campus,
                        onTap: () => setState(() {
                          _campusFilter =
                              _campusFilter == campus ? null : campus;
                        }),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _tabController,
              builder: (context, _) {
                if (_tabController.index != 0) {
                  return const SizedBox(height: 12);
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: SizedBox(
                    height: 38,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        FilterChipPill(
                          label: 'All',
                          icon: Icons.apps_rounded,
                          selected: _categoryFilter == null,
                          onTap: () =>
                              setState(() => _categoryFilter = null),
                        ),
                        const SizedBox(width: 8),
                        for (final category in PostCategory.values) ...[
                          FilterChipPill(
                            label: category.label,
                            icon: category.icon,
                            selected: _categoryFilter == category,
                            onTap: () => setState(() {
                              _categoryFilter = _categoryFilter == category
                                  ? null
                                  : category;
                            }),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  posts.isEmpty
                      ? EmptyState(
                          icon: Icons.search_off_rounded,
                          title: 'No posts found',
                          message:
                              'Try a different search term, category, or campus.',
                          actionLabel: hasFilters ? 'Clear filters' : null,
                          onAction: hasFilters ? _clearFilters : null,
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          itemCount: posts.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final post = posts[index];
                            return PostCard(
                              post: post,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PostDetailScreen(post: post),
                                ),
                              ),
                            );
                          },
                        ),
                  clubs.isEmpty
                      ? EmptyState(
                          icon: Icons.groups_outlined,
                          title: 'No clubs found',
                          message:
                              'Try a different search term or campus filter.',
                          actionLabel: hasFilters ? 'Clear filters' : null,
                          onAction: hasFilters ? _clearFilters : null,
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          itemCount: clubs.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final club = clubs[index];
                            return ClubCard(
                              club: club,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ClubDetailScreen(clubId: club.id),
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
