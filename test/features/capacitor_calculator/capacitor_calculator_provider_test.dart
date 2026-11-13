import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltwise/features/capacitor_calculator/providers/capacitor_calculator_provider.dart';

void main() {
  group('CapacitorCalculatorNotifier - Code Decoding and Validation', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state decodes 104 -> 100 nF (0.1 µF)', () {
      final state = container.read(capacitorCalculatorProvider);
      expect(state.code, '104');
      expect(state.codeResult, isNotNull);
      expect(state.codeResult!.formattedPrimary, '100 nF (0.1 µF)');
      expect(state.codeError, isNull);
    });

    test('decodeCode 473 -> 47 nF', () {
      final notifier = container.read(capacitorCalculatorProvider.notifier);
      notifier.decodeCode('473');
      final state = container.read(capacitorCalculatorProvider);
      expect(state.codeResult, isNotNull);
      expect(state.codeResult!.formattedPrimary, '47 nF');
      expect(state.codeError, isNull);
    });

    test('decodeCode 474 -> 470 nF', () {
      final notifier = container.read(capacitorCalculatorProvider.notifier);
      notifier.decodeCode('474');
      final state = container.read(capacitorCalculatorProvider);
      expect(state.codeResult, isNotNull);
      expect(state.codeResult!.formattedPrimary, '470 nF');
      expect(state.codeError, isNull);
    });

    test('empty input clears codeResult and sets codeError', () {
      final notifier = container.read(capacitorCalculatorProvider.notifier);
      notifier.decodeCode('');
      final state = container.read(capacitorCalculatorProvider);
      expect(state.codeResult, isNull);
      expect(state.codeError, 'Capacitor code cannot be empty');
    });

    test('invalid input clears codeResult and sets codeError', () {
      final notifier = container.read(capacitorCalculatorProvider.notifier);
      // First ensure valid
      notifier.decodeCode('104');
      expect(container.read(capacitorCalculatorProvider).codeResult, isNotNull);

      // Now enter invalid code with 4 digits
      notifier.decodeCode('1045');
      final state = container.read(capacitorCalculatorProvider);
      expect(state.codeResult, isNull,
          reason: 'Previous valid result must be cleared on invalid input');
      expect(state.codeError, isNotNull);
      expect(state.codeError, contains('Unsupported capacitor marking'));
    });

    test('reset restores default 104 with correct primary value', () {
      final notifier = container.read(capacitorCalculatorProvider.notifier);
      notifier.decodeCode('473');
      expect(container.read(capacitorCalculatorProvider).code, '473');

      notifier.reset();
      final state = container.read(capacitorCalculatorProvider);
      expect(state.code, '104');
      expect(state.codeResult, isNotNull);
      expect(state.codeResult!.formattedPrimary, '100 nF (0.1 µF)');
    });
  });
}

