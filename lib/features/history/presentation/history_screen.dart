import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/history_provider.dart';
import '../domain/calculation_record.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);
    final notifier = ref.read(historyProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          historyAsync.maybeWhen(
            data: (h) => h.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.delete_sweep_rounded),
                    tooltip: 'Clear all',
                    onPressed: () => _confirmClearAll(context, notifier),
                  )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: historyAsync.when(
        data: (history) {
          if (history.isEmpty) {
            return _EmptyState(isDark: isDark);
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            itemCount: history.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final record = history[index];
              return _HistoryCard(
                record: record,
                isDark: isDark,
                onDelete: () => notifier.deleteRecord(record.id),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            'Error loading history: $e',
            style: GoogleFonts.outfit(color: AppColors.error),
          ),
        ),
      ),
    );
  }

  void _confirmClearAll(BuildContext context, HistoryNotifier notifier) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All History'),
        content: const Text(
          'This will permanently delete all calculation history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              notifier.clearAll();
              Navigator.pop(ctx);
            },
            child: const Text(
              'Clear All',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_rounded,
            size: 64,
            color: isDark ? AppColors.textDisabled : AppColors.lightBorder,
          ),
          const SizedBox(height: 16),
          Text(
            'No calculations yet',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your calculation history will appear here',
            style: GoogleFonts.outfit(
              fontSize: 13,
              color: isDark ? AppColors.textDisabled : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final CalculationRecord record;
  final bool isDark;
  final VoidCallback onDelete;

  const _HistoryCard({
    required this.record,
    required this.isDark,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isPower = record.type == CalculationType.power;
    final color = isPower ? AppColors.primary : AppColors.secondary;
    final icon = isPower ? Icons.electric_bolt_rounded : Icons.tune_rounded;
    final dateStr = DateFormat('MMM d, yyyy – h:mm a').format(record.timestamp);

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
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.title,
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      dateStr,
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded, size: 20),
                color: AppColors.error.withOpacity(0.7),
                tooltip: 'Delete',
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Inputs
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: record.inputs.entries
                .map(
                  (e) =>
                      _InputChip(label: e.key, value: e.value, isDark: isDark),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          Divider(
            height: 1,
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.functions_rounded,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Result:',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${record.result} ${record.unit}',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InputChip extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _InputChip({
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardElevated : const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: GoogleFonts.outfit(
                fontSize: 11,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
            TextSpan(
              text: value,
              style: GoogleFonts.outfit(
                fontSize: 11,
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
  }
}
