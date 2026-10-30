import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';

class CalculatorsScreen extends StatelessWidget {
  const CalculatorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Calculators')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'All Tools',
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 14),
          _CalcCard(
            title: 'Power Calculator',
            description:
                'DC, single-phase AC and three-phase AC power calculation',
            icon: Icons.electric_bolt_rounded,
            gradient: AppColors.primaryGradient,
            features: [
              'DC: P = V × I',
              'AC Single: P = V × I × PF',
              'AC Three: P = √3 × V × I × PF',
            ],
            onTap: () => context.push(AppConstants.routePowerCalculator),
          ),
          const SizedBox(height: 16),
          _CalcCard(
            title: 'Resistor Colour Code',
            description: 'Interactive colour band calculator with 4, 5 and 6 band support',
            icon: Icons.tune_rounded,
            gradient: AppColors.cyanGradient,
            features: [
              '4-band: 2 digits',
              '5-band: 3 digits',
              '6-band: Temp. Coefficient',
            ],
            onTap: () => context.push(AppConstants.routeResistorCalculator),
          ),
          const SizedBox(height: 24),
          Text(
            'Coming Soon',
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 14),
          _ComingSoonCard(
            title: 'Ohm\'s Law Calculator',
            description: 'Calculate voltage, current, resistance and power using Ohm\'s Law',
            icon: Icons.electrical_services_rounded,
          ),
          const SizedBox(height: 10),
          _ComingSoonCard(
            title: 'Capacitor Calculator',
            description:
                'Capacitance, charge, energy and RC time constant calculations',
            icon: Icons.battery_charging_full_rounded,
          ),
          const SizedBox(height: 10),
          _ComingSoonCard(
            title: 'Inductor Calculator',
            description: 'Inductance and RL circuit time constant calculations',
            icon: Icons.radio_button_checked_rounded,
          ),
        ],
      ),
    );
  }
}

class _CalcCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final LinearGradient gradient;
  final List<String> features;
  final VoidCallback onTap;

  const _CalcCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.features,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        description,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: features
                  .map(
                    (f) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: gradient.colors.first.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        f,
                        style: GoogleFonts.sourceCodePro(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: gradient.colors.first,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComingSoonCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const _ComingSoonCard({
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (isDark ? AppColors.darkCard : Colors.white).withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (isDark ? AppColors.darkBorder : AppColors.lightBorder)
              .withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: (isDark ? AppColors.textDisabled : AppColors.lightBorder),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.textDisabled
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Soon',
              style: GoogleFonts.outfit(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
