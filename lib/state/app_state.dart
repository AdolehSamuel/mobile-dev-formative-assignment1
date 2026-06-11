import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/mock_data.dart';
import '../models/chat_models.dart';
import '../models/club.dart';
import '../models/notification_item.dart';
import '../models/post.dart';
import '../models/user_profile.dart';

/// Holds the app's data and state, and saves user changes so they
/// survive a restart.
class AppState extends ChangeNotifier {
  AppState() {
    _posts = buildSeedPosts();
    _clubs = buildSeedClubs();
    _conversations = buildSeedConversations();
    _notifications = buildSeedNotifications();
  }

  late final List<Post> _posts;
  late final List<Club> _clubs;
  late final List<Conversation> _conversations;
  late final List<NotificationItem> _notifications;

  late SharedPreferences _prefs;
  bool _ready = false;

  UserProfile? _currentUser;
  bool _isLoggedIn = false;
  bool _hasSeenOnboarding = false;
  ThemeMode _themeMode = ThemeMode.dark;
  Campus? _campusFilter;

  final Map<String, RsvpStatus> _rsvpStatuses = {};
  final Set<String> _savedPostIds = {};
  final Set<String> _joinedClubIds = {};
  final Set<String> _readNotificationIds = {};

  // ---------------------------------------------------------------------
  // Read-only access
  // ---------------------------------------------------------------------

  bool get isReady => _ready;
  UserProfile? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn && _currentUser != null;
  bool get hasSeenOnboarding => _hasSeenOnboarding;
  ThemeMode get themeMode => _themeMode;
  Campus? get campusFilter => _campusFilter;

  List<Post> get posts => _posts;
  List<Club> get clubs => _clubs;
  List<Conversation> get conversations => _conversations;
  List<NotificationItem> get notifications => _notifications;

  List<Post> get myPosts => _posts.where((p) => p.isUserCreated).toList();
  List<Post> get savedPosts =>
      _posts.where((p) => _savedPostIds.contains(p.id)).toList();
  List<Club> get myClubs =>
      _clubs.where((c) => _joinedClubIds.contains(c.id)).toList();

  List<Post> postsWithRsvp(RsvpStatus status) =>
      _posts.where((p) => rsvpFor(p.id) == status).toList();

  RsvpStatus rsvpFor(String postId) =>
      _rsvpStatuses[postId] ?? RsvpStatus.none;
  bool isSaved(String postId) => _savedPostIds.contains(postId);
  bool isJoined(String clubId) => _joinedClubIds.contains(clubId);
  bool isNotificationRead(String id) => _readNotificationIds.contains(id);
  int get unreadNotificationCount =>
      _notifications.where((n) => !_readNotificationIds.contains(n.id)).length;

  Post? postById(String id) {
    for (final p in _posts) {
      if (p.id == id) return p;
    }
    return null;
  }

  Club? clubById(String id) {
    for (final c in _clubs) {
      if (c.id == id) return c;
    }
    return null;
  }

  Conversation? conversationById(String id) {
    for (final c in _conversations) {
      if (c.id == id) return c;
    }
    return null;
  }

  List<Post> postsForClub(String clubId) =>
      _posts.where((p) => p.clubId == clubId).toList();

  // ---------------------------------------------------------------------
  // Persistence
  // ---------------------------------------------------------------------

  static const _kHasSeenOnboarding = 'has_seen_onboarding';
  static const _kIsLoggedIn = 'is_logged_in';
  static const _kCurrentUser = 'current_user';
  static const _kThemeMode = 'theme_mode';
  static const _kCampusFilter = 'campus_filter';
  static const _kRsvpStatuses = 'rsvp_statuses';
  static const _kSavedPostIds = 'saved_post_ids';
  static const _kJoinedClubIds = 'joined_club_ids';
  static const _kReadNotificationIds = 'read_notification_ids';
  static const _kUserPosts = 'user_posts';
  static const _kChatExtraMessages = 'chat_extra_messages';

  /// Loads everything from [SharedPreferences]. Must be called once before
  /// the app is shown (see `main.dart`).
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    _hasSeenOnboarding = _prefs.getBool(_kHasSeenOnboarding) ?? false;
    _isLoggedIn = _prefs.getBool(_kIsLoggedIn) ?? false;

    final userJson = _prefs.getString(_kCurrentUser);
    if (userJson != null) {
      _currentUser = UserProfile.fromJson(
          jsonDecode(userJson) as Map<String, dynamic>);
    }

    _themeMode =
        _prefs.getString(_kThemeMode) == 'light' ? ThemeMode.light : ThemeMode.dark;

    final campusName = _prefs.getString(_kCampusFilter);
    if (campusName != null) {
      _campusFilter = _campusFromName(campusName);
    }

    final rsvpJson = _prefs.getString(_kRsvpStatuses);
    if (rsvpJson != null) {
      final map = jsonDecode(rsvpJson) as Map<String, dynamic>;
      map.forEach((postId, statusName) {
        _rsvpStatuses[postId] = RsvpStatus.values.firstWhere(
          (s) => s.name == statusName,
          orElse: () => RsvpStatus.none,
        );
      });
    }

    _savedPostIds.addAll(_prefs.getStringList(_kSavedPostIds) ?? const []);
    _joinedClubIds.addAll(_prefs.getStringList(_kJoinedClubIds) ?? const []);
    _readNotificationIds
        .addAll(_prefs.getStringList(_kReadNotificationIds) ?? const []);

    final userPostsJson = _prefs.getString(_kUserPosts);
    if (userPostsJson != null) {
      final list = jsonDecode(userPostsJson) as List<dynamic>;
      final userPosts = list
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList();
      // Most-recently-created posts were saved first; insert as a block so
      // their relative order is preserved at the top of the feed.
      _posts.insertAll(0, userPosts);
    }

    final chatExtraJson = _prefs.getString(_kChatExtraMessages);
    if (chatExtraJson != null) {
      final map = jsonDecode(chatExtraJson) as Map<String, dynamic>;
      map.forEach((conversationId, messages) {
        final conversation = conversationById(conversationId);
        if (conversation != null) {
          final extra = (messages as List<dynamic>)
              .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
              .toList();
          conversation.messages.addAll(extra);
        }
      });
    }

    _ready = true;
    notifyListeners();
  }

  Campus? _campusFromName(String name) {
    for (final c in Campus.values) {
      if (c.name == name) return c;
    }
    return null;
  }

  Future<void> _persistUser() async {
    final user = _currentUser;
    if (user != null) {
      await _prefs.setString(_kCurrentUser, jsonEncode(user.toJson()));
    }
  }

  Future<void> _persistRsvps() async {
    final map = _rsvpStatuses.map((k, v) => MapEntry(k, v.name));
    await _prefs.setString(_kRsvpStatuses, jsonEncode(map));
  }

  Future<void> _persistUserPosts() async {
    final userPosts =
        _posts.where((p) => p.isUserCreated).map((p) => p.toJson()).toList();
    await _prefs.setString(_kUserPosts, jsonEncode(userPosts));
  }

  Future<void> _persistChatExtras() async {
    final data = <String, dynamic>{};
    for (final conv in _conversations) {
      final extra = conv.messages
          .where((m) => m.id.startsWith('u_'))
          .map((m) => m.toJson())
          .toList();
      if (extra.isNotEmpty) data[conv.id] = extra;
    }
    await _prefs.setString(_kChatExtraMessages, jsonEncode(data));
  }

  // ---------------------------------------------------------------------
  // Onboarding & session
  // ---------------------------------------------------------------------

  Future<void> completeOnboarding() async {
    _hasSeenOnboarding = true;
    await _prefs.setBool(_kHasSeenOnboarding, true);
    notifyListeners();
  }

  /// Restores the existing profile, or creates a new one with a name
  /// derived from the email address.
  Future<void> signIn({String? email}) async {
    if (_currentUser == null) {
      final resolvedEmail = email ?? 'aline.umuhoza@alustudent.com';
      _currentUser = UserProfile(
        id: 'u_${DateTime.now().millisecondsSinceEpoch}',
        name: _deriveNameFromEmail(resolvedEmail),
        email: resolvedEmail,
        campus: Campus.kigali,
        role: UserRole.student,
        bio: 'New to ALU Connect',
      );
    } else if (email != null && email.isNotEmpty) {
      _currentUser!.email = email;
    }

    _isLoggedIn = true;
    _campusFilter ??= _currentUser!.campus;

    await _persistUser();
    await _prefs.setBool(_kIsLoggedIn, true);
    if (_campusFilter != null) {
      await _prefs.setString(_kCampusFilter, _campusFilter!.name);
    }
    notifyListeners();
  }

  Future<void> signUp({
    required String name,
    required String email,
    required Campus campus,
    required UserRole role,
  }) async {
    _currentUser = UserProfile(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      campus: campus,
      role: role,
      bio: 'New to ALU Connect',
    );
    _isLoggedIn = true;
    _campusFilter = campus;

    await _persistUser();
    await _prefs.setBool(_kIsLoggedIn, true);
    await _prefs.setString(_kCampusFilter, campus.name);
    notifyListeners();
  }

  Future<void> signOut() async {
    _isLoggedIn = false;
    await _prefs.setBool(_kIsLoggedIn, false);
    notifyListeners();
  }

  Future<void> updateProfile({String? name, String? bio, Campus? campus}) async {
    final user = _currentUser;
    if (user == null) return;
    if (name != null && name.trim().isNotEmpty) user.name = name.trim();
    if (bio != null) user.bio = bio.trim();
    if (campus != null) user.campus = campus;
    await _persistUser();
    notifyListeners();
  }

  String _deriveNameFromEmail(String email) {
    final local = email.split('@').first;
    final parts =
        local.split(RegExp(r'[._\-0-9]+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return 'ALU Student';
    return parts
        .map((p) => p[0].toUpperCase() + p.substring(1).toLowerCase())
        .join(' ');
  }

  // ---------------------------------------------------------------------
  // Theme
  // ---------------------------------------------------------------------

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs.setString(_kThemeMode, mode == ThemeMode.light ? 'light' : 'dark');
    notifyListeners();
  }

  Future<void> toggleTheme() => setThemeMode(
      _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);

  // ---------------------------------------------------------------------
  // Feed / campus filter
  // ---------------------------------------------------------------------

  Future<void> setCampusFilter(Campus? campus) async {
    _campusFilter = campus;
    if (campus == null) {
      await _prefs.remove(_kCampusFilter);
    } else {
      await _prefs.setString(_kCampusFilter, campus.name);
    }
    notifyListeners();
  }

  Future<void> addPost(Post post) async {
    _posts.insert(0, post);
    await _persistUserPosts();
    notifyListeners();
  }

  // ---------------------------------------------------------------------
  // RSVP
  // ---------------------------------------------------------------------

  Future<void> setRsvpStatus(String postId, RsvpStatus status) async {
    final post = postById(postId);
    if (post == null) return;
    final previous = rsvpFor(postId);
    if (previous == status) return;

    if (previous == RsvpStatus.going && post.goingCount > 0) {
      post.goingCount -= 1;
    }
    if (previous == RsvpStatus.interested && post.interestedCount > 0) {
      post.interestedCount -= 1;
    }
    if (status == RsvpStatus.going) post.goingCount += 1;
    if (status == RsvpStatus.interested) post.interestedCount += 1;

    if (status == RsvpStatus.none) {
      _rsvpStatuses.remove(postId);
    } else {
      _rsvpStatuses[postId] = status;
    }

    await _persistRsvps();
    notifyListeners();
  }

  // ---------------------------------------------------------------------
  // Saved posts & clubs
  // ---------------------------------------------------------------------

  Future<void> toggleSaved(String postId) async {
    if (!_savedPostIds.remove(postId)) {
      _savedPostIds.add(postId);
    }
    await _prefs.setStringList(_kSavedPostIds, _savedPostIds.toList());
    notifyListeners();
  }

  Future<void> toggleJoinClub(String clubId) async {
    if (!_joinedClubIds.remove(clubId)) {
      _joinedClubIds.add(clubId);
    }
    await _prefs.setStringList(_kJoinedClubIds, _joinedClubIds.toList());
    notifyListeners();
  }

  // ---------------------------------------------------------------------
  // Chat
  // ---------------------------------------------------------------------

  Future<void> sendMessage(String conversationId, String text) async {
    final conversation = conversationById(conversationId);
    final trimmed = text.trim();
    if (conversation == null || trimmed.isEmpty) return;

    conversation.messages.add(ChatMessage(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      senderName: _currentUser?.name ?? 'You',
      text: trimmed,
      timestamp: DateTime.now(),
      isMe: true,
    ));

    await _persistChatExtras();
    notifyListeners();
  }

  // ---------------------------------------------------------------------
  // Notifications
  // ---------------------------------------------------------------------

  Future<void> markNotificationRead(String id) async {
    if (_readNotificationIds.add(id)) {
      await _prefs.setStringList(
          _kReadNotificationIds, _readNotificationIds.toList());
      notifyListeners();
    }
  }

  Future<void> markAllNotificationsRead() async {
    _readNotificationIds.addAll(_notifications.map((n) => n.id));
    await _prefs.setStringList(
        _kReadNotificationIds, _readNotificationIds.toList());
    notifyListeners();
  }
}
