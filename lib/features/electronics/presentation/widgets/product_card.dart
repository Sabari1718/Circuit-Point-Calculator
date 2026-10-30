import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/electronics_models.dart';
import '../../providers/electronics_providers.dart';
import 'product_image_view.dart';

class ProductCard extends ConsumerWidget {
  final ElectronicsProduct product;
  final bool isCompact;

  const ProductCard({super.key, required this.product, this.isCompact = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final favNotifier = ref.read(favouritesProvider.notifier);
    final favAsync = ref.watch(favouritesProvider);
    final isFav = favAsync.valueOrNull?.contains(product.id) ?? false;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ref.read(recentlyViewedProvider.notifier).addViewed(product.id);
          context.push('${AppConstants.routeProductDetail}/${product.id}');
        },
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
                color: Colors.black.withOpacity(isDark ? 0.35 : 0.05),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: EdgeInsets.all(isCompact ? 10 : 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Product Image / Hardware View ─────────────────
              Stack(
                children: [
                  ProductImageView(
                    product: product,
                    height: isCompact ? 95 : 135,
                    borderRadius: 12,
                    showBadge: false,
                  ),
                  // Heart button overlay
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        color: (isDark ? Colors.black : Colors.white)
                            .withOpacity(0.85),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: IconButton(
                        iconSize: 20,
                        padding: const EdgeInsets.all(6),
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          isFav
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isFav
                              ? const Color(0xFFFF4F5A)
                              : (isDark
                                    ? AppColors.textSecondary
                                    : AppColors.lightTextSecondary),
                        ),
                        onPressed: () {
                          favNotifier.toggleFavourite(product.id);
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: const Duration(milliseconds: 1400),
                              content: Text(
                                isFav
                                    ? 'Removed from favourites'
                                    : 'Saved to favourites',
                                style: GoogleFonts.outfit(fontSize: 13),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Featured badge
                  if (product.isFeatured)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'FEATURED',
                          style: GoogleFonts.outfit(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),

              // ── Category / Subcategory & Brand ────────────────
              Row(
                children: [
                  Text(
                    product.category.iconAsset,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      product.subcategory,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  if (product.brand != null && product.brand!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1.5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        product.brand!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),

              // ── Product Name ──────────────────────────────────
              Text(
                product.name,
                maxLines: isCompact ? 1 : 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                  height: 1.25,
                ),
              ),

              if (!isCompact) ...[
                const SizedBox(height: 4),
                Text(
                  product.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                    height: 1.35,
                  ),
                ),
              ],

              const SizedBox(height: 6),

              // ── Quick Spec Highlights ─────────────────────────
              Builder(
                builder: (context) {
                  final badges = <Widget>[
                    if (product.voltageRange != null)
                      _QuickBadge(
                        label: product.voltageRange!,
                        icon: Icons.bolt_rounded,
                        color: const Color(0xFFFFB020),
                      ),
                    if (product.currentRating != null)
                      _QuickBadge(
                        label: product.currentRating!,
                        icon: Icons.speed_rounded,
                        color: AppColors.secondary,
                      ),
                    if (product.modelNumber != null)
                      _QuickBadge(
                        label: product.modelNumber!,
                        icon: Icons.qr_code_2_rounded,
                        color: AppColors.primaryLight,
                      ),
                  ];

                  if (badges.isEmpty) return const SizedBox.shrink();

                  return Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: isCompact ? badges.take(2).toList() : badges,
                  );
                },
              ),

              SizedBox(height: isCompact ? 6 : 10),

              // ── Action Row: View specs ────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'View specs',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 3),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 14,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _QuickBadge({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.25), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 105),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
