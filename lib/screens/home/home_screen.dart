import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';
import '../../models/user_profile.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/post_card.dart';
import '../../widgets/section_header.dart';
import '../profile/notifications_screen.dart';
import 'post_detail_screen.dart';

String _greeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Good morning';
  if (hour < 17) return 'Good afternoon';
  return 'Good evening';
}

/// The main feed: greeting header, search bar, campus and category
/// filters, and the post list.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  PostCategory? _categoryFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _clearFilters() {
    setState(() {
      _categoryFilter = null;
      _query = '';
      _searchController.clear();
    });
    context.read<AppState>().setCampusFilter(null);
  }

  bool _matchesCampus(Post post, Campus? campusFilter) {
    if (campusFilter == null) return true;
    return post.campus == campusFilter || post.campus == Campus.online;
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final user = appState.currentUser;
    final campusFilter = appState.campusFilter;

    final query = _query.trim().toLowerCase();
    final posts = appState.posts.where((p) {
      if (!_matchesCampus(p, campusFilter)) return false;
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

    final hasFiltersApplied =
        _categoryFilter != null || query.isNotEmpty || campusFilter != null;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            children: [
              _Header(
                name: user?.name.split(' ').first ?? 'there',
                initials: user?.initials ?? '?',
                unreadCount: appState.unreadNotificationCount,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value),
                decoration: const InputDecoration(
                  hintText: 'Search events, opportunities, clubs...',
                  prefixIcon: Icon(Icons.search_rounded, size: 22),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    FilterChipPill(
                      label: 'All Campuses',
                      icon: Icons.public_rounded,
                      selected: campusFilter == null,
                      onTap: () =>
                          context.read<AppState>().setCampusFilter(null),
                    ),
                    const SizedBox(width: 8),
                    for (final campus in Campus.values) ...[
                      FilterChipPill(
                        label: campus.shortLabel,
                        icon: Icons.location_on_outlined,
                        selected: campusFilter == campus,
                        onTap: () =>
                            context.read<AppState>().setCampusFilter(campus),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    FilterChipPill(
                      label: 'All',
                      icon: Icons.apps_rounded,
                      selected: _categoryFilter == null,
                      onTap: () => setState(() => _categoryFilter = null),
                    ),
                    const SizedBox(width: 8),
                    for (final category in PostCategory.values) ...[
                      FilterChipPill(
                        label: category.label,
                        icon: category.icon,
                        selected: _categoryFilter == category,
                        onTap: () => setState(() {
                          _categoryFilter =
                              _categoryFilter == category ? null : category;
                        }),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerLeft,
                child: SectionHeader(
                  title: hasFiltersApplied ? 'Results' : 'Latest for you',
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  child: posts.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.5,
                              child: EmptyState(
                                icon: Icons.search_off_rounded,
                                title: 'No posts found',
                                message: 'Try a different search term, '
                                    'category, or campus filter.',
                                actionLabel:
                                    hasFiltersApplied ? 'Clear filters' : null,
                                onAction:
                                    hasFiltersApplied ? _clearFilters : null,
                              ),
                            ),
                          ],
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.only(bottom: 24),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String name;
  final String initials;
  final int unreadCount;

  const _Header({
    required this.name,
    required this.initials,
    required this.unreadCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_greeting()}, $name',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 21,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                "Here's what's happening across ALU",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Material(
              color: Theme.of(context).cardColor,
              shape: const CircleBorder(
                side: BorderSide(color: AppColors.darkBorder),
              ),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.notifications_outlined, size: 22),
                ),
              ),
            ),
            if (unreadCount > 0)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  constraints:
                      const BoxConstraints(minWidth: 16, minHeight: 16),
                  decoration: const BoxDecoration(
                    color: AppColors.danger,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    unreadCount > 9 ? '9+' : '$unreadCount',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 10),
        CircleAvatar(
          radius: 21,
          backgroundColor: AppColors.primary,
          child: Text(
            initials,
            style: const TextStyle(
              color: Color(0xFF1A1300),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
