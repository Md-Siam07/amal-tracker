import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/l10n/app_strings.dart';

class NewDhikr {
  const NewDhikr(this.text, this.target);

  final String text;
  final int target;
}

class AddCustomDhikrDialog extends StatefulWidget {
  const AddCustomDhikrDialog({super.key});

  @override
  State<AddCustomDhikrDialog> createState() => _AddCustomDhikrDialogState();
}

class _AddCustomDhikrDialogState extends State<AddCustomDhikrDialog> {
  final _text = TextEditingController();
  final _target = TextEditingController(text: '33');

  @override
  void dispose() {
    _text.dispose();
    _target.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return AlertDialog(
      title: Text(s.newDhikr),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _text,
              autofocus: true,
              minLines: 2,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: s.dhikrText,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _target,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: s.targetCount,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(s.cancel),
        ),
        FilledButton(
          onPressed: () {
            final text = _text.text.trim();
            final target = int.tryParse(_target.text) ?? 0;
            if (text.isEmpty) return;
            Navigator.pop(context, NewDhikr(text, target < 1 ? 1 : target));
          },
          child: Text(s.add),
        ),
      ],
    );
  }
}
