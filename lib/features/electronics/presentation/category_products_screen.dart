import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/electronics_models.dart';
import '../providers/electronics_providers.dart';
import 'widgets/product_card.dart';

class CategoryProductsScreen extends ConsumerStatefulWidget {
  final String categoryName;

  const CategoryProductsScreen({super.key, required this.categoryName});

  @override
  ConsumerState<CategoryProductsScreen> createState() =>
      _CategoryProductsScreenState();
}

class _CategoryProductsScreenState
    extends ConsumerState<CategoryProductsScreen> {
  String _selectedSubcategory = 'All';
  String _selectedBrand = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTop = false;

  late final ElectronicsCategory _category;

  static ElectronicsCategory _resolveCategory(String name) {
    final clean = name.trim().toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9]'),
      '',
    );
    for (final c in ElectronicsCategory.values) {
      if (c.name.toLowerCase() == clean) return c;
      final cClean = c.label.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
      if (cClean == clean) return c;
    }
    for (final c in ElectronicsCategory.values) {
      if (c.name.toLowerCase() == name.trim().toLowerCase() ||
          c.label.toLowerCase() == name.trim().toLowerCase()) {
        return c;
      }
    }
    return ElectronicsCategory.electronicComponents;
  }

  @override
  void initState() {
    super.initState();
    _category = _resolveCategory(widget.categoryName);
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
    _searchController.disposeWidget();
    _modelController.disposeWidget();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final productsAsync = ref.watch(categoryProductsProvider(_category));
    final brandsAsync = ref.watch(categoryBrandsProvider(_category));
    final subcategoriesAsync = ref.watch(
      categorySubcategoriesProvider(_category),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_category.label),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              ref.read(searchCategoryFilterProvider.notifier).state = _category;
              context.push(AppConstants.routeElectronicsSearch);
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite_rounded, color: Color(0xFFFF4F5A)),
            onPressed: () =>
                context.go(AppConstants.routeElectronicsFavourites),
          ),
        ],
      ),
      floatingActionButton: _showBackToTop
          ? FloatingActionButton.small(
              heroTag: 'cat_back_to_top',
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
      body: productsAsync.when(
        data: (allProducts) {
          // Dynamic available brands
          final availableBrands = brandsAsync.valueOrNull ?? [];
          // Dynamic available subcategories
          final availableSubcategories = subcategoriesAsync.valueOrNull ?? [];

          // Filtering
          var filtered = allProducts;

          if (_selectedSubcategory != 'All') {
            filtered = filtered
                .where((p) => p.subcategory == _selectedSubcategory)
                .toList();
          }

          if (_selectedBrand != 'All') {
            final bLower = _selectedBrand.toLowerCase();
            filtered = filtered.where((p) {
              final directMatch = p.brand?.toLowerCase() == bLower;
              final laptopMatch = p.laptopBrands.any(
                (b) => b.toLowerCase() == bLower,
              );
              return directMatch || laptopMatch;
            }).toList();
          }

          if (_searchQuery.trim().isNotEmpty) {
            final q = _searchQuery.trim().toLowerCase();
            filtered = filtered.where((p) => p.matchesSearch(q)).toList();
          }

          return CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // ── Header Banner ─────────────────────────────────
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [const Color(0xFF142442), const Color(0xFF0F1A2E)]
                          : [const Color(0xFFEAF1FF), const Color(0xFFF0F5FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.25),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _category.iconAsset,
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _category.label,
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? AppColors.textPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _category.description,
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
                    ],
                  ),
                ),
              ),

              // ── In-Category Search Bar ────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Filter ${_category.label}...',
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ),

              // ── Special Remote Model Number Search ────────────
              if (_category == ElectronicsCategory.remoteControls)
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.secondary.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.tv_rounded,
                              size: 18,
                              color: AppColors.secondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'TV / AC Model Compatibility Finder',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _modelController,
                          onChanged: (val) {
                            setState(() {
                              _searchQuery = val;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'e.g. QN90B, OLED-C3, AR18CY3, FTKM50...',
                            prefixIcon: const Icon(
                              Icons.qr_code_rounded,
                              size: 18,
                              color: AppColors.secondary,
                            ),
                            suffixIcon: _modelController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 16),
                                    onPressed: () {
                                      _modelController.clear();
                                      setState(() {
                                        _searchQuery = '';
                                      });
                                    },
                                  )
                                : null,
                            fillColor: isDark
                                ? AppColors.darkBackground
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // ── Subcategories Horizontal Pills ────────────────
              if (availableSubcategories.isNotEmpty)
                SliverToBoxAdapter(
                  child: Container(
                    height: 42,
                    margin: const EdgeInsets.only(top: 14, bottom: 6),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          _FilterChip(
                            label: 'All Items (${allProducts.length})',
                            isSelected: _selectedSubcategory == 'All',
                            onTap: () =>
                                setState(() => _selectedSubcategory = 'All'),
                          ),
                          ...availableSubcategories.map((subcat) {
                            final count = allProducts
                                .where((p) => p.subcategory == subcat)
                                .length;
                            return _FilterChip(
                              label: '$subcat ($count)',
                              isSelected: _selectedSubcategory == subcat,
                              onTap: () =>
                                  setState(() => _selectedSubcategory = subcat),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),

              // ── Brand Filters Horizontal Pills ────────────────
              if (availableBrands.isNotEmpty)
                SliverToBoxAdapter(
                  child: Container(
                    height: 38,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          _FilterChip(
                            label: 'All Brands',
                            isSelected: _selectedBrand == 'All',
                            isSmall: true,
                            onTap: () => setState(() => _selectedBrand = 'All'),
                          ),
                          ...availableBrands.map((brand) {
                            return _FilterChip(
                              label: brand,
                              isSelected: _selectedBrand == brand,
                              isSmall: true,
                              onTap: () =>
                                  setState(() => _selectedBrand = brand),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),

              // ── Count & Active Filter Indicator ───────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Showing ${filtered.length} products',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                      if (_selectedSubcategory != 'All' ||
                          _selectedBrand != 'All' ||
                          _searchQuery.isNotEmpty)
                        InkWell(
                          onTap: () {
                            _searchController.clear();
                            _modelController.clear();
                            setState(() {
                              _selectedSubcategory = 'All';
                              _selectedBrand = 'All';
                              _searchQuery = '';
                            });
                          },
                          child: Text(
                            'Reset filters',
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

              // ── Products List / Grid ──────────────────────────
              if (filtered.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 64,
                            color: AppColors.textMuted.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No matching components found',
                            style: GoogleFonts.outfit(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.textPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your filters or search keywords.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              _searchController.clear();
                              _modelController.clear();
                              setState(() {
                                _selectedSubcategory = 'All';
                                _selectedBrand = 'All';
                                _searchQuery = '';
                              });
                            },
                            child: const Text('Reset All Filters'),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: ProductCard(product: filtered[index]),
                      );
                    }, childCount: filtered.length),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error loading products: $err')),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isSmall;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: isSmall ? 10 : 14,
            vertical: isSmall ? 5 : 8,
          ),
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
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: isSmall ? 11.5 : 12.5,
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

extension on TextEditingController {
  void disposeWidget() {
    dispose();
  }
}
