import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Overridden in main() with the real instance.
final sharedPrefsProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPrefsProvider not overridden'),
);

class SettingsState {
  const SettingsState({required this.themeMode, required this.locale});

  final ThemeMode themeMode;
  final Locale locale;

  SettingsState copyWith({ThemeMode? themeMode, Locale? locale}) =>
      SettingsState(
        themeMode: themeMode ?? this.themeMode,
        locale: locale ?? this.locale,
      );
}

final settingsProvider =
    NotifierProvider<SettingsController, SettingsState>(SettingsController.new);

class SettingsController extends Notifier<SettingsState> {
  static const _kTheme = 'themeMode';
  static const _kLang = 'languageCode';

  @override
  SettingsState build() {
    final prefs = ref.read(sharedPrefsProvider);
    final savedTheme = prefs.getString(_kTheme);
    final theme = ThemeMode.values.firstWhere(
      (m) => m.name == savedTheme,
      orElse: () => ThemeMode.system,
    );
    final lang = prefs.getString(_kLang) ?? 'en';
    return SettingsState(themeMode: theme, locale: Locale(lang));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await ref.read(sharedPrefsProvider).setString(_kTheme, mode.name);
  }

  Future<void> setLanguage(String code) async {
    state = state.copyWith(locale: Locale(code));
    await ref.read(sharedPrefsProvider).setString(_kLang, code);
  }
}
