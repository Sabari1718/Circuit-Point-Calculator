import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../domain/electronics_models.dart';
import '../providers/electronics_providers.dart';
import 'widgets/product_card.dart';
import 'widgets/product_image_view.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final show = _scrollController.hasClients && _scrollController.offset > 250;
    if (show != _showBackToTop) {
      setState(() {
        _showBackToTop = show;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final productAsync = ref.watch(productDetailProvider(widget.productId));

    return Scaffold(
      floatingActionButton: _showBackToTop
          ? FloatingActionButton.small(
              heroTag: 'detail_back_to_top',
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              tooltip: 'Scroll to top',
              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                );
              },
              child: const Icon(Icons.keyboard_arrow_up_rounded),
            )
          : null,
      body: productAsync.when(
        data: (product) {
          if (product == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Not Found')),
              body: const Center(child: Text('Product not found')),
            );
          }

          final favAsync = ref.watch(favouritesProvider);
          final isFav = favAsync.valueOrNull?.contains(product.id) ?? false;
          final relatedAsync = ref.watch(
            relatedProductsProvider(product.relatedProductIds),
          );

          return CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // ── Header / Hero Visual ──────────────────────────
              SliverAppBar(
                expandedHeight: 290,
                pinned: true,
                backgroundColor: isDark
                    ? AppColors.darkBackground
                    : AppColors.lightBackground,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkCard.withOpacity(0.8)
                          : Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_rounded, size: 20),
                  ),
                  onPressed: () => context.pop(),
                ),
                actions: [
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkCard.withOpacity(0.8)
                            : Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFav
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: isFav
                            ? const Color(0xFFFF4F5A)
                            : (isDark ? Colors.white : Colors.black87),
                        size: 20,
                      ),
                    ),
                    onPressed: () {
                      ref
                          .read(favouritesProvider.notifier)
                          .toggleFavourite(product.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(milliseconds: 1400),
                          content: Text(
                            isFav
                                ? 'Removed from favourites'
                                : 'Added to favourites',
                            style: GoogleFonts.outfit(),
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkCard.withOpacity(0.8)
                            : Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.share_rounded, size: 20),
                    ),
                    onPressed: () {
                      final shareText =
                          '''
${product.name} (${product.subcategory})
Category: ${product.category.label}
${product.brand != null ? 'Brand: ${product.brand}\n' : ''}${product.modelNumber != null ? 'Model: ${product.modelNumber}\n' : ''}
${product.voltageRange != null ? 'Voltage: ${product.voltageRange}\n' : ''}${product.currentRating != null ? 'Current: ${product.currentRating}\n' : ''}
Description:
${product.description}

Shared via Circuit Point Electronics
''';
                      Clipboard.setData(ClipboardData(text: shareText));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Product specification sheet copied to clipboard!',
                            style: GoogleFonts.outfit(),
                          ),
                          action: SnackBarAction(label: 'OK', onPressed: () {}),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [const Color(0xFF0F2B48), const Color(0xFF090E1A)]
                            : [
                                const Color(0xFFDCEBFF),
                                const Color(0xFFF0F4FF),
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 48),
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkCard : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                    isDark ? 0.35 : 0.08,
                                  ),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: ProductImageView(
                                product: product,
                                height: 124,
                                fit: BoxFit.contain,
                                showBadge: false,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.verified_rounded,
                                      size: 13,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'VERIFIED TECHNICAL DATA',
                                      style: GoogleFonts.outfit(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Product Content ───────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── Category & Brand Row ──────────────────────
                    Row(
                      children: [
                        Text(
                          product.category.label,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '•',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          product.subcategory,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                        const Spacer(),
                        if (product.brand != null && product.brand!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              product.brand!,
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // ── Product Title ─────────────────────────────
                    Text(
                      product.name,
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),

                    if (product.modelNumber != null &&
                        product.modelNumber!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.tag_rounded,
                            size: 16,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Model: ${product.modelNumber}',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 20),

                    // ── Quick Spec Highlights Grid ────────────────
                    _QuickHighlightsGrid(product: product, isDark: isDark),
                    const SizedBox(height: 24),

                    // ── Description ───────────────────────────────
                    _SectionCard(
                      title: 'Description',
                      icon: Icons.info_outline_rounded,
                      isDark: isDark,
                      child: Text(
                        product.description,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                          height: 1.55,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // ── Working Principle ─────────────────────────
                    if (product.workingPrinciple.isNotEmpty) ...[
                      _SectionCard(
                        title: 'Working Principle',
                        icon: Icons.science_outlined,
                        isDark: isDark,
                        child: Text(
                          product.workingPrinciple,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: isDark
                                ? AppColors.textSecondary
                                : AppColors.lightTextSecondary,
                            height: 1.55,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],

                    // ── Pin Configuration (if applicable) ─────────
                    if (product.pinConfiguration != null &&
                        product.pinConfiguration!.isNotEmpty) ...[
                      _SectionCard(
                        title: 'Pin Configuration',
                        icon: Icons.cable_rounded,
                        isDark: isDark,
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkBackground
                                : const Color(0xFFF0F5FF),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.settings_input_component_rounded,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  product.pinConfiguration!,
                                  style: GoogleFonts.outfit(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w500,
                                    color: isDark
                                        ? AppColors.textPrimary
                                        : AppColors.lightTextPrimary,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],

                    // ── Full Technical Specifications Table ───────
                    if (product.specifications.isNotEmpty) ...[
                      _SectionCard(
                        title: 'Technical Specifications',
                        icon: Icons.fact_check_outlined,
                        isDark: isDark,
                        child: Column(
                          children: product.specifications.asMap().entries.map((
                            entry,
                          ) {
                            final i = entry.key;
                            final spec = entry.value;
                            final isEven = i % 2 == 0;
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isEven
                                    ? (isDark
                                          ? AppColors.darkBackground
                                                .withOpacity(0.6)
                                          : const Color(0xFFF7FAFF))
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      spec.label,
                                      style: GoogleFonts.outfit(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? AppColors.textSecondary
                                            : AppColors.lightTextSecondary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    flex: 6,
                                    child: Text(
                                      spec.value,
                                      style: GoogleFonts.outfit(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: isDark
                                            ? AppColors.textPrimary
                                            : AppColors.lightTextPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],

                    // ── Applications ──────────────────────────────
                    if (product.applications.isNotEmpty) ...[
                      _SectionCard(
                        title: 'Common Applications',
                        icon: Icons.checklist_rounded,
                        isDark: isDark,
                        child: Column(
                          children: product.applications.map((app) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.check_circle_outline_rounded,
                                    size: 16,
                                    color: Color(0xFF00C896),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      app,
                                      style: GoogleFonts.outfit(
                                        fontSize: 13.5,
                                        color: isDark
                                            ? AppColors.textSecondary
                                            : AppColors.lightTextSecondary,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],

                    // ── Advantages ────────────────────────────────
                    if (product.advantages.isNotEmpty) ...[
                      _SectionCard(
                        title: 'Key Advantages',
                        icon: Icons.thumb_up_alt_outlined,
                        isDark: isDark,
                        child: Column(
                          children: product.advantages.map((adv) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.star_border_rounded,
                                    size: 16,
                                    color: Color(0xFFFFB020),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      adv,
                                      style: GoogleFonts.outfit(
                                        fontSize: 13.5,
                                        color: isDark
                                            ? AppColors.textSecondary
                                            : AppColors.lightTextSecondary,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],

                    // ── Compatible Models (for remotes / laptop) ──
                    if (product.compatibleModels.isNotEmpty) ...[
                      _SectionCard(
                        title: 'Verified Compatible Models',
                        icon: Icons.devices_other_rounded,
                        isDark: isDark,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: product.compatibleModels.map((m) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.darkBackground
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.secondary.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                m,
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.secondary,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],

                    // ── Related Components Section ────────────────
                    relatedAsync.when(
                      data: (related) {
                        if (related.isEmpty) return const SizedBox.shrink();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Related Components',
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppColors.textPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Column(
                              children: related.map((r) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: ProductCard(product: r),
                                );
                              }).toList(),
                            ),
                          ],
                        );
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 80),
                  ]),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error loading product: $err')),
      ),
    );
  }
}

class _QuickHighlightsGrid extends StatelessWidget {
  final ElectronicsProduct product;
  final bool isDark;

  const _QuickHighlightsGrid({required this.product, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final highlights = <_HighlightItem>[];

    if (product.voltageRange != null) {
      highlights.add(
        _HighlightItem(
          label: 'Voltage',
          value: product.voltageRange!,
          icon: Icons.bolt_rounded,
          color: const Color(0xFFFFB020),
        ),
      );
    }

    if (product.currentRating != null) {
      highlights.add(
        _HighlightItem(
          label: 'Current',
          value: product.currentRating!,
          icon: Icons.speed_rounded,
          color: AppColors.secondary,
        ),
      );
    }

    if (product.powerRating != null) {
      highlights.add(
        _HighlightItem(
          label: 'Power',
          value: product.powerRating!,
          icon: Icons.electric_meter_rounded,
          color: const Color(0xFF00C896),
        ),
      );
    }

    if (product.remoteType != null) {
      highlights.add(
        _HighlightItem(
          label: 'Connectivity',
          value: product.remoteType!,
          icon: Icons.sensors_rounded,
          color: AppColors.primary,
        ),
      );
    }

    if (product.batteryType != null) {
      highlights.add(
        _HighlightItem(
          label: 'Battery',
          value: product.batteryType!,
          icon: Icons.battery_charging_full_rounded,
          color: const Color(0xFF9400D3),
        ),
      );
    }

    if (highlights.isEmpty) return const SizedBox.shrink();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: highlights.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final item = highlights[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: item.color.withOpacity(0.3), width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, size: 20, color: item.color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.label,
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                    Text(
                      item.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HighlightItem {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _HighlightItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final bool isDark;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1.2,
        ),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
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
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
