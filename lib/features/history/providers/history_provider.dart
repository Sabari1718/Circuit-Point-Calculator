import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/calculation_record.dart';
import '../../../core/constants/app_constants.dart';

final historyServiceProvider = Provider<HistoryService>(
  (ref) => HistoryService(),
);

final historyProvider =
    AsyncNotifierProvider<HistoryNotifier, List<CalculationRecord>>(
      HistoryNotifier.new,
    );

class HistoryService {
  Future<List<CalculationRecord>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(AppConstants.keyCalculationHistory) ?? [];
    return raw
        .map((s) {
          try {
            return CalculationRecord.fromJsonString(s);
          } catch (_) {
            return null;
          }
        })
        .whereType<CalculationRecord>()
        .toList();
  }

  Future<void> saveHistory(List<CalculationRecord> records) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = records.map((r) => r.toJsonString()).toList();
    await prefs.setStringList(AppConstants.keyCalculationHistory, encoded);
  }
}

class HistoryNotifier extends AsyncNotifier<List<CalculationRecord>> {
  @override
  Future<List<CalculationRecord>> build() async {
    final service = ref.read(historyServiceProvider);
    return service.loadHistory();
  }

  Future<void> addRecord(CalculationRecord record) async {
    final current = state.valueOrNull ?? [];
    final updated = [record, ...current];
    // Limit history to max items
    final trimmed = updated.take(AppConstants.maxHistoryItems).toList();
    state = AsyncData(trimmed);
    await ref.read(historyServiceProvider).saveHistory(trimmed);
  }

  Future<void> deleteRecord(String id) async {
    final current = state.valueOrNull ?? [];
    final updated = current.where((r) => r.id != id).toList();
    state = AsyncData(updated);
    await ref.read(historyServiceProvider).saveHistory(updated);
  }

  Future<void> clearAll() async {
    state = const AsyncData([]);
    await ref.read(historyServiceProvider).saveHistory([]);
  }
}
