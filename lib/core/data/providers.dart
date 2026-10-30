import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';

/// Overridden in main() with the opened database.
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('databaseProvider not overridden'),
);
