import 'package:amal_tracker/features/prayer/prayer_models.dart';
import 'package:amal_tracker/features/tasbeeh/tasbeeh_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('PrayerData counts only today for today stats', () {
    final now = DateTime.now();
    final data = PrayerData(
      logs: [
        PrayerLog(id: '1', prayerKey: 'duha', rakats: 2, loggedAt: now),
        PrayerLog(id: '2', prayerKey: 'witr', rakats: 3, loggedAt: now),
        PrayerLog(
          id: '3',
          prayerKey: 'duha',
          rakats: 4,
          loggedAt: now.subtract(const Duration(days: 3)),
        ),
      ],
      customTypes: const [],
    );
    expect(data.todayCount, 2);
    expect(data.todayRakats, 5);
    expect(data.last7Count, 3);
  });

  test('TasbeehData sums counts', () {
    final now = DateTime.now();
    final data = TasbeehData(
      sessions: [
        TasbeehSession(id: 'a', dhikrKey: 'x', count: 33, loggedAt: now),
        TasbeehSession(id: 'b', dhikrKey: 'y', count: 67, loggedAt: now),
      ],
      customs: const [],
    );
    expect(data.todayTotal, 100);
  });

  test('model maps round-trip', () {
    final log = PrayerLog(
      id: 'z',
      prayerKey: 'witr',
      rakats: 3,
      loggedAt: DateTime.fromMillisecondsSinceEpoch(1700000000000),
      note: 'n',
    );
    final back = PrayerLog.fromMap(log.toMap());
    expect(back.id, 'z');
    expect(back.rakats, 3);
    expect(back.note, 'n');
    expect(back.loggedAt, log.loggedAt);
  });
}
