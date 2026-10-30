import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AmalCard extends StatelessWidget {
  const AmalCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = BorderRadius.circular(22);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.nightCard : Colors.white,
        borderRadius: radius,
        border: Border.all(
          color: isDark
              ? Colors.white.withAlpha(18)
              : AppColors.goldLight.withAlpha(110),
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: AppColors.emerald.withAlpha(20),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
