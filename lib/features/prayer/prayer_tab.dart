import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/util/date_utils.dart';
import '../../core/widgets/amal_card.dart';
import '../../core/widgets/section_title.dart';
import 'prayer_dialogs.dart';
import 'prayer_models.dart';
import 'prayer_providers.dart';

/// Full-screen wrapper used when opened from the Home quick actions.
class PrayerPage extends StatelessWidget {
  const PrayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.prayer)),
      body: const PrayerTab(),
    );
  }
}

class _PrayerItem {
  const _PrayerItem(this.key, this.name, this.rakats);

  final String key;
  final String name;
  final int rakats;
}

class PrayerTab extends ConsumerWidget {
  const PrayerTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(prayerProvider);
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (data) => _PrayerContent(data: data),
    );
  }
}

class _PrayerContent extends ConsumerWidget {
  const _PrayerContent({required this.data});

  final PrayerData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).toString();

    final items = <_PrayerItem>[
      for (final p in prayerPresets)
        _PrayerItem(p.key, s.t('prayer_${p.key}'), p.defaultRakats),
      for (final c in data.customTypes)
        _PrayerItem(c.id, c.name, c.defaultRakats),
    ];
    final names = {for (final i in items) i.key: i.name};
    final history = data.logs.take(60).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        AmalCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Stat(value: '${data.todayCount}', label: '${s.statToday} · ${s.statPrayers}'),
              _Stat(value: '${data.todayRakats}', label: '${s.statToday} · ${s.statRakats}'),
              _Stat(value: '${data.last7Count}', label: s.statLast7),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SectionTitle(s.prayer),
        Text(
          s.tapToLog,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurface.withAlpha(150),
              ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final item in items)
              _PrayerChip(
                label: item.name,
                trailing: '${item.rakats}',
                onTap: () => _log(context, ref, item, null),
                onLongPress: () => _logWithDetails(context, ref, item),
              ),
            _PrayerChip(
              label: s.customChip,
              icon: Icons.add_rounded,
              onTap: () => _addCustom(context, ref),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SectionTitle(s.history),
        if (history.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              s.noHistory,
              style: TextStyle(color: scheme.onSurface.withAlpha(150)),
            ),
          ),
        for (final log in history)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _HistoryTile(
              log: log,
              name: names[log.prayerKey] ?? s.customPrayerFallback,
              locale: locale,
            ),
          ),
      ],
    );
  }

  Future<void> _log(
    BuildContext context,
    WidgetRef ref,
    _PrayerItem item,
    PrayerLogDraft? draft,
  ) async {
    HapticFeedback.lightImpact();
    final s = AppStrings.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final controller = ref.read(prayerProvider.notifier);

    final entry = await controller.log(
      key: item.key,
      rakats: draft?.rakats ?? item.rakats,
      at: draft?.at,
      note: draft?.note,
    );

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(s.fmt('prayerLogged', {'name': item.name})),
          action: SnackBarAction(
            label: s.undo,
            onPressed: () => controller.delete(entry.id),
          ),
        ),
      );
  }

  Future<void> _logWithDetails(
    BuildContext context,
    WidgetRef ref,
    _PrayerItem item,
  ) async {
    final draft = await showModalBottomSheet<PrayerLogDraft>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => PrayerLogSheet(
        title: item.name,
        initialRakats: item.rakats,
      ),
    );
    if (draft == null || !context.mounted) return;
    await _log(context, ref, item, draft);
  }

  Future<void> _addCustom(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(prayerProvider.notifier);
    final result = await showDialog<NewCustomPrayer>(
      context: context,
      builder: (_) => const AddCustomPrayerDialog(),
    );
    if (result == null) return;
    await controller.addCustomType(result.name, result.rakats);
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _PrayerChip extends StatelessWidget {
  const _PrayerChip({
    required this.label,
    required this.onTap,
    this.onLongPress,
    this.trailing,
    this.icon,
  });

  final String label;
  final String? trailing;
  final IconData? icon;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = BorderRadius.circular(30);

    return Material(
      color: isDark ? AppColors.nightCard : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: AppColors.gold.withAlpha(120)),
      ),
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: scheme.primary),
                const SizedBox(width: 4),
              ],
              Text(label, style: Theme.of(context).textTheme.labelLarge),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withAlpha(60),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    trailing!,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryTile extends ConsumerWidget {
  const _HistoryTile({
    required this.log,
    required this.name,
    required this.locale,
  });

  final PrayerLog log;
  final String name;
  final String locale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;
    final time = DateFormat.jm(locale).format(log.loggedAt);
    final when = isSameDay(log.loggedAt, DateTime.now())
        ? time
        : '${DateFormat.MMMd(locale).format(log.loggedAt)}, $time';
    final subtitle = [
      s.fmt('rakatsCount', {'n': '${log.rakats}'}),
      when,
      if (log.note != null) log.note!,
    ].join(' · ');

    return Dismissible(
      key: ValueKey(log.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: scheme.error.withAlpha(40),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Icon(Icons.delete_outline_rounded, color: scheme.error),
      ),
      onDismissed: (_) {
        final controller = ref.read(prayerProvider.notifier);
        final messenger = ScaffoldMessenger.of(context);
        controller.delete(log.id);
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(s.deleted),
              action: SnackBarAction(
                label: s.undo,
                onPressed: () => controller.restore(log),
              ),
            ),
          );
      },
      child: AmalCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(Icons.mosque_outlined, color: scheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurface.withAlpha(160),
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
