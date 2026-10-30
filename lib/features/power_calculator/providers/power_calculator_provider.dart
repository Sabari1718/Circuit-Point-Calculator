import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../domain/power_calculator_service.dart';
import '../../history/domain/calculation_record.dart';
import '../../history/providers/history_provider.dart';

const _uuid = Uuid();

// Service provider
final powerCalculatorServiceProvider = Provider<PowerCalculatorService>(
  (_) => const PowerCalculatorService(),
);

// State class
class PowerCalculatorState {
  final String voltage;
  final String current;
  final String powerFactor;
  final PowerMode mode;
  final PowerCalculationResult? result;
  final String? voltageError;
  final String? currentError;
  final String? powerFactorError;

  const PowerCalculatorState({
    this.voltage = '',
    this.current = '',
    this.powerFactor = '1.0',
    this.mode = PowerMode.dc,
    this.result,
    this.voltageError,
    this.currentError,
    this.powerFactorError,
  });

  bool get isValid =>
      voltageError == null &&
      currentError == null &&
      powerFactorError == null &&
      voltage.isNotEmpty &&
      current.isNotEmpty;

  bool get showPowerFactor => mode != PowerMode.dc;

  PowerCalculatorState copyWith({
    String? voltage,
    String? current,
    String? powerFactor,
    PowerMode? mode,
    PowerCalculationResult? result,
    Object? voltageError = _sentinel,
    Object? currentError = _sentinel,
    Object? powerFactorError = _sentinel,
  }) {
    return PowerCalculatorState(
      voltage: voltage ?? this.voltage,
      current: current ?? this.current,
      powerFactor: powerFactor ?? this.powerFactor,
      mode: mode ?? this.mode,
      result: result ?? this.result,
      voltageError: voltageError == _sentinel
          ? this.voltageError
          : voltageError as String?,
      currentError: currentError == _sentinel
          ? this.currentError
          : currentError as String?,
      powerFactorError: powerFactorError == _sentinel
          ? this.powerFactorError
          : powerFactorError as String?,
    );
  }

  static const Object _sentinel = Object();
}

// Notifier
class PowerCalculatorNotifier extends Notifier<PowerCalculatorState> {
  @override
  PowerCalculatorState build() => const PowerCalculatorState();

  void setVoltage(String value) {
    final err = _validatePositiveNumber(value, 'Voltage');
    state = state.copyWith(voltage: value, voltageError: err);
    _autoCalculate();
  }

  void setCurrent(String value) {
    final err = _validatePositiveNumber(value, 'Current');
    state = state.copyWith(current: value, currentError: err);
    _autoCalculate();
  }

  void setPowerFactor(String value) {
    final err = _validatePowerFactor(value);
    state = state.copyWith(powerFactor: value, powerFactorError: err);
    _autoCalculate();
  }

  void setMode(PowerMode mode) {
    state = state.copyWith(mode: mode, result: null);
    _autoCalculate();
  }

  void _autoCalculate() {
    final v = double.tryParse(state.voltage);
    final i = double.tryParse(state.current);
    final pf = double.tryParse(state.powerFactor) ?? 1.0;

    if (v == null || i == null) return;
    if (state.voltageError != null ||
        state.currentError != null ||
        state.powerFactorError != null)
      return;

    final service = ref.read(powerCalculatorServiceProvider);
    final result = service.calculate(
      voltage: v,
      current: i,
      powerFactor: pf.clamp(0.0, 1.0),
      mode: state.mode,
    );
    state = state.copyWith(result: result);
  }

  void calculate() {
    _autoCalculate();
    final result = state.result;
    if (result == null) return;

    // Save to history
    final modeLabel = _modeLabel(state.mode);
    final inputs = <String, String>{
      'Voltage': '${state.voltage} V',
      'Current': '${state.current} A',
      if (state.showPowerFactor) 'Power Factor': state.powerFactor,
      'Mode': modeLabel,
    };

    final record = CalculationRecord(
      id: _uuid.v4(),
      type: CalculationType.power,
      title: '$modeLabel Power',
      inputs: inputs,
      result: result.watts.toStringAsFixed(2),
      unit: 'W',
      timestamp: DateTime.now(),
    );
    ref.read(historyProvider.notifier).addRecord(record);
  }

  void clear() {
    state = const PowerCalculatorState();
  }

  String _modeLabel(PowerMode mode) {
    switch (mode) {
      case PowerMode.dc:
        return 'DC';
      case PowerMode.acSingle:
        return 'AC Single-Phase';
      case PowerMode.acThree:
        return 'AC Three-Phase';
    }
  }

  String? _validatePositiveNumber(String value, String fieldName) {
    if (value.isEmpty) return null; // allow empty (will block calculation)
    final n = double.tryParse(value);
    if (n == null) return '$fieldName must be a valid number';
    if (n < 0) return '$fieldName cannot be negative';
    return null;
  }

  String? _validatePowerFactor(String value) {
    if (value.isEmpty) return 'Power factor is required';
    final n = double.tryParse(value);
    if (n == null) return 'Power factor must be a valid number';
    if (n < 0 || n > 1) return 'Power factor must be between 0 and 1';
    return null;
  }
}

final powerCalculatorProvider =
    NotifierProvider<PowerCalculatorNotifier, PowerCalculatorState>(
      PowerCalculatorNotifier.new,
    );
