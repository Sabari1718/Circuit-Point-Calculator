import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../../history/domain/calculation_record.dart';
import '../../history/providers/history_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final historyAsync = ref.watch(historyProvider);

    return Scaffold(
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          // ── App Bar ──────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: isDark
                ? AppColors.darkBackground
                : AppColors.lightBackground,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [const Color(0xFF0D1728), const Color(0xFF090E1A)]
                        : [const Color(0xFFEEF4FF), const Color(0xFFF0F4FF)],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.35),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/images/logo.png',
                                width: 44,
                                height: 44,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  decoration: BoxDecoration(
                                    gradient: AppColors.primaryGradient,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.bolt_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppConstants.appName,
                                style: GoogleFonts.outfit(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: isDark
                                      ? AppColors.textPrimary
                                      : AppColors.lightTextPrimary,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              Text(
                                AppConstants.appTagline,
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  color: isDark
                                      ? AppColors.textMuted
                                      : AppColors.lightTextMuted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              collapseMode: CollapseMode.pin,
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Welcome Section ──────────────────────────
                _WelcomeCard(isDark: isDark),
                const SizedBox(height: 28),

                // ── Feature Cards ────────────────────────────
                const SectionHeader(title: 'Calculators'),
                const SizedBox(height: 14),
                _FeatureCard(
                  title: 'Power Calculator',
                  subtitle: 'DC & AC electrical power',
                  description: 'Calculate real power for DC, single-phase and three-phase AC circuits',
                  icon: Icons.electric_bolt_rounded,
                  gradient: AppColors.primaryGradient,
                  onTap: () => context.push(AppConstants.routePowerCalculator),
                  tag: 'P = V × I',
                ),
                const SizedBox(height: 14),
                _FeatureCard(
                  title: 'Resistor Colour Code',
                  subtitle: '4, 5 & 6 band resistors',
                  description: 'Decode resistor values with interactive colour band selection',
                  icon: Icons.tune_rounded,
                  gradient: AppColors.cyanGradient,
                  onTap: () =>
                      context.push(AppConstants.routeResistorCalculator),
                  tag: 'IEC 60062',
                ),
                const SizedBox(height: 28),

                // ── Electronics Catalog ───────────────────────
                SectionHeader(
                  title: 'Electronics & Gadgets',
                  action: 'Browse All',
                  onAction: () => context.go(AppConstants.routeElectronics),
                ),
                const SizedBox(height: 14),
                _FeatureCard(
                  title: 'Electronics Browser',
                  subtitle: '12 Hardware Categories',
                  description: 'Browse electronic components, computer & laptop hardware, remotes, gadgets and verified datasheets',
                  icon: Icons.memory_rounded,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2979FF), Color(0xFF00E5FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  onTap: () => context.go(AppConstants.routeElectronics),
                  tag: 'CATALOG',
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 38,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _CategoryShortcutChip(
                        icon: '⚡',
                        label: 'Components',
                        onTap: () => context.push(
                          '${AppConstants.routeElectronicsCategory}/electronicComponents',
                        ),
                      ),
                      _CategoryShortcutChip(
                        icon: '🖥️',
                        label: 'Computer',
                        onTap: () => context.push(
                          '${AppConstants.routeElectronicsCategory}/computerComponents',
                        ),
                      ),
                      _CategoryShortcutChip(
                        icon: '💻',
                        label: 'Laptop',
                        onTap: () => context.push(
                          '${AppConstants.routeElectronicsCategory}/laptopComponents',
                        ),
                      ),
                      _CategoryShortcutChip(
                        icon: '📱',
                        label: 'Remotes',
                        onTap: () => context.push(
                          '${AppConstants.routeElectronicsCategory}/remoteControls',
                        ),
                      ),
                      _CategoryShortcutChip(
                        icon: '🔌',
                        label: 'Accessories',
                        onTap: () => context.push(
                          '${AppConstants.routeElectronicsCategory}/mobileAccessories',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // ── Recent History ───────────────────────────
                SectionHeader(
                  title: 'Recent Calculations',
                  action: 'View All',
                  onAction: () => context.go(AppConstants.routeHistory),
                ),
                const SizedBox(height: 14),
                historyAsync.when(
                  data: (history) {
                    if (history.isEmpty) {
                      return _EmptyHistory(isDark: isDark);
                    }
                    final recent = history.take(3).toList();
                    return Column(
                      children: recent
                          .map(
                            (r) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _HistoryTile(record: r, isDark: isDark),
                            ),
                          )
                          .toList(),
                    );
                  },
                  loading: () => const SizedBox(
                    height: 80,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 28),

                // ── Formula Reference ────────────────────────
                const SectionHeader(title: 'Formula Reference'),
                const SizedBox(height: 14),
                const _FormulaReference(),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  final bool isDark;
  const _WelcomeCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF0D1E3D), const Color(0xFF111827)]
              : [const Color(0xFFEEF4FF), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to Circuit Point',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Your professional electrical engineering companion. Calculate power, decode resistor values and more.',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.engineering_rounded,
              color: AppColors.primary,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onTap;
  final String tag;

  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.onTap,
    required this.tag,
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: gradient.colors.first.withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
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
                    subtitle,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                  const SizedBox(height: 6),
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
            const SizedBox(width: 8),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: gradient.colors.first.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tag,
                    style: GoogleFonts.sourceCodePro(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: gradient.colors.first,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  final bool isDark;
  const _EmptyHistory({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.history_rounded,
            size: 36,
            color: isDark ? AppColors.textDisabled : AppColors.lightTextMuted,
          ),
          const SizedBox(height: 8),
          Text(
            'No calculations yet',
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final CalculationRecord record;
  final bool isDark;
  const _HistoryTile({required this.record, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isPower = record.isPower;
    final color = isPower ? AppColors.primary : AppColors.secondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isPower ? Icons.electric_bolt_rounded : Icons.tune_rounded,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.title,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                Text(
                  '${record.result} ${record.unit}',
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
          Text(
            _formatTime(record.timestamp),
            style: GoogleFonts.outfit(
              fontSize: 11,
              color: isDark ? AppColors.textDisabled : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _FormulaReference extends StatelessWidget {
  const _FormulaReference();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        FormulaCard(
          title: 'DC Power',
          formula: 'P = V × I',
          description: 'Power equals Voltage multiplied by Current',
        ),
        SizedBox(height: 10),
        FormulaCard(
          title: 'AC Single-Phase Real Power',
          formula: 'P = V × I × PF',
          description: 'Includes Power Factor (PF) for AC circuits',
        ),
        SizedBox(height: 10),
        FormulaCard(
          title: 'AC Three-Phase Real Power',
          formula: 'P = √3 × V × I × PF',
          description: 'Three-phase power with line voltage and current',
        ),
        SizedBox(height: 10),
        FormulaCard(
          title: 'Resistor (4-band)',
          formula: 'R = (d1×10 + d2) × multiplier',
          description: 'IEC 60062 standard colour band coding',
        ),
      ],
    );
  }
}

class _CategoryShortcutChip extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _CategoryShortcutChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
              Text(icon, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text(
                label,
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
      ),
    );
  }
}
