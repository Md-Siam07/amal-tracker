import 'package:sqflite/sqflite.dart';

import 'tasbeeh_models.dart';

class TasbeehRepository {
  TasbeehRepository(this._db);

  final Database _db;

  Future<List<TasbeehSession>> sessionsSince(DateTime from) async {
    final rows = await _db.query(
      'tasbeeh_sessions',
      where: 'deleted_at IS NULL AND logged_at >= ?',
      whereArgs: [from.millisecondsSinceEpoch],
      orderBy: 'logged_at DESC',
    );
    return rows.map(TasbeehSession.fromMap).toList();
  }

  Future<void> addSession(TasbeehSession session) => _db.insert(
        'tasbeeh_sessions',
        session.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

  Future<List<CustomDhikr>> customDhikr() async {
    final rows = await _db.query(
      'custom_dhikr',
      where: 'deleted_at IS NULL',
      orderBy: 'updated_at ASC',
    );
    return rows.map(CustomDhikr.fromMap).toList();
  }

  Future<void> addCustomDhikr(CustomDhikr dhikr) => _db.insert(
        'custom_dhikr',
        dhikr.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
}
