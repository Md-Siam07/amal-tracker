import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/feature_placeholder.dart';
import '../prayer/prayer_tab.dart';
import '../tasbeeh/tasbeeh_tab.dart';

class AmalScreen extends StatelessWidget {
  const AmalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(s.amal),
          bottom: TabBar(
            labelColor: scheme.onSurface,
            unselectedLabelColor: scheme.onSurface.withAlpha(150),
            indicatorColor: AppColors.gold,
            dividerColor: Colors.transparent,
            tabs: [
              Tab(text: s.prayer),
              Tab(text: s.quran),
              Tab(text: s.tasbeeh),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const PrayerTab(),
            FeaturePlaceholder(
              icon: Icons.menu_book_rounded,
              title: s.quran,
              body: s.quranBody,
            ),
            const TasbeehTab(),
          ],
        ),
      ),
    );
  }
}
