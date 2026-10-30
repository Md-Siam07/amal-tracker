import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/providers.dart';
import '../../core/settings/settings_controller.dart';
import '../../core/util/date_utils.dart';
import '../../core/util/ids.dart';
import 'tasbeeh_models.dart';
import 'tasbeeh_repository.dart';

final tasbeehRepositoryProvider = Provider<TasbeehRepository>(
  (ref) => TasbeehRepository(ref.watch(databaseProvider).db),
);

final tasbeehProvider =
    AsyncNotifierProvider<TasbeehController, TasbeehData>(TasbeehController.new);

class TasbeehController extends AsyncNotifier<TasbeehData> {
  TasbeehRepository get _repo => ref.read(tasbeehRepositoryProvider);

  @override
  Future<TasbeehData> build() => _load();

  Future<TasbeehData> _load() async {
    final sessions = await _repo.sessionsSince(daysAgoStart(30));
    final customs = await _repo.customDhikr();
    return TasbeehData(sessions: sessions, customs: customs);
  }

  Future<void> _reload() async {
    state = AsyncData(await _load());
  }

  Future<void> addSession(String key, int count) async {
    await _repo.addSession(
      TasbeehSession(
        id: newId(),
        dhikrKey: key,
        count: count,
        loggedAt: DateTime.now(),
      ),
    );
    await _reload();
  }

  /// Returns the new dhikr's key.
  Future<String> addCustom(String text, int target) async {
    final id = newId();
    await _repo.addCustomDhikr(CustomDhikr(id: id, text: text, target: target));
    await _reload();
    return id;
  }
}

class CounterState {
  const CounterState({required this.dhikrKey, required this.count});

  final String dhikrKey;
  final int count;
}

/// The in-progress count. Persisted on every tap so nothing is lost if the
/// app is closed mid-session.
final counterProvider =
    NotifierProvider<CounterController, CounterState>(CounterController.new);

class CounterController extends Notifier<CounterState> {
  static const _kKey = 'tasbeeh_draft_key';
  static const _kCount = 'tasbeeh_draft_count';

  @override
  CounterState build() {
    final prefs = ref.read(sharedPrefsProvider);
    return CounterState(
      dhikrKey: prefs.getString(_kKey) ?? dhikrPresets.first.key,
      count: prefs.getInt(_kCount) ?? 0,
    );
  }

  void _persist() {
    final prefs = ref.read(sharedPrefsProvider);
    prefs.setString(_kKey, state.dhikrKey);
    prefs.setInt(_kCount, state.count);
  }

  int increment() {
    state = CounterState(dhikrKey: state.dhikrKey, count: state.count + 1);
    _persist();
    return state.count;
  }

  void undo() {
    if (state.count == 0) return;
    state = CounterState(dhikrKey: state.dhikrKey, count: state.count - 1);
    _persist();
  }

  void reset() {
    state = CounterState(dhikrKey: state.dhikrKey, count: 0);
    _persist();
  }

  /// Saves the running count as a session. Returns true if something was saved.
  Future<bool> save() async {
    final count = state.count;
    if (count == 0) return false;
    await ref.read(tasbeehProvider.notifier).addSession(state.dhikrKey, count);
    state = CounterState(dhikrKey: state.dhikrKey, count: 0);
    _persist();
    return true;
  }

  /// Switches dhikr; any running count is saved first so it is never lost.
  Future<bool> select(String key) async {
    if (key == state.dhikrKey) return false;
    final saved = await save();
    state = CounterState(dhikrKey: key, count: 0);
    _persist();
    return saved;
  }
}
