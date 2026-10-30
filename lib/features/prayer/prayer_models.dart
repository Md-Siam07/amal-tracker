import '../../core/util/date_utils.dart';

class PrayerPreset {
  const PrayerPreset(this.key, this.defaultRakats);

  final String key;
  final int defaultRakats;
}

/// Default rakat counts are only starting points; the user can edit them when
/// logging. Have a qualified reviewer confirm the list before public release.
const prayerPresets = <PrayerPreset>[
  PrayerPreset('tahajjud', 2),
  PrayerPreset('ishraq', 2),
  PrayerPreset('duha', 2),
  PrayerPreset('awwabin', 2),
  PrayerPreset('tahiyyatul_wudu', 2),
  PrayerPreset('tahiyyatul_masjid', 2),
  PrayerPreset('tawbah', 2),
  PrayerPreset('hajah', 2),
  PrayerPreset('witr', 3),
  PrayerPreset('taraweeh', 2),
  PrayerPreset('sunnah_fajr', 2),
  PrayerPreset('sunnah_dhuhr', 2),
  PrayerPreset('sunnah_maghrib', 2),
  PrayerPreset('sunnah_isha', 2),
];

class PrayerLog {
  const PrayerLog({
    required this.id,
    required this.prayerKey,
    required this.rakats,
    required this.loggedAt,
    this.note,
  });

  final String id;
  final String prayerKey;
  final int rakats;
  final DateTime loggedAt;
  final String? note;

  Map<String, Object?> toMap() => {
        'id': id,
        'prayer_key': prayerKey,
        'rakats': rakats,
        'logged_at': loggedAt.millisecondsSinceEpoch,
        'note': note,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
        'deleted_at': null,
      };

  factory PrayerLog.fromMap(Map<String, Object?> m) => PrayerLog(
        id: m['id'] as String,
        prayerKey: m['prayer_key'] as String,
        rakats: m['rakats'] as int,
        loggedAt: DateTime.fromMillisecondsSinceEpoch(m['logged_at'] as int),
        note: m['note'] as String?,
      );
}

class CustomPrayerType {
  const CustomPrayerType({
    required this.id,
    required this.name,
    required this.defaultRakats,
  });

  final String id;
  final String name;
  final int defaultRakats;

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'default_rakats': defaultRakats,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
        'deleted_at': null,
      };

  factory CustomPrayerType.fromMap(Map<String, Object?> m) => CustomPrayerType(
        id: m['id'] as String,
        name: m['name'] as String,
        defaultRakats: m['default_rakats'] as int,
      );
}

class PrayerData {
  const PrayerData({required this.logs, required this.customTypes});

  static const empty = PrayerData(logs: [], customTypes: []);

  final List<PrayerLog> logs;
  final List<CustomPrayerType> customTypes;

  List<PrayerLog> get today {
    final now = DateTime.now();
    return logs.where((l) => isSameDay(l.loggedAt, now)).toList();
  }

  int get todayCount => today.length;

  int get todayRakats => today.fold(0, (sum, l) => sum + l.rakats);

  int get last7Count {
    final from = daysAgoStart(6);
    return logs.where((l) => !l.loggedAt.isBefore(from)).length;
  }
}
