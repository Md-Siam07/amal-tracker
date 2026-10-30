import '../../core/util/date_utils.dart';

class DhikrPreset {
  const DhikrPreset(this.key, this.arabic, this.target);

  final String key;
  final String arabic;
  final int target;
}

const dhikrPresets = <DhikrPreset>[
  DhikrPreset('subhanallah', 'سُبْحَانَ اللّٰهِ', 33),
  DhikrPreset('alhamdulillah', 'الْحَمْدُ لِلّٰهِ', 33),
  DhikrPreset('allahuakbar', 'اللّٰهُ أَكْبَرُ', 34),
  DhikrPreset('la_ilaha', 'لَا إِلٰهَ إِلَّا اللّٰهُ', 100),
  DhikrPreset('astaghfirullah', 'أَسْتَغْفِرُ اللّٰهَ', 100),
  DhikrPreset('salawat', 'اللّٰهُمَّ صَلِّ عَلٰى مُحَمَّدٍ', 100),
];

class TasbeehSession {
  const TasbeehSession({
    required this.id,
    required this.dhikrKey,
    required this.count,
    required this.loggedAt,
  });

  final String id;
  final String dhikrKey;
  final int count;
  final DateTime loggedAt;

  Map<String, Object?> toMap() => {
        'id': id,
        'dhikr_key': dhikrKey,
        'count': count,
        'logged_at': loggedAt.millisecondsSinceEpoch,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
        'deleted_at': null,
      };

  factory TasbeehSession.fromMap(Map<String, Object?> m) => TasbeehSession(
        id: m['id'] as String,
        dhikrKey: m['dhikr_key'] as String,
        count: m['count'] as int,
        loggedAt: DateTime.fromMillisecondsSinceEpoch(m['logged_at'] as int),
      );
}

class CustomDhikr {
  const CustomDhikr({
    required this.id,
    required this.text,
    required this.target,
  });

  final String id;
  final String text;
  final int target;

  Map<String, Object?> toMap() => {
        'id': id,
        'text': text,
        'target': target,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
        'deleted_at': null,
      };

  factory CustomDhikr.fromMap(Map<String, Object?> m) => CustomDhikr(
        id: m['id'] as String,
        text: m['text'] as String,
        target: m['target'] as int,
      );
}

class TasbeehData {
  const TasbeehData({required this.sessions, required this.customs});

  static const empty = TasbeehData(sessions: [], customs: []);

  final List<TasbeehSession> sessions;
  final List<CustomDhikr> customs;

  int get todayTotal {
    final now = DateTime.now();
    return sessions
        .where((x) => isSameDay(x.loggedAt, now))
        .fold(0, (sum, x) => sum + x.count);
  }

  int get last7Total {
    final from = daysAgoStart(6);
    return sessions
        .where((x) => !x.loggedAt.isBefore(from))
        .fold(0, (sum, x) => sum + x.count);
  }
}
