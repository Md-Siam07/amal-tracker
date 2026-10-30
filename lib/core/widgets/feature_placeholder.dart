import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../theme/app_colors.dart';
import 'geometric_pattern.dart';

/// Friendly empty-state used until each feature is built.
class FeaturePlaceholder extends StatelessWidget {
  const FeaturePlaceholder({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final s = AppStrings.of(context);

    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: GeometricPatternPainter(
              color: scheme.onSurface.withAlpha(14),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.gold.withAlpha(40),
                  ),
                  child: Icon(icon, size: 40, color: scheme.primary),
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  body,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurface.withAlpha(170),
                      ),
                ),
                const SizedBox(height: 16),
                Chip(
                  label: Text(s.comingSoon),
                  side: BorderSide(color: AppColors.gold.withAlpha(120)),
                  backgroundColor: Colors.transparent,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
