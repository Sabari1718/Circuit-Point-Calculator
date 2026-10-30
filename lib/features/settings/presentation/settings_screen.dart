import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeAsync = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        children: [
          // ── Appearance Section ─────────────────────────────
          _SectionTitle(title: 'Appearance', isDark: isDark),
          const SizedBox(height: 12),
          _SettingsCard(
            isDark: isDark,
            children: [
              themeAsync.when(
                data: (mode) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SettingRow(
                      isDark: isDark,
                      icon: Icons.brightness_auto_rounded,
                      title: 'Theme',
                      subtitle: 'Choose your preferred appearance',
                    ),
                    const SizedBox(height: 12),
                    _ThemeSelectorRow(
                      current: mode,
                      isDark: isDark,
                      onChanged: notifier.setThemeMode,
                    ),
                  ],
                ),
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── About Section ──────────────────────────────────
          _SectionTitle(title: 'About', isDark: isDark),
          const SizedBox(height: 12),
          _SettingsCard(
            isDark: isDark,
            children: [
              _SettingRow(
                isDark: isDark,
                icon: Icons.bolt_rounded,
                title: AppConstants.appName,
                subtitle: AppConstants.appTagline,
                trailing: Text(
                  'v${AppConstants.appVersion}',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ),
              _Divider(isDark: isDark),
              _SettingRow(
                isDark: isDark,
                icon: Icons.info_outline_rounded,
                title: 'Version',
                subtitle: 'Build ${AppConstants.appBuildNumber}',
                trailing: Text(
                  AppConstants.appVersion,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              _Divider(isDark: isDark),
              _SettingRow(
                isDark: isDark,
                icon: Icons.shield_outlined,
                title: 'Privacy',
                subtitle: 'All data is stored locally on your device',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Local only',
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ),
              ),
              _Divider(isDark: isDark),
              _SettingRow(
                isDark: isDark,
                icon: Icons.code_rounded,
                title: 'Technology',
                subtitle: 'Built with Flutter & Riverpod',
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Formulas Section ───────────────────────────────
          _SectionTitle(title: 'Supported Calculators', isDark: isDark),
          const SizedBox(height: 12),
          _SettingsCard(
            isDark: isDark,
            children: [
              _SettingRow(
                isDark: isDark,
                icon: Icons.electric_bolt_rounded,
                title: 'Power Calculator',
                subtitle: 'DC, AC Single-phase, AC Three-phase',
              ),
              _Divider(isDark: isDark),
              _SettingRow(
                isDark: isDark,
                icon: Icons.tune_rounded,
                title: 'Resistor Colour Code',
                subtitle: '4-band, 5-band and 6-band (IEC 60062)',
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Legal / Credits ────────────────────────────────
          Center(
            child: Column(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 54,
                      height: 54,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.bolt_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  AppConstants.appName,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                Text(
                  AppConstants.appTagline,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '© 2026 Circuit Point. All rights reserved.',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.textDisabled
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final bool isDark;

  const _SectionTitle({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        color: AppColors.primary,
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final bool isDark;
  final List<Widget> children;

  const _SettingsCard({required this.isDark, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: children,
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;

  const _SettingRow({
    required this.isDark,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
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
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              Text(
                subtitle,
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
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  final bool isDark;
  const _Divider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(
        height: 1,
        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
      ),
    );
  }
}

class _ThemeSelectorRow extends StatelessWidget {
  final ThemeMode current;
  final bool isDark;
  final ValueChanged<ThemeMode> onChanged;

  const _ThemeSelectorRow({
    required this.current,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ThemeOption(
          mode: ThemeMode.light,
          label: 'Light',
          icon: Icons.light_mode_rounded,
          isSelected: current == ThemeMode.light,
          isDark: isDark,
          onTap: () => onChanged(ThemeMode.light),
        ),
        const SizedBox(width: 8),
        _ThemeOption(
          mode: ThemeMode.dark,
          label: 'Dark',
          icon: Icons.dark_mode_rounded,
          isSelected: current == ThemeMode.dark,
          isDark: isDark,
          onTap: () => onChanged(ThemeMode.dark),
        ),
        const SizedBox(width: 8),
        _ThemeOption(
          mode: ThemeMode.system,
          label: 'System',
          icon: Icons.brightness_auto_rounded,
          isSelected: current == ThemeMode.system,
          isDark: isDark,
          onTap: () => onChanged(ThemeMode.system),
        ),
      ],
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final ThemeMode mode;
  final String label;
  final IconData icon;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.mode,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : (isDark
                      ? AppColors.darkCardElevated
                      : AppColors.lightBackground),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : (isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
