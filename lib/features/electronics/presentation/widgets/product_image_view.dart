import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/electronics_models.dart';

class ProductImageView extends StatelessWidget {
  final ElectronicsProduct product;
  final double width;
  final double height;
  final double borderRadius;
  final bool showBadge;
  final BoxFit fit;

  const ProductImageView({
    super.key,
    required this.product,
    this.width = double.infinity,
    this.height = 130,
    this.borderRadius = 14,
    this.showBadge = true,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasAsset =
        product.imageAsset != null && product.imageAsset!.isNotEmpty;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background subtle pattern/gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.9,
                  colors: [
                    AppColors.primary.withOpacity(isDark ? 0.08 : 0.04),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main image or fallback hardware badge
          if (hasAsset)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                product.imageAsset!,
                fit: fit,
                width: width,
                height: height,
                errorBuilder: (context, error, stackTrace) =>
                    _buildHardwareFallback(isDark),
              ),
            )
          else
            _buildHardwareFallback(isDark),

          // Subcategory chip overlay (optional)
          if (showBadge)
            Positioned(
              bottom: 6,
              left: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: (isDark ? Colors.black : Colors.white).withOpacity(
                    0.85,
                  ),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product.category.iconAsset,
                      style: const TextStyle(fontSize: 10),
                    ),
                    const SizedBox(width: 4),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 100),
                      child: Text(
                        product.subcategory,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHardwareFallback(bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.25),
                AppColors.secondary.withOpacity(0.18),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.primary.withOpacity(0.35)),
          ),
          alignment: Alignment.center,
          child: Text(
            product.category.iconAsset,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
        ),
      ],
    );
  }
}
