import 'dart:convert';

enum CalculationType {
  power,
  resistor;

  String get displayName {
    switch (this) {
      case CalculationType.power:
        return 'Power Calculator';
      case CalculationType.resistor:
        return 'Resistor Colour Code';
    }
  }

  static CalculationType parse(dynamic value) {
    if (value == null) return CalculationType.power;
    if (value is CalculationType) return value;
    final str = value.toString().toLowerCase();
    if (str.contains('resistor')) return CalculationType.resistor;
    return CalculationType.power;
  }
}

enum PowerMode { dc, acSingle, acThree }

class CalculationRecord {
  final String id;
  final CalculationType type;
  final String title;
  final Map<String, String> inputs;
  final String result;
  final String unit;
  final DateTime timestamp;

  const CalculationRecord({
    required this.id,
    required this.type,
    required this.title,
    required this.inputs,
    required this.result,
    required this.unit,
    required this.timestamp,
  });

  bool get isPower => type == CalculationType.power;
  String get typeDisplayName => type.displayName;

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'title': title,
    'inputs': inputs,
    'result': result,
    'unit': unit,
    'timestamp': timestamp.toIso8601String(),
  };

  factory CalculationRecord.fromJson(Map<String, dynamic> json) =>
      CalculationRecord(
        id: (json['id'] ?? '') as String,
        type: CalculationType.parse(json['type']),
        title: (json['title'] ?? 'Calculation') as String,
        inputs: json['inputs'] is Map
            ? Map<String, String>.from(json['inputs'] as Map)
            : const {},
        result: (json['result'] ?? '') as String,
        unit: (json['unit'] ?? '') as String,
        timestamp: json['timestamp'] != null
            ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
            : DateTime.now(),
      );

  String toJsonString() => jsonEncode(toJson());

  factory CalculationRecord.fromJsonString(String s) {
    try {
      final decoded = jsonDecode(s);
      if (decoded is Map<String, dynamic>) {
        return CalculationRecord.fromJson(decoded);
      }
      if (decoded is Map) {
        return CalculationRecord.fromJson(Map<String, dynamic>.from(decoded));
      }
    } catch (_) {}
    return CalculationRecord(
      id: 'fallback_${DateTime.now().millisecondsSinceEpoch}',
      type: CalculationType.power,
      title: 'Power Calculation',
      inputs: const {},
      result: '0',
      unit: 'W',
      timestamp: DateTime.now(),
    );
  }
}

class PowerCalculationResult {
  final double voltage;
  final double current;
  final double? powerFactor;
  final PowerMode mode;
  final double watts;
  final double kilowatts;
  final String formula;
  final String breakdown;

  const PowerCalculationResult({
    required this.voltage,
    required this.current,
    this.powerFactor,
    required this.mode,
    required this.watts,
    required this.kilowatts,
    required this.formula,
    required this.breakdown,
  });
}

class ResistorResult {
  final int bandCount;
  final List<String> selectedColors;
  final double resistanceOhm;
  final double resistanceKOhm;
  final double resistanceMOhm;
  final String tolerancePercent;
  final String? tempCoefficient;
  final String breakdown;

  const ResistorResult({
    required this.bandCount,
    required this.selectedColors,
    required this.resistanceOhm,
    required this.resistanceKOhm,
    required this.resistanceMOhm,
    required this.tolerancePercent,
    this.tempCoefficient,
    required this.breakdown,
  });
}
