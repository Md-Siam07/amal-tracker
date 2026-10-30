import 'package:sqflite/sqflite.dart';

import 'prayer_models.dart';

class PrayerRepository {
  PrayerRepository(this._db);

  final Database _db;

  Future<List<PrayerLog>> logsSince(DateTime from) async {
    final rows = await _db.query(
      'prayer_logs',
      where: 'deleted_at IS NULL AND logged_at >= ?',
      whereArgs: [from.millisecondsSinceEpoch],
      orderBy: 'logged_at DESC',
    );
    return rows.map(PrayerLog.fromMap).toList();
  }

  /// Insert or restore (replace clears deleted_at, which powers Undo).
  Future<void> upsertLog(PrayerLog log) => _db.insert(
        'prayer_logs',
        log.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

  Future<void> deleteLog(String id) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return _db.update(
      'prayer_logs',
      {'deleted_at': now, 'updated_at': now},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<CustomPrayerType>> customTypes() async {
    final rows = await _db.query(
      'custom_prayer_types',
      where: 'deleted_at IS NULL',
      orderBy: 'name COLLATE NOCASE',
    );
    return rows.map(CustomPrayerType.fromMap).toList();
  }

  Future<void> addCustomType(CustomPrayerType type) => _db.insert(
        'custom_prayer_types',
        type.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
}
