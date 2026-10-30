import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/electronics_models.dart';
import '../providers/electronics_providers.dart';
import 'widgets/product_card.dart';

class FavouritesScreen extends ConsumerStatefulWidget {
  const FavouritesScreen({super.key});

  @override
  ConsumerState<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends ConsumerState<FavouritesScreen> {
  ElectronicsCategory? _selectedCategory;
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
    final favListAsync = ref.watch(favouriteProductsListProvider);

    return Scaffold(
      floatingActionButton: _showBackToTop
          ? FloatingActionButton.small(
              heroTag: 'fav_back_to_top',
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
      appBar: AppBar(
        title: const Text('Saved Favourites'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => context.push(AppConstants.routeElectronicsSearch),
          ),
        ],
      ),
      body: favListAsync.when(
        data: (favProducts) {
          if (favProducts.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF4F5A).withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        size: 48,
                        color: Color(0xFFFF4F5A),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'No favourites saved yet',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Bookmark electronic components, hardware and remotes for quick access and reference.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        color: AppColors.textMuted,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.explore_rounded, size: 18),
                      label: const Text('Browse Electronics'),
                      onPressed: () =>
                          context.go(AppConstants.routeElectronics),
                    ),
                  ],
                ),
              ),
            );
          }

          // Category filter pills
          final availableCategories = favProducts
              .map((p) => p.category)
              .toSet()
              .toList();

          var displayed = favProducts;
          if (_selectedCategory != null) {
            displayed = displayed
                .where((p) => p.category == _selectedCategory)
                .toList();
          }

          return CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // ── Header Summary ────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${favProducts.length} Saved Item${favProducts.length == 1 ? '' : 's'}',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                      if (_selectedCategory != null)
                        InkWell(
                          onTap: () => setState(() => _selectedCategory = null),
                          child: Text(
                            'Show all',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // ── Category Filter Pills ──────────────────────────
              if (availableCategories.length > 1)
                SliverToBoxAdapter(
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          _FavCategoryPill(
                            label: 'All (${favProducts.length})',
                            isSelected: _selectedCategory == null,
                            onTap: () =>
                                setState(() => _selectedCategory = null),
                          ),
                          ...availableCategories.map((cat) {
                            final count = favProducts
                                .where((p) => p.category == cat)
                                .length;
                            return _FavCategoryPill(
                              label: '${cat.iconAsset} ${cat.label} ($count)',
                              isSelected: _selectedCategory == cat,
                              onTap: () =>
                                  setState(() => _selectedCategory = cat),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),

              // ── Favourites List ────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: ProductCard(product: displayed[index]),
                    );
                  }, childCount: displayed.length),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _FavCategoryPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FavCategoryPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColors.primaryGradient : null,
            color: isSelected
                ? null
                : (Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkCard
                      : Colors.white),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : (Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : (Theme.of(context).brightness == Brightness.dark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary),
            ),
          ),
        ),
      ),
    );
  }
}
