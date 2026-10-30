import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';

/// Premium styled input field for calculators
class CalculatorInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? suffix;
  final String? errorText;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final IconData? prefixIcon;
  final bool enabled;

  const CalculatorInputField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.suffix,
    this.errorText,
    this.keyboardType = const TextInputType.numberWithOptions(decimal: true),
    this.onChanged,
    this.prefixIcon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          enabled: enabled,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            errorText: errorText,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 20, color: AppColors.primary)
                : null,
            suffixText: suffix,
            suffixStyle: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Premium result display card
class ResultCard extends StatelessWidget {
  final String label;
  final String value;
  final String? subtitle;
  final Color? accentColor;
  final IconData? icon;
  final VoidCallback? onCopy;

  const ResultCard({
    super.key,
    required this.label,
    required this.value,
    this.subtitle,
    this.accentColor,
    this.icon,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = accentColor ?? AppColors.primary;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
              ],
            ),
          ),
          if (onCopy != null)
            IconButton(
              onPressed: onCopy,
              icon: const Icon(Icons.copy_rounded, size: 18),
              tooltip: 'Copy',
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
        ],
      ),
    );
  }
}

/// Formula reference card
class FormulaCard extends StatelessWidget {
  final String title;
  final String formula;
  final String? description;

  const FormulaCard({
    super.key,
    required this.title,
    required this.formula,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryContainer : const Color(0xFFEEF4FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            formula,
            style: GoogleFonts.sourceCodePro(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          if (description != null) ...[
            const SizedBox(height: 4),
            Text(
              description!,
              style: GoogleFonts.outfit(
                fontSize: 12,
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Section header widget
class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: onAction,
            child: Text(
              action!,
              style: GoogleFonts.outfit(
                fontSize: 13,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

/// Primary gradient button
class GradientButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isFullWidth;

  const GradientButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: onPressed != null
              ? AppColors.primaryGradient
              : const LinearGradient(colors: [Colors.grey, Colors.grey]),
          borderRadius: BorderRadius.circular(12),
          boxShadow: onPressed != null
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: icon != null ? Icon(icon, size: 20) : const SizedBox.shrink(),
          label: Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

/// Breakdown / step-by-step display card
class BreakdownCard extends StatelessWidget {
  final String breakdown;

  const BreakdownCard({super.key, required this.breakdown});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Text(
        breakdown,
        style: GoogleFonts.sourceCodePro(
          fontSize: 12.5,
          height: 1.7,
          color: isDark
              ? AppColors.textSecondary
              : AppColors.lightTextSecondary,
        ),
      ),
    );
  }
}
