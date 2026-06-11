import 'package:intl/intl.dart';

/// "Today • 9:00 AM", "Tomorrow • 5:00 PM", or "Jun 12 • 9:00 AM".
String formatEventDate(DateTime dt) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final date = DateTime(dt.year, dt.month, dt.day);
  final diff = date.difference(today).inDays;
  final time = DateFormat('h:mm a').format(dt);

  if (diff == 0) return 'Today • $time';
  if (diff == 1) return 'Tomorrow • $time';
  if (diff == -1) return 'Yesterday • $time';
  if (diff > 1 && diff < 7) return '${DateFormat('EEEE').format(dt)} • $time';
  return '${DateFormat('MMM d').format(dt)} • $time';
}

/// "Jun 12, 2026" - used for opportunity deadlines and longer descriptions.
String formatFullDate(DateTime dt) => DateFormat('MMM d, yyyy').format(dt);

/// "3 days left" / "Apply today!" / "Deadline passed" for opportunities.
String formatDeadline(DateTime dt) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final date = DateTime(dt.year, dt.month, dt.day);
  final diff = date.difference(today).inDays;

  if (diff < 0) return 'Deadline passed';
  if (diff == 0) return 'Apply today!';
  if (diff == 1) return '1 day left';
  return '$diff days left';
}

/// Short relative time for chat bubbles and notifications, e.g. "2h ago".
String formatRelativeTime(DateTime dt) {
  final diff = DateTime.now().difference(dt);
  if (diff.inSeconds < 60) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays == 1) return 'Yesterday';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  return DateFormat('MMM d').format(dt);
}

/// "9:41 AM" - used inside chat bubbles.
String formatTime(DateTime dt) => DateFormat('h:mm a').format(dt);

/// Day-section header used to group "My Schedule" entries, e.g. "Today",
/// "Tomorrow", "Friday", or "Monday, Jun 15" for dates further away.
String formatDayHeader(DateTime dt) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final date = DateTime(dt.year, dt.month, dt.day);
  final diff = date.difference(today).inDays;

  if (diff == 0) return 'Today';
  if (diff == 1) return 'Tomorrow';
  if (diff < 0) return 'Past';
  if (diff < 7) return DateFormat('EEEE').format(dt);
  return DateFormat('EEEE, MMM d').format(dt);
}
