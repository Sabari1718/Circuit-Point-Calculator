import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../providers/resistor_calculator_provider.dart';
import '../domain/resistor_calculator_service.dart';
import '../../history/domain/calculation_record.dart';

class ResistorCalculatorScreen extends ConsumerWidget {
  const ResistorCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(resistorCalculatorProvider);
    final notifier = ref.read(resistorCalculatorProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resistor Colour Code'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt_rounded),
            tooltip: 'Reset',
            onPressed: notifier.reset,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Band Count Selector ────────────────────────────
          _BandCountSelector(
            isDark: isDark,
            selected: state.bandCount,
            onChanged: notifier.setBandCount,
          ),
          const SizedBox(height: 20),

          // ── Resistor Illustration ──────────────────────────
          _ResistorIllustration(
            isDark: isDark,
            bandCount: state.bandCount,
            colors: state.activeBands,
          ),
          const SizedBox(height: 20),

          // ── Colour Band Selectors ──────────────────────────
          _BandSelectors(
            isDark: isDark,
            state: state,
            onBandChanged: notifier.setBand,
          ),
          const SizedBox(height: 16),

          // ── Action Buttons ─────────────────────────────────
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: notifier.reset,
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
                        content: Text('Saved to history'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Results ────────────────────────────────────────
          if (state.result != null) ...[
            _ResistorResults(isDark: isDark, result: state.result!),
          ],

          // ── Common Presets ─────────────────────────────────
          const SizedBox(height: 20),
          SectionHeader(title: 'Common Presets'),
          const SizedBox(height: 14),
          _PresetsGrid(
            isDark: isDark,
            onPresetSelected: (bands) => notifier.applyPreset(bands),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ── Band Count Selector ────────────────────────────────────────────────────────
class _BandCountSelector extends StatelessWidget {
  final bool isDark;
  final int selected;
  final ValueChanged<int> onChanged;

  const _BandCountSelector({
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
        children: [4, 5, 6].map((count) {
          final isSelected = count == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(count),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(2),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.secondary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count Band',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? AppColors.darkBackground
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
}

// ── Resistor Illustration ──────────────────────────────────────────────────────
class _ResistorIllustration extends StatelessWidget {
  final bool isDark;
  final int bandCount;
  final List<String> colors;

  const _ResistorIllustration({
    required this.isDark,
    required this.bandCount,
    required this.colors,
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
        children: [
          Text(
            'Resistor Preview',
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 80,
            child: CustomPaint(
              size: const Size(double.infinity, 80),
              painter: _ResistorPainter(
                bandCount: bandCount,
                colors: colors,
                isDark: isDark,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Band labels
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < colors.length; i++) ...[
                _BandLabel(
                  bandIndex: i + 1,
                  color: colors[i],
                  bandCount: bandCount,
                  isDark: isDark,
                ),
                if (i < colors.length - 1) const SizedBox(width: 6),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _BandLabel extends StatelessWidget {
  final int bandIndex;
  final String color;
  final int bandCount;
  final bool isDark;

  const _BandLabel({
    required this.bandIndex,
    required this.color,
    required this.bandCount,
    required this.isDark,
  });

  String get _role {
    if (bandCount == 4) {
      switch (bandIndex) {
        case 1:
          return 'D1';
        case 2:
          return 'D2';
        case 3:
          return 'Mult';
        case 4:
          return 'Tol';
        default:
          return '';
      }
    } else if (bandCount == 5) {
      switch (bandIndex) {
        case 1:
          return 'D1';
        case 2:
          return 'D2';
        case 3:
          return 'D3';
        case 4:
          return 'Mult';
        case 5:
          return 'Tol';
        default:
          return '';
      }
    } else {
      switch (bandIndex) {
        case 1:
          return 'D1';
        case 2:
          return 'D2';
        case 3:
          return 'D3';
        case 4:
          return 'Mult';
        case 5:
          return 'Tol';
        case 6:
          return 'TC';
        default:
          return '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bandColor = AppColors.resistorColors[color] ?? Colors.grey;
    return Column(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: bandColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: (isDark ? Colors.white : Colors.black).withOpacity(0.15),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _role,
          style: GoogleFonts.outfit(
            fontSize: 9,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }
}

class _ResistorPainter extends CustomPainter {
  final int bandCount;
  final List<String> colors;
  final bool isDark;

  _ResistorPainter({
    required this.bandCount,
    required this.colors,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bodyColor = isDark
        ? const Color(0xFFD4A843)
        : const Color(0xFFE8C06A);
    final wireColor = isDark
        ? const Color(0xFF9EAEC8)
        : const Color(0xFF8A9BB5);
    final bodyH = size.height * 0.45;
    final bodyTop = (size.height - bodyH) / 2;
    final wireY = size.height / 2;
    final bodyWidth = size.width * 0.55;
    final bodyLeft = (size.width - bodyWidth) / 2;

    // Wire left
    final wirePaint = Paint()
      ..color = wireColor
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(0, wireY), Offset(bodyLeft, wireY), wirePaint);
    // Wire right
    canvas.drawLine(
      Offset(bodyLeft + bodyWidth, wireY),
      Offset(size.width, wireY),
      wirePaint,
    );

    // Body
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(bodyLeft, bodyTop, bodyWidth, bodyH),
      const Radius.circular(10),
    );
    final bodyPaint = Paint()..color = bodyColor;
    canvas.drawRRect(bodyRect, bodyPaint);

    // Shadow inside body
    final shadowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.white.withOpacity(0.2), Colors.transparent],
      ).createShader(Rect.fromLTWH(bodyLeft, bodyTop, bodyWidth, bodyH));
    canvas.drawRRect(bodyRect, shadowPaint);

    // Colour bands
    final bandWidth = 10.0;
    final usableWidth = bodyWidth - 20;

    // Calculate band positions
    List<double> positions = [];
    if (bandCount == 4) {
      // 3 bands clustered left, 1 band on right with gap
      positions = [
        bodyLeft + 14,
        bodyLeft + 30,
        bodyLeft + 46,
        bodyLeft + bodyWidth - 22,
      ];
    } else if (bandCount == 5) {
      // 3 digits + mult left, tol right
      final spacing = usableWidth / 5;
      for (int i = 0; i < 4; i++) {
        positions.add(bodyLeft + 12 + spacing * i);
      }
      positions.add(bodyLeft + bodyWidth - 20);
    } else {
      // 6 bands evenly spaced
      final spacing = usableWidth / 6.5;
      for (int i = 0; i < 5; i++) {
        positions.add(bodyLeft + 10 + spacing * i);
      }
      positions.add(bodyLeft + bodyWidth - 14);
    }

    for (int i = 0; i < colors.length && i < positions.length; i++) {
      final bandColor = AppColors.resistorColors[colors[i]] ?? Colors.grey;
      final bandPaint = Paint()..color = bandColor;
      final bandRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          positions[i] - bandWidth / 2,
          bodyTop + 1,
          bandWidth,
          bodyH - 2,
        ),
        const Radius.circular(2),
      );
      canvas.drawRRect(bandRect, bandPaint);
    }

    // Body outline
    final outlinePaint = Paint()
      ..color = Colors.black.withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRRect(bodyRect, outlinePaint);
  }

  @override
  bool shouldRepaint(covariant _ResistorPainter old) =>
      old.colors != colors ||
      old.bandCount != bandCount ||
      old.isDark != isDark;
}

// ── Band Selectors ─────────────────────────────────────────────────────────────
class _BandSelectors extends StatelessWidget {
  final bool isDark;
  final ResistorCalculatorState state;
  final void Function(int index, String color) onBandChanged;

  const _BandSelectors({
    required this.isDark,
    required this.state,
    required this.onBandChanged,
  });

  List<String> _availableColors(int bandIndex) {
    final service = const ResistorCalculatorService();
    if (state.bandCount == 4) {
      if (bandIndex <= 2) return service.digitColors;
      if (bandIndex == 3) return service.multiplierColors;
      return service.toleranceColors;
    } else if (state.bandCount == 5) {
      if (bandIndex <= 3) return service.digitColors;
      if (bandIndex == 4) return service.multiplierColors;
      return service.toleranceColors;
    } else {
      if (bandIndex <= 3) return service.digitColors;
      if (bandIndex == 4) return service.multiplierColors;
      if (bandIndex == 5) return service.toleranceColors;
      return service.tempCoeffColors;
    }
  }

  String _bandLabel(int index) {
    if (state.bandCount == 4) {
      return ['1st Digit', '2nd Digit', 'Multiplier', 'Tolerance'][index - 1];
    } else if (state.bandCount == 5) {
      return [
        '1st Digit',
        '2nd Digit',
        '3rd Digit',
        'Multiplier',
        'Tolerance',
      ][index - 1];
    } else {
      return [
        '1st Digit',
        '2nd Digit',
        '3rd Digit',
        'Multiplier',
        'Tolerance',
        'Temp. Coeff.',
      ][index - 1];
    }
  }

  String _selectedColor(int index) {
    switch (index) {
      case 1:
        return state.band1;
      case 2:
        return state.band2;
      case 3:
        return state.band3;
      case 4:
        return state.band4;
      case 5:
        return state.band5;
      case 6:
        return state.band6;
      default:
        return 'Black';
    }
  }

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
            'Select Colours',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 16),
          for (int i = 1; i <= state.bandCount; i++) ...[
            _SingleBandSelector(
              isDark: isDark,
              bandIndex: i,
              label: _bandLabel(i),
              selectedColor: _selectedColor(i),
              availableColors: _availableColors(i),
              onChanged: (color) => onBandChanged(i, color),
              isLast: i == state.bandCount,
            ),
            if (i < state.bandCount) const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _SingleBandSelector extends StatelessWidget {
  final bool isDark;
  final int bandIndex;
  final String label;
  final String selectedColor;
  final List<String> availableColors;
  final ValueChanged<String> onChanged;
  final bool isLast;

  const _SingleBandSelector({
    required this.isDark,
    required this.bandIndex,
    required this.label,
    required this.selectedColor,
    required this.availableColors,
    required this.onChanged,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final bandColor = AppColors.resistorColors[selectedColor] ?? Colors.grey;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: bandColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: (isDark ? Colors.white : Colors.black).withOpacity(
                    0.2,
                  ),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: bandColor.withOpacity(0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Band $bandIndex – $label',
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: bandColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                selectedColor,
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: bandColor == const Color(0xFFF5F5F5)
                      ? Colors.grey
                      : bandColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: availableColors.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final color = availableColors[index];
              final c = AppColors.resistorColors[color] ?? Colors.grey;
              final isSelected = color == selectedColor;
              return GestureDetector(
                onTap: () => onChanged(color),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: c,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? Colors.white
                          : Colors.black.withOpacity(0.1),
                      width: isSelected ? 3 : 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: c.withOpacity(0.5),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 16,
                        )
                      : null,
                ),
              );
            },
          ),
        ),
        if (!isLast) ...[
          const SizedBox(height: 14),
          Divider(
            height: 1,
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ],
      ],
    );
  }
}

// ── Results Section ────────────────────────────────────────────────────────────
class _ResistorResults extends StatelessWidget {
  final bool isDark;
  final ResistorResult result;

  const _ResistorResults({required this.isDark, required this.result});

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Result'),
        const SizedBox(height: 12),
        ResultCard(
          label: 'Resistance',
          value: '${_fmtOhm(result.resistanceOhm)} Ω',
          subtitle: 'Ohms',
          icon: Icons.timeline_rounded,
          accentColor: AppColors.secondary,
          onCopy: () => _copy(context, '${result.resistanceOhm} Ω'),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ResultCard(
                label: 'kΩ',
                value: _fmtK(result.resistanceKOhm),
                icon: Icons.compress_rounded,
                accentColor: AppColors.accent,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ResultCard(
                label: 'MΩ',
                value: _fmtM(result.resistanceMOhm),
                icon: Icons.expand_rounded,
                accentColor: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ResultCard(
                label: 'Tolerance',
                value: result.tolerancePercent,
                icon: Icons.rule_rounded,
                accentColor: AppColors.warning,
              ),
            ),
            if (result.tempCoefficient != null) ...[
              const SizedBox(width: 10),
              Expanded(
                child: ResultCard(
                  label: 'Temp. Coeff.',
                  value: result.tempCoefficient!,
                  icon: Icons.thermostat_rounded,
                  accentColor: AppColors.error,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        SectionHeader(title: 'Step-by-Step'),
        const SizedBox(height: 12),
        BreakdownCard(breakdown: result.breakdown),
      ],
    );
  }

  String _fmtOhm(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(2)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(2)}k';
    return v % 1 == 0 ? v.toInt().toString() : v.toStringAsFixed(2);
  }

  String _fmtK(double v) {
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(3)} M';
    return v.toStringAsFixed(3);
  }

  String _fmtM(double v) {
    return v.toStringAsFixed(6);
  }
}

// ── Presets Grid ───────────────────────────────────────────────────────────────
class _PresetsGrid extends StatelessWidget {
  final bool isDark;
  final void Function(List<String> bands) onPresetSelected;

  const _PresetsGrid({required this.isDark, required this.onPresetSelected});

  @override
  Widget build(BuildContext context) {
    final presets = ResistorCalculatorService.commonPresets;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: presets.map((preset) {
        final bands = (preset['bands4'] as List).cast<String>();
        return GestureDetector(
          onTap: () => onPresetSelected(bands),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Mini colour band dots
                for (final c in bands) ...[
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.resistorColors[c] ?? Colors.grey,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black.withOpacity(0.1),
                        width: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 2),
                ],
                const SizedBox(width: 6),
                Text(
                  preset['label'] as String,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
