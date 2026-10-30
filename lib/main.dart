import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/data/app_database.dart';
import 'core/data/providers.dart';
import 'core/settings/settings_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  final prefs = await SharedPreferences.getInstance();
  final database = await AppDatabase.open();

  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
        databaseProvider.overrideWithValue(database),
      ],
      child: const AmalApp(),
    ),
  );
}
