import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/widgets/number_stepper.dart';

class NewCustomPrayer {
  const NewCustomPrayer(this.name, this.rakats);

  final String name;
  final int rakats;
}

class AddCustomPrayerDialog extends StatefulWidget {
  const AddCustomPrayerDialog({super.key});

  @override
  State<AddCustomPrayerDialog> createState() => _AddCustomPrayerDialogState();
}

class _AddCustomPrayerDialogState extends State<AddCustomPrayerDialog> {
  final _name = TextEditingController();
  int _rakats = 2;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return AlertDialog(
      title: Text(s.addCustomPrayer),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _name,
            autofocus: true,
            decoration: InputDecoration(labelText: s.name),
          ),
          const SizedBox(height: 16),
          NumberStepper(
            label: s.defaultRakats,
            value: _rakats,
            onChanged: (v) => setState(() => _rakats = v),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(s.cancel),
        ),
        FilledButton(
          onPressed: () {
            final name = _name.text.trim();
            if (name.isEmpty) return;
            Navigator.pop(context, NewCustomPrayer(name, _rakats));
          },
          child: Text(s.add),
        ),
      ],
    );
  }
}

class PrayerLogDraft {
  const PrayerLogDraft({required this.rakats, required this.at, this.note});

  final int rakats;
  final DateTime at;
  final String? note;
}

/// Bottom sheet to log with custom rakats, a back-dated time, and a note.
class PrayerLogSheet extends StatefulWidget {
  const PrayerLogSheet({
    super.key,
    required this.title,
    required this.initialRakats,
  });

  final String title;
  final int initialRakats;

  @override
  State<PrayerLogSheet> createState() => _PrayerLogSheetState();
}

class _PrayerLogSheetState extends State<PrayerLogSheet> {
  late int _rakats = widget.initialRakats;
  DateTime _at = DateTime.now();
  final _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _at,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
    );
    if (date == null) return;
    _apply(DateTime(date.year, date.month, date.day, _at.hour, _at.minute));
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_at),
    );
    if (time == null) return;
    _apply(DateTime(_at.year, _at.month, _at.day, time.hour, time.minute));
  }

  void _apply(DateTime value) {
    final now = DateTime.now();
    setState(() => _at = value.isAfter(now) ? now : value);
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final material = MaterialLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            NumberStepper(
              label: s.statRakats,
              value: _rakats,
              onChanged: (v) => setState(() => _rakats = v),
            ),
            const SizedBox(height: 12),
            Text(s.dateTime, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_today_rounded, size: 18),
                    label: Text(material.formatMediumDate(_at)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickTime,
                    icon: const Icon(Icons.schedule_rounded, size: 18),
                    label: Text(material.formatTimeOfDay(
                      TimeOfDay.fromDateTime(_at),
                    )),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _note,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: s.note,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(
                  context,
                  PrayerLogDraft(rakats: _rakats, at: _at, note: _note.text),
                ),
                child: Text(s.save),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
