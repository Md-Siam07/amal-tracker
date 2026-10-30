DateTime startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Midnight [days] days before today (days = 6 gives a 7-day window).
DateTime daysAgoStart(int days) {
  final n = DateTime.now();
  return DateTime(n.year, n.month, n.day - days);
}
