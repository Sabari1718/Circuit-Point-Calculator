import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../domain/capacitor_calculator_service.dart';
import '../../history/domain/calculation_record.dart';
import '../../history/providers/history_provider.dart';

enum CapacitorCalcTab {
  decoder,
  seriesParallel,
  energyRC,
}

class CapacitorCalculatorState {
  final CapacitorCalcTab tab;
  // Decoder tab state
  final String code;
  final CapacitorCodeResult? codeResult;
  final String? codeError;

  // Series / Parallel tab state
  final List<CapacitorValueItem> capacitors;
  final EquivalentCapacitanceResult? equivalentResult;

  // Energy & RC tab state
  final double energyCapValue;
  final CapacitanceUnit energyCapUnit;
  final double energyVoltage;
  final double? energyResistanceOhms;
  final CapacitorEnergyResult? energyResult;

  const CapacitorCalculatorState({
    this.tab = CapacitorCalcTab.decoder,
    this.code = '104',
    this.codeResult,
    this.codeError,
    this.capacitors = const [
      CapacitorValueItem(value: 10, unit: CapacitanceUnit.uF),
      CapacitorValueItem(value: 22, unit: CapacitanceUnit.uF),
    ],
    this.equivalentResult,
    this.energyCapValue = 100,
    this.energyCapUnit = CapacitanceUnit.uF,
    this.energyVoltage = 12,
    this.energyResistanceOhms = 1000,
    this.energyResult,
  });

  CapacitorCalculatorState copyWith({
    CapacitorCalcTab? tab,
    String? code,
    CapacitorCodeResult? codeResult,
    bool clearCodeResult = false,
    String? codeError,
    bool clearCodeError = false,
    List<CapacitorValueItem>? capacitors,
    EquivalentCapacitanceResult? equivalentResult,
    double? energyCapValue,
    CapacitanceUnit? energyCapUnit,
    double? energyVoltage,
    double? energyResistanceOhms,
    bool clearResistance = false,
    CapacitorEnergyResult? energyResult,
  }) {
    return CapacitorCalculatorState(
      tab: tab ?? this.tab,
      code: code ?? this.code,
      codeResult: clearCodeResult ? null : (codeResult ?? this.codeResult),
      codeError: clearCodeError ? null : (codeError ?? this.codeError),
      capacitors: capacitors ?? this.capacitors,
      equivalentResult: equivalentResult ?? this.equivalentResult,
      energyCapValue: energyCapValue ?? this.energyCapValue,
      energyCapUnit: energyCapUnit ?? this.energyCapUnit,
      energyVoltage: energyVoltage ?? this.energyVoltage,
      energyResistanceOhms: clearResistance
          ? null
          : (energyResistanceOhms ?? this.energyResistanceOhms),
      energyResult: energyResult ?? this.energyResult,
    );
  }
}

class CapacitorCalculatorNotifier extends StateNotifier<CapacitorCalculatorState> {
  final CapacitorCalculatorService _service;
  final Ref _ref;

  CapacitorCalculatorNotifier(this._service, this._ref)
      : super(const CapacitorCalculatorState()) {
    // Initial calculations
    decodeCode(state.code);
    recalculateEquivalent();
    recalculateEnergy();
  }

  void setTab(CapacitorCalcTab tab) {
    state = state.copyWith(tab: tab);
  }

  // ── Code Decoder Methods ───────────────────────────────────────────────────

  void decodeCode(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      state = state.copyWith(
        code: '',
        clearCodeResult: true,
        codeError: 'Capacitor code cannot be empty',
      );
      return;
    }
    try {
      final res = _service.decodeCode(trimmed);
      state = state.copyWith(
        code: trimmed,
        codeResult: res,
        clearCodeError: true,
      );
    } catch (e) {
      state = state.copyWith(
        code: trimmed,
        clearCodeResult: true,
        codeError: e.toString().replaceFirst('ArgumentError: ', ''),
      );
    }
  }

  void applyPresetCode(String presetCode) {
    decodeCode(presetCode);
  }

  // ── Series / Parallel Methods ──────────────────────────────────────────────

  void setCapacitorItem(int index, double value, CapacitanceUnit unit) {
    final list = List<CapacitorValueItem>.from(state.capacitors);
    if (index >= 0 && index < list.length) {
      list[index] = CapacitorValueItem(value: value, unit: unit);
      state = state.copyWith(capacitors: list);
      recalculateEquivalent();
    }
  }

  void addCapacitorItem() {
    if (state.capacitors.length >= 8) return;
    final list = List<CapacitorValueItem>.from(state.capacitors);
    list.add(const CapacitorValueItem(value: 10, unit: CapacitanceUnit.uF));
    state = state.copyWith(capacitors: list);
    recalculateEquivalent();
  }

  void removeCapacitorItem(int index) {
    if (state.capacitors.length <= 2) return;
    final list = List<CapacitorValueItem>.from(state.capacitors);
    list.removeAt(index);
    state = state.copyWith(capacitors: list);
    recalculateEquivalent();
  }

  void recalculateEquivalent() {
    final res = _service.calculateEquivalent(state.capacitors);
    state = state.copyWith(equivalentResult: res);
  }

  // ── Energy & RC Methods ────────────────────────────────────────────────────

  void setEnergyParams({
    double? capValue,
    CapacitanceUnit? capUnit,
    double? voltage,
    double? resistanceOhms,
  }) {
    state = state.copyWith(
      energyCapValue: capValue ?? state.energyCapValue,
      energyCapUnit: capUnit ?? state.energyCapUnit,
      energyVoltage: voltage ?? state.energyVoltage,
      energyResistanceOhms: resistanceOhms ?? state.energyResistanceOhms,
    );
    recalculateEnergy();
  }

  void recalculateEnergy() {
    try {
      final res = _service.calculateEnergyAndRC(
        capacitanceValue: state.energyCapValue,
        unit: state.energyCapUnit,
        voltage: state.energyVoltage,
        resistanceOhms: state.energyResistanceOhms,
      );
      state = state.copyWith(energyResult: res);
    } catch (_) {}
  }

  // ── History ────────────────────────────────────────────────────────────────

  void saveToHistory() {
    final uuid = const Uuid().v4();
    CalculationRecord? record;

    switch (state.tab) {
      case CapacitorCalcTab.decoder:
        if (state.codeResult != null) {
          final res = state.codeResult!;
          record = CalculationRecord(
            id: uuid,
            type: CalculationType.capacitor,
            title: 'Capacitor Code (${res.rawCode})',
            inputs: {
              'Code': res.rawCode,
              if (res.tolerance != null) 'Tolerance': res.tolerance!,
              if (res.voltageRating != null) 'Voltage': '${res.voltageRating}V',
            },
            result: res.formattedPrimary,
            unit: '',
            timestamp: DateTime.now(),
          );
        }
        break;

      case CapacitorCalcTab.seriesParallel:
        if (state.equivalentResult != null) {
          final res = state.equivalentResult!;
          final capSummary = state.capacitors
              .map((c) => '${c.value}${c.unit.symbol}')
              .join(' + ');
          record = CalculationRecord(
            id: uuid,
            type: CalculationType.capacitor,
            title: 'Capacitor Equivalent ($capSummary)',
            inputs: {
              'Parallel': res.parallelFormatted,
              'Series': res.seriesFormatted,
            },
            result: 'Parallel: ${res.parallelFormatted} | Series: ${res.seriesFormatted}',
            unit: '',
            timestamp: DateTime.now(),
          );
        }
        break;

      case CapacitorCalcTab.energyRC:
        if (state.energyResult != null) {
          final res = state.energyResult!;
          record = CalculationRecord(
            id: uuid,
            type: CalculationType.capacitor,
            title: 'Capacitor Energy & Charge',
            inputs: {
              'Capacitance': '${state.energyCapValue} ${state.energyCapUnit.symbol}',
              'Voltage': '${state.energyVoltage} V',
              if (state.energyResistanceOhms != null)
                'Resistance': '${state.energyResistanceOhms} Ω',
            },
            result: '${res.energyFormatted} (${res.chargeFormatted})',
            unit: '',
            timestamp: DateTime.now(),
          );
        }
        break;
    }

    if (record != null) {
      _ref.read(historyProvider.notifier).addRecord(record);
    }
  }

  void reset() {
    state = const CapacitorCalculatorState();
    decodeCode(state.code);
    recalculateEquivalent();
    recalculateEnergy();
  }
}

final capacitorServiceProvider = Provider<CapacitorCalculatorService>((ref) {
  return const CapacitorCalculatorService();
});

final capacitorCalculatorProvider =
    StateNotifierProvider<CapacitorCalculatorNotifier, CapacitorCalculatorState>(
        (ref) {
  final service = ref.watch(capacitorServiceProvider);
  return CapacitorCalculatorNotifier(service, ref);
});

