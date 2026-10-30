import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/amal_card.dart';
import '../../core/widgets/geometric_pattern.dart';
import '../../core/widgets/progress_ring.dart';
import '../../core/widgets/section_title.dart';
import '../prayer/prayer_providers.dart';
import '../prayer/prayer_tab.dart';
import '../tasbeeh/tasbeeh_providers.dart';
import '../tasbeeh/tasbeeh_tab.dart';

// Temporary daily targets until the Goals feature is built.
const _defaultPrayerTarget = 4;
const _defaultTasbeehTarget = 100;

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;
    final prayerToday = ref.watch(prayerProvider).valueOrNull?.todayCount ?? 0;
    final tasbeehToday =
        ref.watch(tasbeehProvider).valueOrNull?.todayTotal ?? 0;

    void open(Widget page) => Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => page));

    void soon() => ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(s.comingSoon)));

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          const _HeaderCard(),
          const SizedBox(height: 24),
          SectionTitle(s.todaysGoals),
          AmalCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _GoalRing(
                      label: s.prayer,
                      progress: prayerToday / _defaultPrayerTarget,
                      centerText: '$prayerToday/$_defaultPrayerTarget',
                    ),
                    _GoalRing(
                      label: s.tasbeeh,
                      progress: tasbeehToday / _defaultTasbeehTarget,
                      centerText: '$tasbeehToday/$_defaultTasbeehTarget',
                    ),
                    _GoalRing(label: s.quran, progress: 0, centerText: '—'),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  s.previewNote,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurface.withAlpha(140),
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SectionTitle(s.quickActions),
          Row(
            children: [
              _ActionTile(
                icon: Icons.mosque_outlined,
                label: s.logPrayer,
                onTap: () => open(const PrayerPage()),
              ),
              const SizedBox(width: 10),
              _ActionTile(
                icon: Icons.touch_app_outlined,
                label: s.tasbeeh,
                onTap: () => open(const TasbeehPage()),
              ),
              const SizedBox(width: 10),
              _ActionTile(
                icon: Icons.bookmark_border_rounded,
                label: s.bookmark,
                onTap: soon,
              ),
              const SizedBox(width: 10),
              _ActionTile(
                icon: Icons.edit_note_rounded,
                label: s.addDua,
                onTap: soon,
              ),
            ],
          ),
          const SizedBox(height: 24),
          SectionTitle(s.nextReminder),
          AmalCard(
            child: Row(
              children: [
                Icon(Icons.notifications_none_rounded, color: scheme.primary),
                const SizedBox(width: 12),
                Expanded(child: Text(s.noReminders)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard();

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final locale = Localizations.localeOf(context).toString();
    final date = DateFormat.yMMMMEEEEd(locale).format(DateTime.now());
    final textTheme = Theme.of(context).textTheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.emeraldDeep, AppColors.emerald],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: GeometricPatternPainter(
                  color: Colors.white.withAlpha(26),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'السلام عليكم',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppColors.goldLight,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    s.greeting,
                    style: textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    date,
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withAlpha(190),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalRing extends StatelessWidget {
  const _GoalRing({
    required this.label,
    required this.progress,
    required this.centerText,
  });

  final String label;
  final double progress;
  final String centerText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProgressRing(
          progress: progress,
          child: Text(
            centerText,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Expanded(
      child: AmalCard(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gold.withAlpha(45),
              ),
              child: Icon(icon, color: scheme.primary),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}
