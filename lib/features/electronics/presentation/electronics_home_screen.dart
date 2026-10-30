import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/electronics_models.dart';
import '../providers/electronics_providers.dart';
import 'widgets/category_card.dart';
import 'widgets/product_card.dart';

class ElectronicsHomeScreen extends ConsumerStatefulWidget {
  const ElectronicsHomeScreen({super.key});

  @override
  ConsumerState<ElectronicsHomeScreen> createState() =>
      _ElectronicsHomeScreenState();
}

class _ElectronicsHomeScreenState extends ConsumerState<ElectronicsHomeScreen> {
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
    final allProductsAsync = ref.watch(allProductsProvider);
    final featuredAsync = ref.watch(featuredProductsProvider);
    final recentlyViewedAsync = ref.watch(recentlyViewedProductsListProvider);

    return Scaffold(
      floatingActionButton: _showBackToTop
          ? FloatingActionButton.small(
              heroTag: 'elec_home_back_to_top',
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
      body: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          // ── App Bar with Search Trigger ───────────────────────
          SliverAppBar(
            expandedHeight: 180,
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
                        ? [const Color(0xFF0D1E3D), const Color(0xFF090E1A)]
                        : [const Color(0xFFE8F1FF), const Color(0xFFF0F4FF)],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 52, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.memory_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Electronics Browser',
                              style: GoogleFonts.outfit(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? AppColors.textPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                            Text(
                              'Hardware, Components & Gadgets Catalog',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
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
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.favorite_rounded,
                  color: Color(0xFFFF4F5A),
                ),
                tooltip: 'Favourites',
                onPressed: () =>
                    context.go(AppConstants.routeElectronicsFavourites),
              ),
              IconButton(
                icon: const Icon(Icons.search_rounded),
                tooltip: 'Search',
                onPressed: () =>
                    context.push(AppConstants.routeElectronicsSearch),
              ),
              const SizedBox(width: 8),
            ],
          ),

          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Interactive Search Box (Tap to search) ──────
                InkWell(
                  onTap: () =>
                      context.push(AppConstants.routeElectronicsSearch),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.25 : 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Search components, models, remotes, ICs...',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'FILTER',
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Remote Finder Special Card ───────────────────
                _RemoteFinderBanner(
                  isDark: isDark,
                  onTap: () {
                    ref.read(searchCategoryFilterProvider.notifier).state =
                        ElectronicsCategory.remoteControls;
                    context.push(AppConstants.routeElectronicsSearch);
                  },
                ),
                const SizedBox(height: 28),

                // ── Featured Products Horizontal Scroll ──────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Featured Components',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    InkWell(
                      onTap: () =>
                          context.push(AppConstants.routeElectronicsSearch),
                      child: Text(
                        'View All',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                featuredAsync.when(
                  data: (featured) {
                    return SizedBox(
                      height: 280,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: featured.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                        itemBuilder: (context, index) {
                          return SizedBox(
                            width: 240,
                            child: ProductCard(
                              product: featured[index],
                              isCompact: true,
                            ),
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const SizedBox(
                    height: 280,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 28),

                // ── Recently Viewed Section (if any) ────────────
                recentlyViewedAsync.when(
                  data: (viewed) {
                    if (viewed.isEmpty) return const SizedBox.shrink();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recently Viewed',
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppColors.textPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                            InkWell(
                              onTap: () => ref
                                  .read(recentlyViewedProvider.notifier)
                                  .clearAll(),
                              child: Text(
                                'Clear',
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          height: 280,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: viewed.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 14),
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: 240,
                                child: ProductCard(
                                  product: viewed[index],
                                  isCompact: true,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 28),
                      ],
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),

                // ── Categories List Header ───────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'All Categories',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        Text(
                          'Explore all 12 electronic hardware departments',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ── 12 Categories List ───────────────────────────
                allProductsAsync.when(
                  data: (products) {
                    return Column(
                      children: ElectronicsCategory.values.map((category) {
                        final count = products
                            .where((p) => p.category == category)
                            .length;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: CategoryCard(
                            category: category,
                            count: count,
                            onTap: () {
                              context.push(
                                '${AppConstants.routeElectronicsCategory}/${category.name}',
                              );
                            },
                          ),
                        );
                      }).toList(),
                    );
                  },
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _RemoteFinderBanner extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTap;

  const _RemoteFinderBanner({required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF003B5C), const Color(0xFF001F33)]
              : [const Color(0xFFD6F0FF), const Color(0xFFE8F6FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.secondary.withOpacity(0.3),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(isDark ? 0.2 : 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: AppColors.cyanGradient,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.settings_remote_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Looking for a Remote?',
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Search TV, AC & Set-Top Box remotes by brand or model number',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryDark,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Find',
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
