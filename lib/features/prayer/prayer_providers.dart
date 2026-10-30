import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/providers.dart';
import '../../core/util/date_utils.dart';
import '../../core/util/ids.dart';
import 'prayer_models.dart';
import 'prayer_repository.dart';

final prayerRepositoryProvider = Provider<PrayerRepository>(
  (ref) => PrayerRepository(ref.watch(databaseProvider).db),
);

final prayerProvider =
    AsyncNotifierProvider<PrayerController, PrayerData>(PrayerController.new);

class PrayerController extends AsyncNotifier<PrayerData> {
  PrayerRepository get _repo => ref.read(prayerRepositoryProvider);

  @override
  Future<PrayerData> build() => _load();

  Future<PrayerData> _load() async {
    final logs = await _repo.logsSince(daysAgoStart(30));
    final customs = await _repo.customTypes();
    return PrayerData(logs: logs, customTypes: customs);
  }

  Future<void> _reload() async {
    state = AsyncData(await _load());
  }

  Future<PrayerLog> log({
    required String key,
    required int rakats,
    DateTime? at,
    String? note,
  }) async {
    final cleanNote = (note == null || note.trim().isEmpty) ? null : note.trim();
    final entry = PrayerLog(
      id: newId(),
      prayerKey: key,
      rakats: rakats,
      loggedAt: at ?? DateTime.now(),
      note: cleanNote,
    );
    await _repo.upsertLog(entry);
    await _reload();
    return entry;
  }

  Future<void> delete(String id) async {
    await _repo.deleteLog(id);
    await _reload();
  }

  Future<void> restore(PrayerLog log) async {
    await _repo.upsertLog(log);
    await _reload();
  }

  Future<void> addCustomType(String name, int rakats) async {
    await _repo.addCustomType(
      CustomPrayerType(id: newId(), name: name, defaultRakats: rakats),
    );
    await _reload();
  }
}
