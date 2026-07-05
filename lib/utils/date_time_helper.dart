/// Formats a [DateTime] into a human-readable relative/absolute string.
/// Examples: "Just now", "5m ago", "3h ago", "Jul 5", "Dec 12, 2024".
String formatNoteDate(DateTime dt) {
  final now = DateTime.now();
  final diff = now.difference(dt);

  if (diff.inSeconds < 60) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';

  // Absolute date
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  final month = months[dt.month - 1];
  final day = dt.day;
  final year = dt.year;

  if (year == now.year) return '$month $day';
  return '$month $day, $year';
}
