import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../providers/power_calculator_provider.dart';
import '../../history/domain/calculation_record.dart';

class PowerCalculatorScreen extends ConsumerStatefulWidget {
  const PowerCalculatorScreen({super.key});

  @override
  ConsumerState<PowerCalculatorScreen> createState() =>
      _PowerCalculatorScreenState();
}

class _PowerCalculatorScreenState extends ConsumerState<PowerCalculatorScreen> {
  final _voltageController = TextEditingController();
  final _currentController = TextEditingController();
  final _pfController = TextEditingController(text: '1.0');

  @override
  void dispose() {
    _voltageController.dispose();
    _currentController.dispose();
    _pfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(powerCalculatorProvider);
    final notifier = ref.read(powerCalculatorProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Power Calculator'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Reset',
            onPressed: () {
              notifier.clear();
              _voltageController.clear();
              _currentController.clear();
              _pfController.text = '1.0';
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Mode Selector ──────────────────────────────────
          _ModeSelectorCard(
            isDark: isDark,
            selected: state.mode,
            onChanged: notifier.setMode,
          ),
          const SizedBox(height: 20),

          // ── Input Section ──────────────────────────────────
          _InputSection(
            isDark: isDark,
            state: state,
            voltageController: _voltageController,
            currentController: _currentController,
            pfController: _pfController,
            onVoltageChanged: notifier.setVoltage,
            onCurrentChanged: notifier.setCurrent,
            onPfChanged: notifier.setPowerFactor,
          ),
          const SizedBox(height: 16),

          // ── AC Power Factor Note ───────────────────────────
          if (state.showPowerFactor) _PFNoteCard(isDark: isDark),

          const SizedBox(height: 16),

          // ── Action Buttons ─────────────────────────────────
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    notifier.clear();
                    _voltageController.clear();
                    _currentController.clear();
                    _pfController.text = '1.0';
                  },
                  icon: const Icon(Icons.clear_rounded, size: 18),
                  label: const Text('Clear'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: GradientButton(
                  label: 'Calculate',
                  icon: Icons.calculate_rounded,
                  onPressed:
                      state.voltage.isNotEmpty && state.current.isNotEmpty
                      ? () => notifier.calculate()
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Results ────────────────────────────────────────
          if (state.result != null) ...[
            _ResultsSection(isDark: isDark, result: state.result!),
          ],

          // ── Formula Reference ──────────────────────────────
          const SizedBox(height: 20),
          SectionHeader(title: 'Formulas'),
          const SizedBox(height: 12),
          const FormulaCard(
            title: 'DC Power',
            formula: 'P = V × I',
            description: 'Direct current – voltage × current',
          ),
          const SizedBox(height: 8),
          const FormulaCard(
            title: 'AC Single-Phase',
            formula: 'P = V × I × PF',
            description: 'Real power with power factor correction',
          ),
          const SizedBox(height: 8),
          const FormulaCard(
            title: 'AC Three-Phase',
            formula: 'P = √3 × V × I × PF',
            description: 'Line voltage and line current',
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _ModeSelectorCard extends StatelessWidget {
  final bool isDark;
  final PowerMode selected;
  final ValueChanged<PowerMode> onChanged;

  const _ModeSelectorCard({
    required this.isDark,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: PowerMode.values.map((mode) {
          final isSelected = mode == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(mode),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(2),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _label(mode),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : (isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _label(PowerMode m) {
    switch (m) {
      case PowerMode.dc:
        return 'DC';
      case PowerMode.acSingle:
        return 'AC 1φ';
      case PowerMode.acThree:
        return 'AC 3φ';
    }
  }
}

class _InputSection extends StatelessWidget {
  final bool isDark;
  final PowerCalculatorState state;
  final TextEditingController voltageController;
  final TextEditingController currentController;
  final TextEditingController pfController;
  final ValueChanged<String> onVoltageChanged;
  final ValueChanged<String> onCurrentChanged;
  final ValueChanged<String> onPfChanged;

  const _InputSection({
    required this.isDark,
    required this.state,
    required this.voltageController,
    required this.currentController,
    required this.pfController,
    required this.onVoltageChanged,
    required this.onCurrentChanged,
    required this.onPfChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Input Values',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 16),
          CalculatorInputField(
            controller: voltageController,
            label: 'Voltage',
            suffix: 'V',
            hint: 'e.g. 220',
            prefixIcon: Icons.electrical_services_rounded,
            errorText: state.voltageError,
            onChanged: onVoltageChanged,
          ),
          const SizedBox(height: 14),
          CalculatorInputField(
            controller: currentController,
            label: 'Current',
            suffix: 'A',
            hint: 'e.g. 5',
            prefixIcon: Icons.moving_rounded,
            errorText: state.currentError,
            onChanged: onCurrentChanged,
          ),
          if (state.showPowerFactor) ...[
            const SizedBox(height: 14),
            CalculatorInputField(
              controller: pfController,
              label: 'Power Factor',
              suffix: 'PF',
              hint: '0.0 – 1.0',
              prefixIcon: Icons.percent_rounded,
              errorText: state.powerFactorError,
              onChanged: onPfChanged,
            ),
          ],
        ],
      ),
    );
  }
}

class _PFNoteCard extends StatelessWidget {
  final bool isDark;
  const _PFNoteCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withOpacity(0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.warning,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'For AC circuits, voltage and current alone only give apparent power (VA). The power factor (PF) is required to calculate real power (W).',
              style: GoogleFonts.outfit(
                fontSize: 12,
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultsSection extends StatelessWidget {
  final bool isDark;
  final PowerCalculationResult result;

  const _ResultsSection({required this.isDark, required this.result});

  void _copy(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied: $text'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = result.watts;
    final kw = result.kilowatts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Result'),
        const SizedBox(height: 12),
        ResultCard(
          label: 'Real Power',
          value: '${_fmt(w)} W',
          subtitle: 'Watts',
          icon: Icons.electric_bolt_rounded,
          accentColor: AppColors.primary,
          onCopy: () => _copy(context, '${_fmt(w)} W'),
        ),
        const SizedBox(height: 10),
        ResultCard(
          label: 'Power in Kilowatts',
          value: '${_fmtKW(kw)} kW',
          subtitle: 'Kilowatts',
          icon: Icons.power_rounded,
          accentColor: AppColors.secondary,
          onCopy: () => _copy(context, '${_fmtKW(kw)} kW'),
        ),
        const SizedBox(height: 16),
        SectionHeader(title: 'Calculation Breakdown'),
        const SizedBox(height: 12),
        BreakdownCard(breakdown: result.breakdown),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.primaryContainer
                : const Color(0xFFEEF4FF),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.functions_rounded,
                color: AppColors.primary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Formula: ${result.formula}',
                style: GoogleFonts.sourceCodePro(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _fmt(double v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toStringAsFixed(2);
  }

  String _fmtKW(double v) {
    return v.toStringAsFixed(4);
  }
}
