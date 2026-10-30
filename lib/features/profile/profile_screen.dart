import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/settings/settings_controller.dart';
import '../../core/widgets/amal_card.dart';
import '../../core/widgets/section_title.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppStrings.of(context);
    final settings = ref.watch(settingsProvider);
    final controller = ref.read(settingsProvider.notifier);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(s.profile)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          SectionTitle(s.account),
          AmalCard(
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: scheme.primary.withAlpha(35),
                  child: Icon(Icons.person_outline_rounded,
                      color: scheme.primary),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(s.signInSoon)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SectionTitle(s.appearance),
          AmalCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.theme,
                    style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<ThemeMode>(
                    showSelectedIcon: false,
                    segments: [
                      ButtonSegment(
                          value: ThemeMode.light, label: Text(s.light)),
                      ButtonSegment(
                          value: ThemeMode.dark, label: Text(s.dark)),
                      ButtonSegment(
                          value: ThemeMode.system, label: Text(s.system)),
                    ],
                    selected: {settings.themeMode},
                    onSelectionChanged: (v) =>
                        controller.setThemeMode(v.first),
                  ),
                ),
                const SizedBox(height: 18),
                Text(s.language,
                    style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<String>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(value: 'en', label: Text('English')),
                      ButtonSegment(value: 'bn', label: Text('বাংলা')),
                    ],
                    selected: {settings.locale.languageCode},
                    onSelectionChanged: (v) =>
                        controller.setLanguage(v.first),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SectionTitle(s.about),
          AmalCard(
            child: Row(
              children: [
                Expanded(child: Text(s.appName)),
                Text('${s.version} 0.1.0',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
