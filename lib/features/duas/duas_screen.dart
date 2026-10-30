import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/widgets/feature_placeholder.dart';

class DuasScreen extends StatelessWidget {
  const DuasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.duas)),
      body: FeaturePlaceholder(
        icon: Icons.menu_book_outlined,
        title: s.duas,
        body: s.duasBody,
      ),
    );
  }
}
