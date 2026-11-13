import 'package:flutter_test/flutter_test.dart';
import 'package:voltwise/features/capacitor_calculator/domain/capacitor_calculator_service.dart';

void main() {
  group('CapacitorCalculatorService - Required Specification Table', () {
    const service = CapacitorCalculatorService();

    test('101 -> 100 pF', () {
      final res = service.decodeCode('101');
      expect(res.picofarads, 100);
      expect(res.nanofarads, 0.1);
      expect(res.microfarads, 0.0001);
      expect(res.formattedPrimary, '100 pF');
    });

    test('102 -> 1 nF', () {
      final res = service.decodeCode('102');
      expect(res.picofarads, 1000);
      expect(res.nanofarads, 1);
      expect(res.microfarads, 0.001);
      expect(res.formattedPrimary, '1 nF');
    });

    test('103 -> 10 nF', () {
      final res = service.decodeCode('103');
      expect(res.picofarads, 10000);
      expect(res.nanofarads, 10);
      expect(res.microfarads, 0.01);
      expect(res.formattedPrimary, '10 nF');
    });

    test('104 -> 100 nF (0.1 µF) - Primary Acceptance Test', () {
      final res = service.decodeCode('104');
      expect(res.rawCode, '104');
      expect(res.picofarads, 100000);
      expect(res.nanofarads, 100);
      expect(res.microfarads, 0.1);
      expect(res.formattedPrimary, '100 nF (0.1 µF)');
      expect(res.picofaradsFormatted, '100,000 pF');
      expect(res.nanofaradsFormatted, '100 nF');
      expect(res.microfaradsFormatted, '0.1 µF');
      expect(res.breakdown, contains('Capacitor Code: 104'));
      expect(res.breakdown, contains('Capacitance: 100,000 pF'));
      expect(res.breakdown, contains('Equivalent Value: 100 nF'));
      expect(res.breakdown, contains('Equivalent Value: 0.1 µF'));
      expect(res.breakdown, contains('Formula:'));
      expect(res.breakdown, contains('Calculation Steps:'));
    });

    test('105 -> 1 µF', () {
      final res = service.decodeCode('105');
      expect(res.picofarads, 1000000);
      expect(res.nanofarads, 1000);
      expect(res.microfarads, 1.0);
      expect(res.formattedPrimary, '1 µF');
    });

    test('222 -> 2.2 nF', () {
      final res = service.decodeCode('222');
      expect(res.picofarads, 2200);
      expect(res.nanofarads, 2.2);
      expect(res.microfarads, 0.0022);
      expect(res.formattedPrimary, '2.2 nF');
    });

    test('223 -> 22 nF', () {
      final res = service.decodeCode('223');
      expect(res.picofarads, 22000);
      expect(res.nanofarads, 22);
      expect(res.microfarads, 0.022);
      expect(res.formattedPrimary, '22 nF');
    });

    test('472 -> 4.7 nF', () {
      final res = service.decodeCode('472');
      expect(res.picofarads, 4700);
      expect(res.nanofarads, 4.7);
      expect(res.microfarads, 0.0047);
      expect(res.formattedPrimary, '4.7 nF');
    });

    test('473 -> 47 nF - Primary Acceptance Test', () {
      final res = service.decodeCode('473');
      expect(res.picofarads, 47000);
      expect(res.nanofarads, 47);
      expect(res.microfarads, 0.047);
      expect(res.formattedPrimary, '47 nF');
      expect(res.picofaradsFormatted, '47,000 pF');
    });

    test('474 -> 470 nF - Primary Acceptance Test', () {
      final res = service.decodeCode('474');
      expect(res.picofarads, 470000);
      expect(res.nanofarads, 470);
      expect(res.microfarads, 0.47);
      expect(res.formattedPrimary, '470 nF');
      expect(res.picofaradsFormatted, '470,000 pF');
    });

    test('331 -> 330 pF', () {
      final res = service.decodeCode('331');
      expect(res.picofarads, 330);
      expect(res.nanofarads, 0.33);
      expect(res.formattedPrimary, '330 pF');
    });

    test('471 -> 470 pF', () {
      final res = service.decodeCode('471');
      expect(res.picofarads, 470);
      expect(res.nanofarads, 0.47);
      expect(res.formattedPrimary, '470 pF');
    });
  });

  group('CapacitorCalculatorService - Special Multipliers 8 and 9', () {
    const service = CapacitorCalculatorService();

    test('multiplier 8 (x0.01): 108 -> 0.1 pF', () {
      final res = service.decodeCode('108');
      expect(res.picofarads, 0.1);
      expect(res.formattedPrimary, '0.1 pF');
      expect(res.breakdown, contains('0.01'));
    });

    test('multiplier 8 (x0.01): 228 -> 0.22 pF', () {
      final res = service.decodeCode('228');
      expect(res.picofarads, 0.22);
      expect(res.formattedPrimary, '0.22 pF');
    });

    test('multiplier 8 (x0.01): 478 -> 0.47 pF', () {
      final res = service.decodeCode('478');
      expect(res.picofarads, 0.47);
      expect(res.formattedPrimary, '0.47 pF');
    });

    test('multiplier 9 (x0.1): 109 -> 1 pF', () {
      final res = service.decodeCode('109');
      expect(res.picofarads, 1);
      expect(res.formattedPrimary, '1 pF');
      expect(res.breakdown, contains('0.1'));
    });

    test('multiplier 9 (x0.1): 229 -> 2.2 pF', () {
      final res = service.decodeCode('229');
      expect(res.picofarads, 2.2);
      expect(res.formattedPrimary, '2.2 pF');
    });

    test('multiplier 9 (x0.1): 479 -> 4.7 pF', () {
      final res = service.decodeCode('479');
      expect(res.picofarads, 4.7);
      expect(res.formattedPrimary, '4.7 pF');
    });
  });

  group('CapacitorCalculatorService - Boundary & Existing Markings', () {
    const service = CapacitorCalculatorService();

    test('single-digit code: 8 -> 8 pF', () {
      final res = service.decodeCode('8');
      expect(res.picofarads, 8);
      expect(res.formattedPrimary, '8 pF');
    });

    test('two-digit code: 47 -> 47 pF', () {
      final res = service.decodeCode('47');
      expect(res.picofarads, 47);
      expect(res.formattedPrimary, '47 pF');
    });

    test('3-digit zero multiplier: 220 -> 22 pF', () {
      final res = service.decodeCode('220');
      expect(res.picofarads, 22);
      expect(res.formattedPrimary, '22 pF');
    });

    test('decimal R-notation: 4R7 -> 4.7 pF', () {
      final res = service.decodeCode('4R7');
      expect(res.picofarads, 4.7);
      expect(res.formattedPrimary, '4.7 pF');
    });

    test('decimal R-notation: 0R5 -> 0.5 pF', () {
      final res = service.decodeCode('0R5');
      expect(res.picofarads, 0.5);
      expect(res.formattedPrimary, '0.5 pF');
    });

    test('tolerance suffix: 473K -> 47 nF, +/-10%', () {
      final res = service.decodeCode('473K');
      expect(res.picofarads, 47000);
      expect(res.nanofarads, 47);
      expect(res.tolerance, contains('±10%'));
    });

    test('voltage prefix and tolerance: 1H104K -> 50V, 100 nF (0.1 µF), +/-10%', () {
      final res = service.decodeCode('1H104K');
      expect(res.voltageRating, 50);
      expect(res.picofarads, 100000);
      expect(res.formattedPrimary, '100 nF (0.1 µF)');
      expect(res.tolerance, contains('±10%'));
    });
  });

  group('CapacitorCalculatorService - Input Validation & Rejection', () {
    const service = CapacitorCalculatorService();

    test('rejects empty input', () {
      expect(() => service.decodeCode(''), throwsArgumentError);
      expect(() => service.decodeCode('   '), throwsArgumentError);
    });

    test('rejects codes with 4 or more digits (does not silently truncate)', () {
      expect(() => service.decodeCode('1040'), throwsArgumentError);
      expect(() => service.decodeCode('12345'), throwsArgumentError);
      expect(() => service.decodeCode('104000'), throwsArgumentError);
    });

    test('rejects non-numeric invalid characters', () {
      expect(() => service.decodeCode('ABC'), throwsArgumentError);
      expect(() => service.decodeCode('10X'), throwsArgumentError);
      expect(() => service.decodeCode('10-4'), throwsArgumentError);
      expect(() => service.decodeCode('10.4'), throwsArgumentError);
    });

    test('rejects unsupported tolerance letters', () {
      expect(() => service.decodeCode('104Q'), throwsArgumentError);
    });

    test('rejects zero or negative capacitance values', () {
      expect(() => service.decodeCode('000'), throwsArgumentError);
      expect(() => service.decodeCode('0'), throwsArgumentError);
    });

    test('rejects invalid decimal R notation', () {
      expect(() => service.decodeCode('4RR7'), throwsArgumentError);
      expect(() => service.decodeCode('R'), throwsArgumentError);
      expect(() => service.decodeCode('0R0'), throwsArgumentError);
    });
  });

  group('CapacitorCalculatorService - Series & Parallel', () {
    const service = CapacitorCalculatorService();

    test('calculates two equal parallel capacitors', () {
      final res = service.calculateEquivalent([
        const CapacitorValueItem(value: 10, unit: CapacitanceUnit.uF),
        const CapacitorValueItem(value: 10, unit: CapacitanceUnit.uF),
      ]);
      expect(res.parallelFormatted, '20 µF');
      expect(res.seriesFormatted, '5 µF');
    });

    test('calculates series of 10uF and 22uF', () {
      final res = service.calculateEquivalent([
        const CapacitorValueItem(value: 10, unit: CapacitanceUnit.uF),
        const CapacitorValueItem(value: 22, unit: CapacitanceUnit.uF),
      ]);
      expect(res.parallelFormatted, '32 µF');
      expect(res.seriesFormatted, '6.875 µF');
    });
  });

  group('CapacitorCalculatorService - Charge, Energy & RC', () {
    const service = CapacitorCalculatorService();

    test('calculates charge and energy', () {
      final res = service.calculateEnergyAndRC(
        capacitanceValue: 100,
        unit: CapacitanceUnit.uF,
        voltage: 12,
        resistanceOhms: 1000,
      );
      expect(res.chargeFormatted, '1.2 mC');
      expect(res.energyFormatted, '7.2 mJ');
      expect(res.tauFormatted, '100 ms');
    });
  });
}
