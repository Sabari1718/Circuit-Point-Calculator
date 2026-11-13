import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../domain/capacitor_calculator_service.dart';
import '../providers/capacitor_calculator_provider.dart';

class CapacitorCalculatorScreen extends ConsumerStatefulWidget {
  const CapacitorCalculatorScreen({super.key});

  @override
  ConsumerState<CapacitorCalculatorScreen> createState() =>
      _CapacitorCalculatorScreenState();
}

class _CapacitorCalculatorScreenState
    extends ConsumerState<CapacitorCalculatorScreen> {
  late TextEditingController _codeController;
  late TextEditingController _energyCapController;
  late TextEditingController _energyVoltController;
  late TextEditingController _energyResController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(capacitorCalculatorProvider);
    _codeController = TextEditingController(text: state.code);
    _energyCapController =
        TextEditingController(text: state.energyCapValue.toString());
    _energyVoltController =
        TextEditingController(text: state.energyVoltage.toString());
    _energyResController = TextEditingController(
      text: state.energyResistanceOhms?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _energyCapController.dispose();
    _energyVoltController.dispose();
    _energyResController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(capacitorCalculatorProvider);
    final notifier = ref.read(capacitorCalculatorProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Keep controllers synced if external preset changed
    if (_codeController.text != state.code && state.code.isNotEmpty) {
      _codeController.value = TextEditingValue(
        text: state.code,
        selection: TextSelection.collapsed(offset: state.code.length),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Capacitor Calculator'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt_rounded),
            tooltip: 'Reset',
            onPressed: () {
              notifier.reset();
              _codeController.text = '104';
              _energyCapController.text = '100';
              _energyVoltController.text = '12';
              _energyResController.text = '1000';
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Tab Switcher ─────────────────────────────────────
          _TabSelector(
            isDark: isDark,
            currentTab: state.tab,
            onTabSelected: notifier.setTab,
          ),
          const SizedBox(height: 20),

          // ── Content for Current Tab ──────────────────────────
          if (state.tab == CapacitorCalcTab.decoder) ...[
            _DecoderTabContent(
              isDark: isDark,
              state: state,
              controller: _codeController,
              onCodeChanged: notifier.decodeCode,
              onPresetSelected: (preset) {
                _codeController.text = preset;
                notifier.applyPresetCode(preset);
              },
            ),
          ] else if (state.tab == CapacitorCalcTab.seriesParallel) ...[
            _SeriesParallelTabContent(
              isDark: isDark,
              state: state,
              notifier: notifier,
            ),
          ] else ...[
            _EnergyRCTabContent(
              isDark: isDark,
              state: state,
              notifier: notifier,
              capController: _energyCapController,
              voltController: _energyVoltController,
              resController: _energyResController,
            ),
          ],

          const SizedBox(height: 20),

          // ── Action Buttons (Reset & Save) ────────────────────
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    notifier.reset();
                    _codeController.text = '104';
                    _energyCapController.text = '100';
                    _energyVoltController.text = '12';
                    _energyResController.text = '1000';
                  },
                  icon: const Icon(Icons.restart_alt_rounded, size: 18),
                  label: const Text('Reset'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GradientButton(
                  label: 'Save',
                  icon: Icons.save_rounded,
                  onPressed: () {
                    notifier.saveToHistory();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Saved calculation to history'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // ── Formula Reference ────────────────────────────────
          const SectionHeader(title: 'Formula Reference'),
          const SizedBox(height: 12),
          const _CapacitorFormulaReference(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// ── Tab Selector ───────────────────────────────────────────────────────────────
class _TabSelector extends StatelessWidget {
  final bool isDark;
  final CapacitorCalcTab currentTab;
  final ValueChanged<CapacitorCalcTab> onTabSelected;

  const _TabSelector({
    required this.isDark,
    required this.currentTab,
    required this.onTabSelected,
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
        children: [
          _buildItem(
            tab: CapacitorCalcTab.decoder,
            label: 'Code Decoder',
            icon: Icons.pin_rounded,
          ),
          _buildItem(
            tab: CapacitorCalcTab.seriesParallel,
            label: 'Series / Parallel',
            icon: Icons.alt_route_rounded,
          ),
          _buildItem(
            tab: CapacitorCalcTab.energyRC,
            label: 'Energy & RC',
            icon: Icons.bolt_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required CapacitorCalcTab tab,
    required String label,
    required IconData icon,
  }) {
    final isSelected = currentTab == tab;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(tab),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : (isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Tab 1: Code Decoder ────────────────────────────────────────────────────────
class _DecoderTabContent extends StatelessWidget {
  final bool isDark;
  final CapacitorCalculatorState state;
  final TextEditingController controller;
  final ValueChanged<String> onCodeChanged;
  final ValueChanged<String> onPresetSelected;

  const _DecoderTabContent({
    required this.isDark,
    required this.state,
    required this.controller,
    required this.onCodeChanged,
    required this.onPresetSelected,
  });

  @override
  Widget build(BuildContext context) {
    final result = state.codeResult;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Visual Capacitor Graphic ───────────────────────────
        _CapacitorVisual(
          isDark: isDark,
          code: state.code.isNotEmpty ? state.code : '---',
          voltage: result?.voltageRating != null
              ? '${result!.voltageRating}V'
              : null,
        ),
        const SizedBox(height: 20),

        // ── Input Field ────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter 3-Digit EIA / Ceramic Code',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: controller,
                autocorrect: false,
                textCapitalization: TextCapitalization.characters,
                style: GoogleFonts.sourceCodePro(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
                onChanged: onCodeChanged,
                decoration: InputDecoration(
                  hintText: 'e.g. 104, 473K, 220J, 4R7',
                  errorText: state.codeError,
                  prefixIcon: const Icon(
                    Icons.pin_rounded,
                    color: AppColors.primary,
                  ),
                  suffixIcon: controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () {
                            controller.clear();
                            onCodeChanged('');
                          },
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Tip: You can include tolerance letter (J=±5%, K=±10%, M=±20%) or decimal (4R7 = 4.7 pF).',
                style: GoogleFonts.outfit(
                  fontSize: 11.5,
                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // ── Common Presets ─────────────────────────────────────
        SectionHeader(title: 'Standard Capacitor Codes'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _PresetChip(
              label: '104 (0.1 µF)',
              sub: 'Bypass / Decoupling',
              onTap: () => onPresetSelected('104'),
              isDark: isDark,
            ),
            _PresetChip(
              label: '103 (10 nF)',
              sub: 'RF / Audio',
              onTap: () => onPresetSelected('103'),
              isDark: isDark,
            ),
            _PresetChip(
              label: '473 (47 nF)',
              sub: 'Tone Control',
              onTap: () => onPresetSelected('473'),
              isDark: isDark,
            ),
            _PresetChip(
              label: '102 (1 nF)',
              sub: 'Filter',
              onTap: () => onPresetSelected('102'),
              isDark: isDark,
            ),
            _PresetChip(
              label: '220 (22 pF)',
              sub: 'Crystal Load',
              onTap: () => onPresetSelected('220'),
              isDark: isDark,
            ),
            _PresetChip(
              label: '105 (1 µF)',
              sub: 'Coupling',
              onTap: () => onPresetSelected('105'),
              isDark: isDark,
            ),
            _PresetChip(
              label: '474 (470 nF)',
              sub: '0.47 µF Film Cap',
              onTap: () => onPresetSelected('474'),
              isDark: isDark,
            ),
            _PresetChip(
              label: '4R7 (4.7 pF)',
              sub: 'HF Tuned',
              onTap: () => onPresetSelected('4R7'),
              isDark: isDark,
            ),
          ],
        ),
        const SizedBox(height: 24),

        // ── Results ────────────────────────────────────────────
        if (result != null) ...[
          ResultCard(
            label: 'Decoded Value',
            value: result.formattedPrimary,
            subtitle: result.tolerance != null
                ? 'Tolerance: ${result.tolerance}'
                : 'Standard EIA Decoded',
            icon: Icons.check_circle_rounded,
            accentColor: AppColors.success,
            onCopy: () {
              Clipboard.setData(ClipboardData(text: result.formattedPrimary));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Copied value to clipboard'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          const SizedBox(height: 12),

          // Values Summary
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Column(
              children: [
                _buildSummaryRow(
                  label: 'Capacitor Code',
                  value: result.rawCode,
                  isDark: isDark,
                  isBold: true,
                ),
                Divider(
                  height: 16,
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                _buildSummaryRow(
                  label: 'Capacitance',
                  value:
                      '${CapacitorCalculatorService.formatWithCommas(result.picofarads)} pF',
                  isDark: isDark,
                ),
                Divider(
                  height: 16,
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                _buildSummaryRow(
                  label: 'Equivalent Value',
                  value:
                      '${CapacitorCalculatorService.formatNumber(result.nanofarads)} nF',
                  isDark: isDark,
                ),
                Divider(
                  height: 16,
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                _buildSummaryRow(
                  label: 'Equivalent Value',
                  value:
                      '${CapacitorCalculatorService.formatNumber(result.microfarads)} µF',
                  isDark: isDark,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Multi-unit conversions
          Row(
            children: [
              Expanded(
                child: _UnitMiniCard(
                  unit: 'Picofarads (pF)',
                  value: CapacitorCalculatorService.formatWithCommas(
                    result.picofarads,
                  ),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _UnitMiniCard(
                  unit: 'Nanofarads (nF)',
                  value: CapacitorCalculatorService.formatNumber(
                    result.nanofarads,
                  ),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _UnitMiniCard(
                  unit: 'Microfarads (µF)',
                  value: CapacitorCalculatorService.formatNumber(
                    result.microfarads,
                  ),
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Breakdown
          const SectionHeader(title: 'Decoding Breakdown'),
          const SizedBox(height: 8),
          BreakdownCard(breakdown: result.breakdown),
        ],
      ],
    );
  }

  Widget _buildSummaryRow({
    required String label,
    required String value,
    required bool isDark,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 13,
            color: isDark
                ? AppColors.textSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
        ),
      ],
    );
  }
}

// ── Tab 2: Series & Parallel ──────────────────────────────────────────────────
class _SeriesParallelTabContent extends StatelessWidget {
  final bool isDark;
  final CapacitorCalculatorState state;
  final CapacitorCalculatorNotifier notifier;

  const _SeriesParallelTabContent({
    required this.isDark,
    required this.state,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    final result = state.equivalentResult;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Capacitors in Network',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            TextButton.icon(
              onPressed: state.capacitors.length < 8
                  ? notifier.addCapacitorItem
                  : null,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Add Cap'),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // List of capacitors
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.capacitors.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final cap = state.capacitors[index];
            return _CapacitorInputRow(
              index: index,
              item: cap,
              isDark: isDark,
              canDelete: state.capacitors.length > 2,
              onChanged: (val, unit) =>
                  notifier.setCapacitorItem(index, val, unit),
              onDelete: () => notifier.removeCapacitorItem(index),
            );
          },
        ),
        const SizedBox(height: 20),

        // Result displays
        if (result != null) ...[
          ResultCard(
            label: 'Parallel Equivalent (Cp = C1 + C2 + ...)',
            value: result.parallelFormatted,
            subtitle: 'Capacitances add together directly in parallel',
            icon: Icons.linear_scale_rounded,
            accentColor: AppColors.primary,
            onCopy: () {
              Clipboard.setData(ClipboardData(text: result.parallelFormatted));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Copied parallel capacitance'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          ResultCard(
            label: 'Series Equivalent (1/Cs = 1/C1 + 1/C2 + ...)',
            value: result.seriesFormatted,
            subtitle: 'Total capacitance is smaller than the smallest cap',
            icon: Icons.grain_rounded,
            accentColor: AppColors.secondary,
            onCopy: () {
              Clipboard.setData(ClipboardData(text: result.seriesFormatted));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Copied series capacitance'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          const SectionHeader(title: 'Calculation Steps'),
          const SizedBox(height: 8),
          BreakdownCard(
            breakdown: '${result.parallelBreakdown}\n---\n${result.seriesBreakdown}',
          ),
        ],
      ],
    );
  }
}

// ── Tab 3: Energy & RC ────────────────────────────────────────────────────────
class _EnergyRCTabContent extends StatelessWidget {
  final bool isDark;
  final CapacitorCalculatorState state;
  final CapacitorCalculatorNotifier notifier;
  final TextEditingController capController;
  final TextEditingController voltController;
  final TextEditingController resController;

  const _EnergyRCTabContent({
    required this.isDark,
    required this.state,
    required this.notifier,
    required this.capController,
    required this.voltController,
    required this.resController,
  });

  @override
  Widget build(BuildContext context) {
    final result = state.energyResult;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Circuit Parameters',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 14),

              // Capacitance row with unit selector
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: CalculatorInputField(
                      controller: capController,
                      label: 'Capacitance (C)',
                      hint: '100',
                      prefixIcon: Icons.battery_charging_full_rounded,
                      onChanged: (val) {
                        final parsed = double.tryParse(val) ?? 0;
                        notifier.setEnergyParams(capValue: parsed);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<CapacitanceUnit>(
                          value: state.energyCapUnit,
                          isExpanded: true,
                          dropdownColor: isDark
                              ? AppColors.darkCard
                              : Colors.white,
                          items: CapacitanceUnit.values.map((u) {
                            return DropdownMenuItem(
                              value: u,
                              child: Text(
                                '${u.symbol} (${u.label})',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.textPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (u) {
                            if (u != null) {
                              notifier.setEnergyParams(capUnit: u);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Voltage field
              CalculatorInputField(
                controller: voltController,
                label: 'Voltage (V)',
                hint: '12',
                suffix: 'V',
                prefixIcon: Icons.electric_bolt_rounded,
                onChanged: (val) {
                  final parsed = double.tryParse(val) ?? 0;
                  notifier.setEnergyParams(voltage: parsed);
                },
              ),
              const SizedBox(height: 14),

              // Optional Resistor field for RC circuit
              CalculatorInputField(
                controller: resController,
                label: 'Series Resistor (R) - Optional for RC',
                hint: '1000',
                suffix: 'Ω',
                prefixIcon: Icons.tune_rounded,
                onChanged: (val) {
                  final parsed = double.tryParse(val);
                  notifier.setEnergyParams(resistanceOhms: parsed);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Results
        if (result != null) ...[
          ResultCard(
            label: 'Stored Energy (E = ½ C V²)',
            value: result.energyFormatted,
            subtitle: 'Potential energy held in electrostatic field',
            icon: Icons.energy_savings_leaf_rounded,
            accentColor: AppColors.warning,
            onCopy: () {
              Clipboard.setData(ClipboardData(text: result.energyFormatted));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Copied energy value'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          ResultCard(
            label: 'Electric Charge (Q = C × V)',
            value: result.chargeFormatted,
            subtitle: 'Total accumulated charge in Coulombs',
            icon: Icons.electric_meter_rounded,
            accentColor: AppColors.primary,
            onCopy: () {
              Clipboard.setData(ClipboardData(text: result.chargeFormatted));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Copied charge value'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          if (result.tauFormatted != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ResultCard(
                    label: 'RC Time Constant (τ)',
                    value: result.tauFormatted!,
                    subtitle: 'τ = R × C (63.2% charge)',
                    icon: Icons.timer_rounded,
                    accentColor: AppColors.secondary,
                  ),
                ),
                const SizedBox(width: 10),
                if (result.cutoffFormatted != null)
                  Expanded(
                    child: ResultCard(
                      label: 'Cutoff Freq (fc)',
                      value: result.cutoffFormatted!,
                      subtitle: 'fc = 1 / (2πRC)',
                      icon: Icons.graphic_eq_rounded,
                      accentColor: AppColors.accent,
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          const SectionHeader(title: 'Formulas & Breakdown'),
          const SizedBox(height: 8),
          BreakdownCard(breakdown: result.breakdown),
        ],
      ],
    );
  }
}

// ── Visual Capacitor Illustration ──────────────────────────────────────────────
class _CapacitorVisual extends StatelessWidget {
  final bool isDark;
  final String code;
  final String? voltage;

  const _CapacitorVisual({
    required this.isDark,
    required this.code,
    this.voltage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // Capacitor Body (Ceramic disc orange/tan styling)
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: const RadialGradient(
                center: Alignment(-0.2, -0.3),
                radius: 0.9,
                colors: [
                  Color(0xFFE5A967),
                  Color(0xFFC87828),
                  Color(0xFF9E5416),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: const Color(0xFFE5A967).withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: -4,
                ),
              ],
              border: Border.all(
                color: const Color(0xFFF3C185).withValues(alpha: 0.6),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    code,
                    style: GoogleFonts.sourceCodePro(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF1F1206),
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          offset: const Offset(1, 1),
                          blurRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  if (voltage != null) ...[
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        voltage!,
                        style: GoogleFonts.sourceCodePro(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1F1206),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // 2 Leads coming out
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 3.5,
                height: 28,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFC0C0C0), Color(0xFF808080)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 32),
              Container(
                width: 3.5,
                height: 28,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFC0C0C0), Color(0xFF808080)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Input Row for Series/Parallel ──────────────────────────────────────────────
class _CapacitorInputRow extends StatefulWidget {
  final int index;
  final CapacitorValueItem item;
  final bool isDark;
  final bool canDelete;
  final void Function(double, CapacitanceUnit) onChanged;
  final VoidCallback onDelete;

  const _CapacitorInputRow({
    required this.index,
    required this.item,
    required this.isDark,
    required this.canDelete,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<_CapacitorInputRow> createState() => _CapacitorInputRowState();
}

class _CapacitorInputRowState extends State<_CapacitorInputRow> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: CapacitorCalculatorService.formatNumber(widget.item.value),
    );
  }

  @override
  void didUpdateWidget(covariant _CapacitorInputRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.value != widget.item.value) {
      final text = CapacitorCalculatorService.formatNumber(widget.item.value);
      if (_controller.text != text) {
        _controller.text = text;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: widget.isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          // Index Badge
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'C${widget.index + 1}',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Value Field
          Expanded(
            flex: 3,
            child: TextField(
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: widget.isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
              ),
              onChanged: (val) {
                final d = double.tryParse(val) ?? 0;
                widget.onChanged(d, widget.item.unit);
              },
              decoration: const InputDecoration(
                isDense: true,
                hintText: 'Value',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Unit Dropdown
          Expanded(
            flex: 2,
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: widget.isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: widget.isDark
                      ? AppColors.darkBorder
                      : AppColors.lightBorder,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<CapacitanceUnit>(
                  value: widget.item.unit,
                  isExpanded: true,
                  dropdownColor: widget.isDark
                      ? AppColors.darkCard
                      : Colors.white,
                  items: CapacitanceUnit.values.map((u) {
                    return DropdownMenuItem(
                      value: u,
                      child: Text(
                        u.symbol,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: widget.isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (u) {
                    if (u != null) {
                      widget.onChanged(widget.item.value, u);
                    }
                  },
                ),
              ),
            ),
          ),

          // Delete button
          if (widget.canDelete) ...[
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, size: 20),
              color: AppColors.error.withValues(alpha: 0.8),
              onPressed: widget.onDelete,
            ),
          ],
        ],
      ),
    );
  }
}

// ── Mini unit card ─────────────────────────────────────────────────────────────
class _UnitMiniCard extends StatelessWidget {
  final String unit;
  final String value;
  final bool isDark;

  const _UnitMiniCard({
    required this.unit,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            unit,
            style: GoogleFonts.outfit(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Preset Chip ────────────────────────────────────────────────────────────────
class _PresetChip extends StatelessWidget {
  final String label;
  final String sub;
  final VoidCallback onTap;
  final bool isDark;

  const _PresetChip({
    required this.label,
    required this.sub,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            Text(
              sub,
              style: GoogleFonts.outfit(
                fontSize: 10,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Formula Reference Card ────────────────────────────────────────────────────
class _CapacitorFormulaReference extends StatelessWidget {
  const _CapacitorFormulaReference();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        FormulaCard(
          title: '3-Digit EIA Capacitor Code',
          formula: 'Capacitance (pF) = First two digits × 10^(Third digit)',
          description: 'Example: 104 = 10 × 10^4 pF = 100,000 pF = 100 nF (0.1 µF)',
        ),
        SizedBox(height: 10),
        FormulaCard(
          title: 'Parallel Capacitance',
          formula: 'C_parallel = C1 + C2 + C3 + ... + Cn',
          description: 'Total capacitance increases when capacitors are in parallel',
        ),
        SizedBox(height: 10),
        FormulaCard(
          title: 'Series Capacitance',
          formula: '1 / C_series = 1/C1 + 1/C2 + ... + 1/Cn',
          description: 'Total capacitance decreases when capacitors are in series',
        ),
        SizedBox(height: 10),
        FormulaCard(
          title: 'Electric Charge & Energy',
          formula: 'Q = C × V   |   E = ½ × C × V²',
          description: 'Charge stored in Coulombs; Energy stored in Joules',
        ),
        SizedBox(height: 10),
        FormulaCard(
          title: 'RC Circuit Time Constant & Cutoff',
          formula: 'τ = R × C   |   fc = 1 / (2πRC)',
          description: 'τ (tau) is the time to reach 63.2% charge; 5τ is 99.3% full charge',
        ),
      ],
    );
  }
}

