import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/widgets/feature_placeholder.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.reminders)),
      body: FeaturePlaceholder(
        icon: Icons.notifications_none_rounded,
        title: s.reminders,
        body: s.remindersBody,
      ),
    );
  }
}
