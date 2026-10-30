import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/amal_card.dart';
import '../../core/widgets/progress_ring.dart';
import 'tasbeeh_dialogs.dart';
import 'tasbeeh_models.dart';
import 'tasbeeh_providers.dart';

/// Full-screen wrapper used when opened from the Home quick actions.
class TasbeehPage extends StatelessWidget {
  const TasbeehPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.tasbeeh)),
      body: const TasbeehTab(),
    );
  }
}

class _DhikrInfo {
  const _DhikrInfo({
    required this.key,
    required this.text,
    required this.label,
    required this.target,
    required this.isPreset,
  });

  final String key;
  final String text;
  final String label;
  final int target;
  final bool isPreset;
}

List<_DhikrInfo> _buildList(AppStrings s, TasbeehData data) => [
      for (final p in dhikrPresets)
        _DhikrInfo(
          key: p.key,
          text: p.arabic,
          label: s.t('dhikr_${p.key}'),
          target: p.target,
          isPreset: true,
        ),
      for (final c in data.customs)
        _DhikrInfo(
          key: c.id,
          text: c.text,
          label: c.text.split('\n').first,
          target: c.target,
          isPreset: false,
        ),
    ];

class TasbeehTab extends ConsumerWidget {
  const TasbeehTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(tasbeehProvider);
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (data) => _TasbeehContent(data: data),
    );
  }
}

class _TasbeehContent extends ConsumerWidget {
  const _TasbeehContent({required this.data});

  final TasbeehData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final counter = ref.watch(counterProvider);
    final notifier = ref.read(counterProvider.notifier);

    final list = _buildList(s, data);
    final info = list.firstWhere(
      (d) => d.key == counter.dhikrKey,
      orElse: () => list.first,
    );
    final reached = counter.count >= info.target;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (final d in list)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    selected: d.key == info.key,
                    onSelected: (_) => _select(context, ref, d.key),
                    label: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 150),
                      child: Text(
                        d.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ActionChip(
                avatar: const Icon(Icons.add_rounded, size: 18),
                label: Text(s.customChip),
                onPressed: () => _addCustom(context, ref),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AmalCard(
          child: Column(
            children: [
              Text(
                info.text,
                textAlign: TextAlign.center,
                style: info.isPreset
                    ? const TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 34,
                        height: 1.6,
                        fontWeight: FontWeight.w700,
                      )
                    : textTheme.titleLarge,
              ),
              if (info.isPreset)
                Text(
                  info.label,
                  style: textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurface.withAlpha(170),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              final c = notifier.increment();
              if (c == info.target) {
                HapticFeedback.heavyImpact();
              } else {
                HapticFeedback.selectionClick();
              }
            },
            child: ProgressRing(
              size: 250,
              stroke: 14,
              progress: counter.count / info.target,
              duration: const Duration(milliseconds: 150),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${counter.count}',
                    style: textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${s.target} ${info.target}',
                    style: textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurface.withAlpha(160),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reached ? s.targetReached : s.tapToCount,
                    style: textTheme.labelMedium?.copyWith(
                      color: reached ? AppColors.gold : scheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            IconButton.outlined(
              tooltip: s.undo,
              onPressed: counter.count == 0 ? null : notifier.undo,
              icon: const Icon(Icons.undo_rounded),
            ),
            const SizedBox(width: 8),
            IconButton.outlined(
              tooltip: s.reset,
              onPressed: counter.count == 0 ? null : notifier.reset,
              icon: const Icon(Icons.refresh_rounded),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: counter.count == 0
                    ? null
                    : () async {
                        final messenger = ScaffoldMessenger.of(context);
                        await notifier.save();
                        messenger
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(content: Text(s.sessionSaved)),
                          );
                      },
                icon: const Icon(Icons.check_rounded),
                label: Text(s.saveSession),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        AmalCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Stat(value: '${data.todayTotal}', label: s.statToday),
              _Stat(value: '${data.last7Total}', label: s.statLast7),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _select(BuildContext context, WidgetRef ref, String key) async {
    final s = AppStrings.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final saved = await ref.read(counterProvider.notifier).select(key);
    if (saved) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(s.sessionSaved)));
    }
  }

  Future<void> _addCustom(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<NewDhikr>(
      context: context,
      builder: (_) => const AddCustomDhikrDialog(),
    );
    if (result == null) return;
    final id = await ref
        .read(tasbeehProvider.notifier)
        .addCustom(result.text, result.target);
    await ref.read(counterProvider.notifier).select(id);
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
