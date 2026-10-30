import 'dart:math';

import '../../history/domain/calculation_record.dart';

/// Electrical Power calculation service.
/// Implements DC and AC (single-phase and three-phase) power formulas.
class PowerCalculatorService {
  const PowerCalculatorService();

  /// Calculate electrical power based on mode.
  ///
  /// DC:           P = V × I
  /// AC Single:    P = V × I × PF  (real power)
  /// AC Three:     P = √3 × V × I × PF
  PowerCalculationResult calculate({
    required double voltage,
    required double current,
    double powerFactor = 1.0,
    required PowerMode mode,
  }) {
    late double watts;
    late String formula;
    late String breakdown;

    switch (mode) {
      case PowerMode.dc:
        watts = voltage * current;
        formula = 'P = V × I';
        breakdown = 'P = $voltage V × $current A\nP = ${_fmt(watts)} W';
        break;

      case PowerMode.acSingle:
        watts = voltage * current * powerFactor;
        formula = 'P = V × I × PF';
        breakdown =
            'P = $voltage V × $current A × $powerFactor\nP = ${_fmt(watts)} W';
        break;

      case PowerMode.acThree:
        // √3 ≈ 1.732050808...
        watts = sqrt(3) * voltage * current * powerFactor;
        formula = 'P = √3 × V × I × PF';
        breakdown =
            'P = 1.7321 × $voltage V × $current A × $powerFactor\nP = ${_fmt(watts)} W';
        break;
    }

    final kilowatts = watts / 1000;

    return PowerCalculationResult(
      voltage: voltage,
      current: current,
      powerFactor: mode == PowerMode.dc ? null : powerFactor,
      mode: mode,
      watts: watts,
      kilowatts: kilowatts,
      formula: formula,
      breakdown: breakdown,
    );
  }

  String _fmt(double v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v
        .toStringAsFixed(4)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }
}
