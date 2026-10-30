import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../domain/resistor_calculator_service.dart';
import '../../history/domain/calculation_record.dart';
import '../../history/providers/history_provider.dart';

const _uuid = Uuid();

final resistorCalculatorServiceProvider = Provider<ResistorCalculatorService>(
  (_) => const ResistorCalculatorService(),
);

class ResistorCalculatorState {
  final int bandCount;
  final String band1;
  final String band2;
  final String band3;
  final String band4;
  final String band5;
  final String band6;
  final ResistorResult? result;

  const ResistorCalculatorState({
    this.bandCount = 4,
    this.band1 = 'Brown',
    this.band2 = 'Black',
    this.band3 = 'Red',
    this.band4 = 'Gold',
    this.band5 = 'Brown',
    this.band6 = 'Brown',
    this.result,
  });

  ResistorCalculatorState copyWith({
    int? bandCount,
    String? band1,
    String? band2,
    String? band3,
    String? band4,
    String? band5,
    String? band6,
    ResistorResult? result,
  }) {
    return ResistorCalculatorState(
      bandCount: bandCount ?? this.bandCount,
      band1: band1 ?? this.band1,
      band2: band2 ?? this.band2,
      band3: band3 ?? this.band3,
      band4: band4 ?? this.band4,
      band5: band5 ?? this.band5,
      band6: band6 ?? this.band6,
      result: result ?? this.result,
    );
  }

  List<String> get activeBands {
    switch (bandCount) {
      case 4:
        return [band1, band2, band3, band4];
      case 5:
        return [band1, band2, band3, band4, band5];
      case 6:
        return [band1, band2, band3, band4, band5, band6];
      default:
        return [band1, band2, band3, band4];
    }
  }
}

class ResistorCalculatorNotifier extends Notifier<ResistorCalculatorState> {
  @override
  ResistorCalculatorState build() {
    final s = const ResistorCalculatorState();
    // Auto-calculate on init
    final result = _doCalculate(s);
    return s.copyWith(result: result);
  }

  void setBandCount(int count) {
    final newState = state.copyWith(bandCount: count);
    final result = _doCalculate(newState);
    state = newState.copyWith(result: result);
  }

  void setBand(int index, String color) {
    ResistorCalculatorState newState;
    switch (index) {
      case 1:
        newState = state.copyWith(band1: color);
        break;
      case 2:
        newState = state.copyWith(band2: color);
        break;
      case 3:
        newState = state.copyWith(band3: color);
        break;
      case 4:
        newState = state.copyWith(band4: color);
        break;
      case 5:
        newState = state.copyWith(band5: color);
        break;
      case 6:
        newState = state.copyWith(band6: color);
        break;
      default:
        return;
    }
    final result = _doCalculate(newState);
    state = newState.copyWith(result: result);
  }

  void applyPreset(List<String> bands) {
    var newState = state;
    for (int i = 0; i < bands.length && i < 6; i++) {
      newState = _setBandOnState(newState, i + 1, bands[i]);
    }
    newState = newState.copyWith(bandCount: bands.length);
    final result = _doCalculate(newState);
    state = newState.copyWith(result: result);
  }

  ResistorCalculatorState _setBandOnState(
    ResistorCalculatorState s,
    int index,
    String color,
  ) {
    switch (index) {
      case 1:
        return s.copyWith(band1: color);
      case 2:
        return s.copyWith(band2: color);
      case 3:
        return s.copyWith(band3: color);
      case 4:
        return s.copyWith(band4: color);
      case 5:
        return s.copyWith(band5: color);
      case 6:
        return s.copyWith(band6: color);
      default:
        return s;
    }
  }

  ResistorResult? _doCalculate(ResistorCalculatorState s) {
    final service = ref.read(resistorCalculatorServiceProvider);
    try {
      switch (s.bandCount) {
        case 4:
          return service.calculate4Band(
            band1: s.band1,
            band2: s.band2,
            band3Multiplier: s.band3,
            band4Tolerance: s.band4,
          );
        case 5:
          return service.calculate5Band(
            band1: s.band1,
            band2: s.band2,
            band3: s.band3,
            band4Multiplier: s.band4,
            band5Tolerance: s.band5,
          );
        case 6:
          return service.calculate6Band(
            band1: s.band1,
            band2: s.band2,
            band3: s.band3,
            band4Multiplier: s.band4,
            band5Tolerance: s.band5,
            band6TempCoeff: s.band6,
          );
        default:
          return null;
      }
    } catch (_) {
      return null;
    }
  }

  void reset() {
    final s = const ResistorCalculatorState();
    final result = _doCalculate(s);
    state = s.copyWith(result: result);
  }

  void saveToHistory() {
    final result = state.result;
    if (result == null) return;

    final inputs = <String, String>{
      for (int i = 0; i < state.activeBands.length; i++)
        'Band ${i + 1}': state.activeBands[i],
    };

    final record = CalculationRecord(
      id: _uuid.v4(),
      type: CalculationType.resistor,
      title: '${state.bandCount}-Band Resistor',
      inputs: inputs,
      result: result.resistanceOhm.toStringAsFixed(2),
      unit: 'Ω',
      timestamp: DateTime.now(),
    );
    ref.read(historyProvider.notifier).addRecord(record);
  }
}

final resistorCalculatorProvider =
    NotifierProvider<ResistorCalculatorNotifier, ResistorCalculatorState>(
      ResistorCalculatorNotifier.new,
    );
