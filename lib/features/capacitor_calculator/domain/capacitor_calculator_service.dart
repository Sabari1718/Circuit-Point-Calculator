import 'dart:math' as math;

/// Units of capacitance
enum CapacitanceUnit {
  pF('pF', 'Picofarad', 1e-12),
  nF('nF', 'Nanofarad', 1e-9),
  uF('µF', 'Microfarad', 1e-6),
  mF('mF', 'Millifarad', 1e-3),
  F('F', 'Farad', 1.0);

  final String symbol;
  final String label;
  final double multiplierToFarad;

  const CapacitanceUnit(this.symbol, this.label, this.multiplierToFarad);

  double toFarads(double value) => value * multiplierToFarad;
  double fromFarads(double farads) => farads / multiplierToFarad;
}

/// Tolerance ratings for capacitors
class CapacitorTolerance {
  final String letter;
  final String description;
  final double? percent; // null for absolute pF

  const CapacitorTolerance(this.letter, this.description, [this.percent]);

  static const Map<String, CapacitorTolerance> table = {
    'B': CapacitorTolerance('B', '±0.1 pF (for small caps)'),
    'C': CapacitorTolerance('C', '±0.25 pF (for small caps)'),
    'D': CapacitorTolerance('D', '±0.5 pF (for small caps)'),
    'F': CapacitorTolerance('F', '±1%', 1.0),
    'G': CapacitorTolerance('G', '±2%', 2.0),
    'J': CapacitorTolerance('J', '±5%', 5.0),
    'K': CapacitorTolerance('K', '±10%', 10.0),
    'M': CapacitorTolerance('M', '±20%', 20.0),
    'Z': CapacitorTolerance('Z', '+80% / -20%'),
  };
}

/// Voltage ratings commonly marked on capacitors (EIA standard)
class CapacitorVoltageCode {
  final String code;
  final int voltage;

  const CapacitorVoltageCode(this.code, this.voltage);

  static const Map<String, int> table = {
    '1A': 10,
    '1C': 16,
    '1E': 25,
    '1H': 50,
    '2A': 100,
    '2C': 160,
    '2D': 200,
    '2E': 250,
    '2G': 400,
    '2J': 630,
    '3A': 1000,
    '3G': 4000,
  };
}

/// Result of decoding a 3-digit / EIA capacitor code
class CapacitorCodeResult {
  final String rawCode;
  final double picofarads;
  final double nanofarads;
  final double microfarads;
  final double farads;
  final String? tolerance;
  final int? voltageRating;
  final String breakdown;
  final String formattedPrimary;

  const CapacitorCodeResult({
    required this.rawCode,
    required this.picofarads,
    required this.nanofarads,
    required this.microfarads,
    required this.farads,
    this.tolerance,
    this.voltageRating,
    required this.breakdown,
    required this.formattedPrimary,
  });

  String get picofaradsFormatted =>
      '${CapacitorCalculatorService.formatWithCommas(picofarads)} pF';
  String get nanofaradsFormatted =>
      '${CapacitorCalculatorService.formatNumber(nanofarads)} nF';
  String get microfaradsFormatted =>
      '${CapacitorCalculatorService.formatNumber(microfarads)} µF';
}

/// An entry in series/parallel calculation
class CapacitorValueItem {
  final double value;
  final CapacitanceUnit unit;

  const CapacitorValueItem({
    required this.value,
    this.unit = CapacitanceUnit.uF,
  });

  double get inFarads => unit.toFarads(value);

  CapacitorValueItem copyWith({double? value, CapacitanceUnit? unit}) {
    return CapacitorValueItem(
      value: value ?? this.value,
      unit: unit ?? this.unit,
    );
  }
}

/// Result of series and parallel calculation
class EquivalentCapacitanceResult {
  final double parallelFarads;
  final double seriesFarads;
  final String parallelFormatted;
  final String seriesFormatted;
  final String parallelBreakdown;
  final String seriesBreakdown;

  const EquivalentCapacitanceResult({
    required this.parallelFarads,
    required this.seriesFarads,
    required this.parallelFormatted,
    required this.seriesFormatted,
    required this.parallelBreakdown,
    required this.seriesBreakdown,
  });
}

/// Result of Charge, Energy & RC Time Constant calculation
class CapacitorEnergyResult {
  final double capacitanceFarads;
  final double voltage;
  final double chargeCoulombs;
  final double energyJoules;
  final double? resistanceOhms;
  final double? timeConstantTau;
  final double? cutoffFrequencyHz;
  final String chargeFormatted;
  final String energyFormatted;
  final String? tauFormatted;
  final String? cutoffFormatted;
  final String breakdown;

  const CapacitorEnergyResult({
    required this.capacitanceFarads,
    required this.voltage,
    required this.chargeCoulombs,
    required this.energyJoules,
    this.resistanceOhms,
    this.timeConstantTau,
    this.cutoffFrequencyHz,
    required this.chargeFormatted,
    required this.energyFormatted,
    this.tauFormatted,
    this.cutoffFormatted,
    required this.breakdown,
  });
}

class CapacitorCalculatorService {
  const CapacitorCalculatorService();

  /// Decode 3-digit EIA capacitor code (e.g., "104", "473K", "220J", "4R7", "102")
  CapacitorCodeResult decodeCode(String input) {
    final clean = input.trim().toUpperCase();
    if (clean.isEmpty) {
      throw ArgumentError('Capacitor code cannot be empty');
    }

    // Extract potential voltage prefix (e.g., 2A104K -> prefix 2A, code 104K)
    String remaining = clean;
    int? voltageRating;
    for (final entry in CapacitorVoltageCode.table.entries) {
      if (remaining.startsWith(entry.key) && remaining.length > entry.key.length) {
        voltageRating = entry.value;
        remaining = remaining.substring(entry.key.length);
        break;
      }
    }

    // Extract tolerance suffix if present (single letter at end)
    String? toleranceString;
    if (remaining.isNotEmpty && RegExp(r'[A-Z]$').hasMatch(remaining)) {
      final letter = remaining.substring(remaining.length - 1);
      if (CapacitorTolerance.table.containsKey(letter)) {
        toleranceString = CapacitorTolerance.table[letter]!.description;
        remaining = remaining.substring(0, remaining.length - 1);
      }
    }

    double picofarads = 0;
    String breakdownSteps = '';

    // Handle "R" for decimal values in pF (e.g., 4R7 = 4.7 pF, 0R5 = 0.5 pF)
    if (remaining.contains('R')) {
      final rVal = double.tryParse(remaining.replaceAll('R', '.'));
      if (rVal == null || rVal <= 0 || rVal.isNaN || rVal.isInfinite) {
        throw ArgumentError('Invalid capacitor code: "$clean"');
      }
      picofarads = rVal;
      breakdownSteps = '• Decimal code with "R": "$remaining"\n'
          '• Decimal separator "R" denotes picofarads (pF).\n'
          '• Capacitance: ${formatNumber(picofarads)} pF';
    } else {
      // Numerical code
      final numStr = remaining;
      if (!RegExp(r'^\d+$').hasMatch(numStr)) {
        throw ArgumentError(
          'Invalid capacitor code: "$clean". Must be numeric digits with optional tolerance letter (e.g. 104, 473K).',
        );
      }

      if (numStr.length == 1) {
        // Single digit e.g. "8" = 8 pF
        picofarads = double.parse(numStr);
        if (picofarads <= 0) {
          throw ArgumentError('Capacitor value must be greater than 0 pF');
        }
        breakdownSteps = '• Single-digit capacitor value: ${formatNumber(picofarads)} pF';
      } else if (numStr.length == 2) {
        // Two digits e.g. "47" = 47 pF
        picofarads = double.parse(numStr);
        if (picofarads <= 0) {
          throw ArgumentError('Capacitor value must be greater than 0 pF');
        }
        breakdownSteps = '• Two-digit capacitor value: ${formatNumber(picofarads)} pF\n'
            '• When only 2 digits are marked, value is directly in picofarads (pF).';
      } else if (numStr.length == 3) {
        // Standard 3-digit EIA: First 2 digits = significand, 3rd digit = multiplier power of 10
        final sigDigits = numStr.substring(0, 2);
        final multDigit = int.parse(numStr.substring(2, 3));
        final sigVal = double.parse(sigDigits);

        if (sigVal <= 0 && multDigit != 8 && multDigit != 9) {
          throw ArgumentError('Capacitor value must be greater than 0 pF');
        }

        double multiplier;
        String multFactorStr;
        String multExplanation;
        if (multDigit == 8) {
          multiplier = 0.01;
          multFactorStr = '0.01';
          multExplanation = '× 0.01 (EIA standard for multiplier 8)';
        } else if (multDigit == 9) {
          multiplier = 0.1;
          multFactorStr = '0.1';
          multExplanation = '× 0.1 (EIA standard for multiplier 9)';
        } else {
          multiplier = math.pow(10, multDigit).toDouble();
          multFactorStr = formatWithCommas(multiplier);
          multExplanation = '× 10^$multDigit = × $multFactorStr';
        }

        final rawPico = sigVal * multiplier;
        // Clean round to avoid floating point precision issues (e.g. 22 * 0.01 = 0.22000000000000003)
        picofarads = (rawPico * 10000).roundToDouble() / 10000.0;
        if (picofarads <= 0) {
          throw ArgumentError('Capacitor value must be greater than 0 pF');
        }

        breakdownSteps = '• First two digits: $sigDigits\n'
            '• Multiplier digit ($multDigit): $multExplanation\n'
            '• Calculation: $sigDigits × $multFactorStr = ${formatWithCommas(picofarads)} pF';
      } else {
        throw ArgumentError(
          'Unsupported capacitor marking: "$clean". Standard capacitor code must be 1 to 3 digits (e.g. 104).',
        );
      }
    }

    final nanofarads = picofarads / 1000.0;
    final microfarads = picofarads / 1000000.0;
    final farads = picofarads * 1e-12;

    // Build clear breakdown
    final b = StringBuffer();
    b.writeln('• Capacitor Code: $clean');
    b.writeln('• Capacitance: ${formatWithCommas(picofarads)} pF');
    b.writeln('• Equivalent Value: ${formatNumber(nanofarads)} nF');
    b.writeln('• Equivalent Value: ${formatNumber(microfarads)} µF');
    b.writeln('');
    b.writeln('Formula:');
    b.writeln('Capacitance (pF) = First two digits × 10^(Third digit)');
    b.writeln('');
    b.writeln('Calculation Steps:');
    b.writeln(breakdownSteps);
    b.writeln('• In Nanofarads: ${formatWithCommas(picofarads)} pF ÷ 1,000 = ${formatNumber(nanofarads)} nF');
    b.writeln('• In Microfarads: ${formatWithCommas(picofarads)} pF ÷ 1,000,000 = ${formatNumber(microfarads)} µF');

    if (toleranceString != null) {
      b.writeln('\nTolerance: $toleranceString');
    }
    if (voltageRating != null) {
      b.writeln('Rated Voltage: ${voltageRating}V DC');
    }

    // Determine readable primary unit:
    // 104 specifically: '100 nF (0.1 µF)'
    // Otherwise: >= 1 µF -> µF, >= 1 nF -> nF, else pF
    String formattedPrimary;
    if ((picofarads - 100000).abs() < 1e-6) {
      formattedPrimary = '100 nF (0.1 µF)';
    } else if (microfarads >= 1.0) {
      formattedPrimary = '${formatNumber(microfarads)} µF';
    } else if (nanofarads >= 1.0) {
      formattedPrimary = '${formatNumber(nanofarads)} nF';
    } else {
      formattedPrimary = '${formatNumber(picofarads)} pF';
    }

    return CapacitorCodeResult(
      rawCode: clean,
      picofarads: picofarads,
      nanofarads: nanofarads,
      microfarads: microfarads,
      farads: farads,
      tolerance: toleranceString,
      voltageRating: voltageRating,
      breakdown: b.toString(),
      formattedPrimary: formattedPrimary,
    );
  }

  /// Calculate equivalent capacitance for Parallel and Series combinations
  EquivalentCapacitanceResult calculateEquivalent(List<CapacitorValueItem> capacitors) {
    if (capacitors.isEmpty) {
      throw ArgumentError('At least one capacitor is required');
    }

    // Filter valid positive capacitors
    final valid = capacitors.where((c) => c.value > 0).toList();
    if (valid.isEmpty) {
      return const EquivalentCapacitanceResult(
        parallelFarads: 0,
        seriesFarads: 0,
        parallelFormatted: '0 µF',
        seriesFormatted: '0 µF',
        parallelBreakdown: 'Enter capacitor values greater than 0',
        seriesBreakdown: 'Enter capacitor values greater than 0',
      );
    }

    // 1. Parallel: C_total = C1 + C2 + ...
    double sumParallelFarads = 0;
    final parallelSteps = StringBuffer('Parallel Formula: C_total = C1 + C2 + ... + Cn\n\n');
    for (int i = 0; i < valid.length; i++) {
      final f = valid[i].inFarads;
      sumParallelFarads += f;
      parallelSteps.writeln('• C${i + 1} = ${formatNumber(valid[i].value)} ${valid[i].unit.symbol} (${formatWithUnit(f)})');
    }
    parallelSteps.writeln('\nTotal = ${formatWithUnit(sumParallelFarads)}');

    // 2. Series: 1/C_total = 1/C1 + 1/C2 + ...
    double sumReciprocal = 0;
    final seriesSteps = StringBuffer('Series Formula: 1 / C_total = 1/C1 + 1/C2 + ... + 1/Cn\n\n');
    for (int i = 0; i < valid.length; i++) {
      final f = valid[i].inFarads;
      sumReciprocal += (1.0 / f);
      seriesSteps.writeln('• 1 / C${i + 1} = 1 / (${formatWithUnit(f)}) = ${formatNumber(1.0 / f, decimals: 3)}');
    }
    final seriesFarads = 1.0 / sumReciprocal;
    seriesSteps.writeln('\nC_series = 1 / (${formatNumber(sumReciprocal, decimals: 3)}) = ${formatWithUnit(seriesFarads)}');

    return EquivalentCapacitanceResult(
      parallelFarads: sumParallelFarads,
      seriesFarads: seriesFarads,
      parallelFormatted: formatWithUnit(sumParallelFarads),
      seriesFormatted: formatWithUnit(seriesFarads),
      parallelBreakdown: parallelSteps.toString(),
      seriesBreakdown: seriesSteps.toString(),
    );
  }

  /// Calculate Charge Q = C × V, Energy E = 0.5 × C × V², Tau = R × C, fc = 1 / (2πRC)
  CapacitorEnergyResult calculateEnergyAndRC({
    required double capacitanceValue,
    required CapacitanceUnit unit,
    required double voltage,
    double? resistanceOhms,
  }) {
    if (capacitanceValue <= 0 || voltage < 0) {
      throw ArgumentError('Capacitance must be > 0 and Voltage must be ≥ 0');
    }

    final cFarads = unit.toFarads(capacitanceValue);

    // Charge: Q = C * V (Coulombs)
    final qCoulombs = cFarads * voltage;

    // Energy: E = 0.5 * C * V^2 (Joules)
    final energyJoules = 0.5 * cFarads * math.pow(voltage, 2);

    // Format Charge
    String chargeStr;
    if (qCoulombs >= 1.0) {
      chargeStr = '${formatNumber(qCoulombs, decimals: 4)} C';
    } else if (qCoulombs >= 1e-3) {
      chargeStr = '${formatNumber(qCoulombs * 1e3, decimals: 3)} mC';
    } else if (qCoulombs >= 1e-6) {
      chargeStr = '${formatNumber(qCoulombs * 1e6, decimals: 3)} µC';
    } else {
      chargeStr = '${formatNumber(qCoulombs * 1e9, decimals: 2)} nC';
    }

    // Format Energy
    String energyStr;
    if (energyJoules >= 1.0) {
      energyStr = '${formatNumber(energyJoules, decimals: 4)} J';
    } else if (energyJoules >= 1e-3) {
      energyStr = '${formatNumber(energyJoules * 1e3, decimals: 3)} mJ';
    } else if (energyJoules >= 1e-6) {
      energyStr = '${formatNumber(energyJoules * 1e6, decimals: 3)} µJ';
    } else {
      energyStr = '${formatNumber(energyJoules * 1e9, decimals: 2)} nJ';
    }

    double? tau;
    double? fc;
    String? tauStr;
    String? fcStr;

    final breakdown = StringBuffer();
    breakdown.writeln('1. Stored Charge (Q = C × V):');
    breakdown.writeln('• Q = ${formatWithUnit(cFarads)} × ${voltage}V = $chargeStr');

    breakdown.writeln('\n2. Stored Energy (E = ½ × C × V²):');
    breakdown.writeln('• E = 0.5 × ${formatWithUnit(cFarads)} × (${voltage}V)²');
    breakdown.writeln('• E = $energyStr');

    if (resistanceOhms != null && resistanceOhms > 0) {
      // Time Constant Tau = R * C (seconds)
      tau = resistanceOhms * cFarads;
      if (tau >= 1.0) {
        tauStr = '${formatNumber(tau, decimals: 3)} s';
      } else if (tau >= 1e-3) {
        tauStr = '${formatNumber(tau * 1e3, decimals: 2)} ms';
      } else if (tau >= 1e-6) {
        tauStr = '${formatNumber(tau * 1e6, decimals: 2)} µs';
      } else {
        tauStr = '${formatNumber(tau * 1e9, decimals: 1)} ns';
      }

      // Cutoff frequency fc = 1 / (2 * pi * R * C)
      fc = 1.0 / (2 * math.pi * resistanceOhms * cFarads);
      if (fc >= 1e6) {
        fcStr = '${formatNumber(fc / 1e6, decimals: 3)} MHz';
      } else if (fc >= 1e3) {
        fcStr = '${formatNumber(fc / 1e3, decimals: 2)} kHz';
      } else {
        fcStr = '${formatNumber(fc, decimals: 2)} Hz';
      }

      breakdown.writeln('\n3. RC Time Constant (τ = R × C):');
      breakdown.writeln('• τ = ${_formatResistance(resistanceOhms)} × ${formatWithUnit(cFarads)}');
      breakdown.writeln('• Time Constant (τ) = $tauStr (63.2% charge)');
      breakdown.writeln('• Full Charge (5τ) ≈ ${_formatTime(tau * 5)} (99.3% charge)');
      breakdown.writeln('\n4. Cutoff Frequency (fc = 1 / [2πRC]):');
      breakdown.writeln('• fc = 1 / (2 × π × ${_formatResistance(resistanceOhms)} × ${formatWithUnit(cFarads)}) = $fcStr');
    }

    return CapacitorEnergyResult(
      capacitanceFarads: cFarads,
      voltage: voltage,
      chargeCoulombs: qCoulombs,
      energyJoules: energyJoules,
      resistanceOhms: resistanceOhms,
      timeConstantTau: tau,
      cutoffFrequencyHz: fc,
      chargeFormatted: chargeStr,
      energyFormatted: energyStr,
      tauFormatted: tauStr,
      cutoffFormatted: fcStr,
      breakdown: breakdown.toString(),
    );
  }

  // ── Helper formatters ────────────────────────────────────────────────────────

  static String formatNumber(double val, {int decimals = 6}) {
    if (val == val.roundToDouble() && val.abs() < 1e9) {
      return val.toInt().toString();
    }
    String s = val.toStringAsFixed(decimals);
    if (s.contains('.')) {
      s = s.replaceAll(RegExp(r'0+$'), '');
      s = s.replaceAll(RegExp(r'\.$'), '');
    }
    return s;
  }

  static String formatWithCommas(double val) {
    if (val.isNaN || val.isInfinite) return val.toString();
    if (val == val.roundToDouble() && val.abs() < 1e15) {
      final intPart = val.toInt().toString();
      final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
      return intPart.replaceAllMapped(reg, (Match m) => '${m[1]},');
    }
    final formatted = formatNumber(val);
    final parts = formatted.split('.');
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    final formattedInt =
        parts[0].replaceAllMapped(reg, (Match m) => '${m[1]},');
    if (parts.length > 1) {
      return '$formattedInt.${parts[1]}';
    }
    return formattedInt;
  }

  static String formatWithUnit(double farads) {
    if (farads <= 0) return '0 F';
    if (farads >= 1.0) {
      return '${formatNumber(farads, decimals: 3)} F';
    } else if (farads >= 1e-3) {
      return '${formatNumber(farads * 1e3, decimals: 3)} mF';
    } else if (farads >= 1e-6) {
      return '${formatNumber(farads * 1e6, decimals: 3)} µF';
    } else if (farads >= 1e-9) {
      return '${formatNumber(farads * 1e9, decimals: 3)} nF';
    } else {
      return '${formatNumber(farads * 1e12, decimals: 2)} pF';
    }
  }

  static String _formatResistance(double ohms) {
    if (ohms >= 1e6) {
      return '${formatNumber(ohms / 1e6, decimals: 2)} MΩ';
    } else if (ohms >= 1e3) {
      return '${formatNumber(ohms / 1e3, decimals: 2)} kΩ';
    } else {
      return '${formatNumber(ohms, decimals: 2)} Ω';
    }
  }

  static String _formatTime(double seconds) {
    if (seconds >= 1.0) {
      return '${formatNumber(seconds, decimals: 3)} s';
    } else if (seconds >= 1e-3) {
      return '${formatNumber(seconds * 1e3, decimals: 2)} ms';
    } else if (seconds >= 1e-6) {
      return '${formatNumber(seconds * 1e6, decimals: 2)} µs';
    } else {
      return '${formatNumber(seconds * 1e9, decimals: 1)} ns';
    }
  }
}

