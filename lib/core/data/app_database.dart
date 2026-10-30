import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Local-first SQLite database. All rows carry updated_at / deleted_at so a
/// cloud sync layer can be added later without changing the schema.
class AppDatabase {
  AppDatabase(this.db);

  final Database db;

  static Future<AppDatabase> open() async {
    final dir = await getDatabasesPath();
    final db = await openDatabase(
      p.join(dir, 'amal_tracker.db'),
      version: 1,
      onCreate: _onCreate,
    );
    return AppDatabase(db);
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE custom_prayer_types (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        default_rakats INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        deleted_at INTEGER
      )''');
    await db.execute('''
      CREATE TABLE prayer_logs (
        id TEXT PRIMARY KEY,
        prayer_key TEXT NOT NULL,
        rakats INTEGER NOT NULL,
        logged_at INTEGER NOT NULL,
        note TEXT,
        updated_at INTEGER NOT NULL,
        deleted_at INTEGER
      )''');
    await db.execute(
        'CREATE INDEX idx_prayer_logged_at ON prayer_logs(logged_at)');
    await db.execute('''
      CREATE TABLE custom_dhikr (
        id TEXT PRIMARY KEY,
        text TEXT NOT NULL,
        target INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        deleted_at INTEGER
      )''');
    await db.execute('''
      CREATE TABLE tasbeeh_sessions (
        id TEXT PRIMARY KEY,
        dhikr_key TEXT NOT NULL,
        count INTEGER NOT NULL,
        logged_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        deleted_at INTEGER
      )''');
    await db.execute(
        'CREATE INDEX idx_tasbeeh_logged_at ON tasbeeh_sessions(logged_at)');
  }
}
