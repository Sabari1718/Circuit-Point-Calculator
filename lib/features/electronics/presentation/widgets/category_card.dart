import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/electronics_models.dart';

class CategoryCard extends StatelessWidget {
  final ElectronicsCategory category;
  final int count;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // ── Category Icon Badge ───
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.2),
                      AppColors.secondary.withOpacity(0.12),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  category.iconAsset,
                  style: const TextStyle(fontSize: 26),
                ),
              ),
              const SizedBox(width: 16),

              // ── Details ───────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            category.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.textPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$count items',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
