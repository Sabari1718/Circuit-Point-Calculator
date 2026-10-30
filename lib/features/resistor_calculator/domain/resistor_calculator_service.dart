import '../../history/domain/calculation_record.dart';

/// Official resistor colour code data and calculation logic.
///
/// Reference: IEC 60062 standard for resistor colour coding.
class ResistorCalculatorService {
  const ResistorCalculatorService();

  // Digit values for bands 1-3
  static const Map<String, int> _digitMap = {
    'Black': 0,
    'Brown': 1,
    'Red': 2,
    'Orange': 3,
    'Yellow': 4,
    'Green': 5,
    'Blue': 6,
    'Violet': 7,
    'Grey': 8,
    'White': 9,
  };

  // Multiplier values (10^x or special)
  static const Map<String, double> _multiplierMap = {
    'Black': 1, // × 10^0
    'Brown': 10, // × 10^1
    'Red': 100, // × 10^2
    'Orange': 1000, // × 10^3
    'Yellow': 10000, // × 10^4
    'Green': 100000, // × 10^5
    'Blue': 1000000, // × 10^6
    'Violet': 10000000, // × 10^7
    'Grey': 100000000, // × 10^8 (rare)
    'White': 1000000000, // × 10^9 (rare)
    'Gold': 0.1, // × 10^-1
    'Silver': 0.01, // × 10^-2
  };

  // Tolerance values
  static const Map<String, String> _toleranceMap = {
    'Brown': '±1%',
    'Red': '±2%',
    'Orange': '±3%', // rare
    'Yellow': '±4%', // rare
    'Green': '±0.5%',
    'Blue': '±0.25%',
    'Violet': '±0.1%',
    'Grey': '±0.05%',
    'Gold': '±5%',
    'Silver': '±10%',
    'None': '±20%',
  };

  // Temperature coefficient (ppm/°C) for 6-band resistors
  static const Map<String, String> _tempCoeffMap = {
    'Black': '250 ppm/°C',
    'Brown': '100 ppm/°C',
    'Red': '50 ppm/°C',
    'Orange': '15 ppm/°C',
    'Yellow': '25 ppm/°C',
    'Green': '20 ppm/°C',
    'Blue': '10 ppm/°C',
    'Violet': '5 ppm/°C',
    'Grey': '1 ppm/°C',
  };

  /// Digit colors available for bands 1, 2, 3
  List<String> get digitColors => _digitMap.keys.toList();

  /// Multiplier colors
  List<String> get multiplierColors => _multiplierMap.keys.toList();

  /// Tolerance colors
  List<String> get toleranceColors =>
      _toleranceMap.keys.where((k) => k != 'None').toList();

  /// Temperature coefficient colors (band 6)
  List<String> get tempCoeffColors => _tempCoeffMap.keys.toList();

  bool isValidDigitColor(String color) => _digitMap.containsKey(color);
  bool isValidMultiplierColor(String color) =>
      _multiplierMap.containsKey(color);
  bool isValidToleranceColor(String color) => _toleranceMap.containsKey(color);
  bool isValidTempCoeffColor(String color) => _tempCoeffMap.containsKey(color);

  String? getTolerance(String color) => _toleranceMap[color];
  String? getTempCoeff(String color) => _tempCoeffMap[color];
  double? getMultiplier(String color) => _multiplierMap[color];
  int? getDigit(String color) => _digitMap[color];

  /// Calculate resistance for a 4-band resistor.
  ///
  /// Formula: R = (d1 × 10 + d2) × multiplier
  ResistorResult calculate4Band({
    required String band1,
    required String band2,
    required String band3Multiplier,
    required String band4Tolerance,
  }) {
    final d1 = _digitMap[band1] ?? 0;
    final d2 = _digitMap[band2] ?? 0;
    final multiplier = _multiplierMap[band3Multiplier] ?? 1.0;
    final tolerance = _toleranceMap[band4Tolerance] ?? '±20%';

    final resistance = (d1 * 10 + d2) * multiplier;
    final breakdown = _buildBreakdown4(
      band1,
      d1,
      band2,
      d2,
      band3Multiplier,
      multiplier,
      band4Tolerance,
      tolerance,
    );

    return _buildResult(
      bandCount: 4,
      colors: [band1, band2, band3Multiplier, band4Tolerance],
      resistance: resistance,
      tolerance: tolerance,
      breakdown: breakdown,
    );
  }

  /// Calculate resistance for a 5-band resistor.
  ///
  /// Formula: R = (d1 × 100 + d2 × 10 + d3) × multiplier
  ResistorResult calculate5Band({
    required String band1,
    required String band2,
    required String band3,
    required String band4Multiplier,
    required String band5Tolerance,
  }) {
    final d1 = _digitMap[band1] ?? 0;
    final d2 = _digitMap[band2] ?? 0;
    final d3 = _digitMap[band3] ?? 0;
    final multiplier = _multiplierMap[band4Multiplier] ?? 1.0;
    final tolerance = _toleranceMap[band5Tolerance] ?? '±20%';

    final resistance = (d1 * 100 + d2 * 10 + d3) * multiplier;
    final breakdown = _buildBreakdown5(
      band1,
      d1,
      band2,
      d2,
      band3,
      d3,
      band4Multiplier,
      multiplier,
      band5Tolerance,
      tolerance,
    );

    return _buildResult(
      bandCount: 5,
      colors: [band1, band2, band3, band4Multiplier, band5Tolerance],
      resistance: resistance,
      tolerance: tolerance,
      breakdown: breakdown,
    );
  }

  /// Calculate resistance for a 6-band resistor (includes temperature coefficient).
  ///
  /// Formula: R = (d1 × 100 + d2 × 10 + d3) × multiplier
  ResistorResult calculate6Band({
    required String band1,
    required String band2,
    required String band3,
    required String band4Multiplier,
    required String band5Tolerance,
    required String band6TempCoeff,
  }) {
    final d1 = _digitMap[band1] ?? 0;
    final d2 = _digitMap[band2] ?? 0;
    final d3 = _digitMap[band3] ?? 0;
    final multiplier = _multiplierMap[band4Multiplier] ?? 1.0;
    final tolerance = _toleranceMap[band5Tolerance] ?? '±20%';
    final tempCoeff = _tempCoeffMap[band6TempCoeff];

    final resistance = (d1 * 100 + d2 * 10 + d3) * multiplier;
    final breakdown = _buildBreakdown6(
      band1,
      d1,
      band2,
      d2,
      band3,
      d3,
      band4Multiplier,
      multiplier,
      band5Tolerance,
      tolerance,
      band6TempCoeff,
      tempCoeff ?? 'N/A',
    );

    return _buildResult(
      bandCount: 6,
      colors: [
        band1,
        band2,
        band3,
        band4Multiplier,
        band5Tolerance,
        band6TempCoeff,
      ],
      resistance: resistance,
      tolerance: tolerance,
      tempCoefficient: tempCoeff,
      breakdown: breakdown,
    );
  }

  ResistorResult _buildResult({
    required int bandCount,
    required List<String> colors,
    required double resistance,
    required String tolerance,
    String? tempCoefficient,
    required String breakdown,
  }) {
    return ResistorResult(
      bandCount: bandCount,
      selectedColors: colors,
      resistanceOhm: resistance,
      resistanceKOhm: resistance / 1000,
      resistanceMOhm: resistance / 1000000,
      tolerancePercent: tolerance,
      tempCoefficient: tempCoefficient,
      breakdown: breakdown,
    );
  }

  String _fmtNum(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(2)} MΩ';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(2)} kΩ';
    return '${v.toStringAsFixed(2)} Ω';
  }

  String _buildBreakdown4(
    String b1,
    int d1,
    String b2,
    int d2,
    String b3,
    double m,
    String b4,
    String tol,
  ) {
    return '''Band 1 ($b1) = $d1
Band 2 ($b2) = $d2
Band 3 ($b3) = × ${_fmtMultiplier(m)}
Band 4 ($b4) = $tol

Resistance = ($d1$d2) × ${_fmtMultiplier(m)}
           = ${d1 * 10 + d2} × ${_fmtMultiplier(m)}
           = ${_fmtNum((d1 * 10 + d2) * m)}''';
  }

  String _buildBreakdown5(
    String b1,
    int d1,
    String b2,
    int d2,
    String b3,
    int d3,
    String b4,
    double m,
    String b5,
    String tol,
  ) {
    return '''Band 1 ($b1) = $d1
Band 2 ($b2) = $d2
Band 3 ($b3) = $d3
Band 4 ($b4) = × ${_fmtMultiplier(m)}
Band 5 ($b5) = $tol

Resistance = ($d1$d2$d3) × ${_fmtMultiplier(m)}
           = ${d1 * 100 + d2 * 10 + d3} × ${_fmtMultiplier(m)}
           = ${_fmtNum((d1 * 100 + d2 * 10 + d3) * m)}''';
  }

  String _buildBreakdown6(
    String b1,
    int d1,
    String b2,
    int d2,
    String b3,
    int d3,
    String b4,
    double m,
    String b5,
    String tol,
    String b6,
    String tc,
  ) {
    return '''Band 1 ($b1) = $d1
Band 2 ($b2) = $d2
Band 3 ($b3) = $d3
Band 4 ($b4) = × ${_fmtMultiplier(m)}
Band 5 ($b5) = $tol
Band 6 ($b6) = $tc

Resistance = ($d1$d2$d3) × ${_fmtMultiplier(m)}
           = ${d1 * 100 + d2 * 10 + d3} × ${_fmtMultiplier(m)}
           = ${_fmtNum((d1 * 100 + d2 * 10 + d3) * m)}
Temp. Coeff. = $tc''';
  }

  String _fmtMultiplier(double m) {
    if (m >= 1) {
      final int im = m.toInt();
      return im.toString();
    }
    return m.toString();
  }

  /// Common resistor presets for quick selection
  static const List<Map<String, dynamic>> commonPresets = [
    {
      'label': '100Ω',
      'bands4': ['Brown', 'Black', 'Brown', 'Gold'],
    },
    {
      'label': '220Ω',
      'bands4': ['Red', 'Red', 'Brown', 'Gold'],
    },
    {
      'label': '330Ω',
      'bands4': ['Orange', 'Orange', 'Brown', 'Gold'],
    },
    {
      'label': '470Ω',
      'bands4': ['Yellow', 'Violet', 'Brown', 'Gold'],
    },
    {
      'label': '1kΩ',
      'bands4': ['Brown', 'Black', 'Red', 'Gold'],
    },
    {
      'label': '2.2kΩ',
      'bands4': ['Red', 'Red', 'Red', 'Gold'],
    },
    {
      'label': '4.7kΩ',
      'bands4': ['Yellow', 'Violet', 'Red', 'Gold'],
    },
    {
      'label': '10kΩ',
      'bands4': ['Brown', 'Black', 'Orange', 'Gold'],
    },
    {
      'label': '47kΩ',
      'bands4': ['Yellow', 'Violet', 'Orange', 'Gold'],
    },
    {
      'label': '100kΩ',
      'bands4': ['Brown', 'Black', 'Yellow', 'Gold'],
    },
    {
      'label': '1MΩ',
      'bands4': ['Brown', 'Black', 'Green', 'Gold'],
    },
  ];
}
