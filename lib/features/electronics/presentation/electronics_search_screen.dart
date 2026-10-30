import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../domain/electronics_models.dart';
import '../providers/electronics_providers.dart';
import 'widgets/product_card.dart';

class ElectronicsSearchScreen extends ConsumerStatefulWidget {
  const ElectronicsSearchScreen({super.key});

  @override
  ConsumerState<ElectronicsSearchScreen> createState() =>
      _ElectronicsSearchScreenState();
}

class _ElectronicsSearchScreenState
    extends ConsumerState<ElectronicsSearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = ref.read(searchQueryProvider);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    ref.read(searchQueryProvider.notifier).state = query;
    if (query.trim().isNotEmpty) {
      ref.read(recentSearchesProvider.notifier).addSearch(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final searchResultsAsync = ref.watch(searchResultsProvider);
    final selectedCategory = ref.watch(searchCategoryFilterProvider);
    final selectedBrand = ref.watch(searchBrandFilterProvider);
    final selectedSort = ref.watch(searchSortProvider);
    final recentSearchesAsync = ref.watch(recentSearchesProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: _controller.text.isEmpty,
          onChanged: (val) {
            ref.read(searchQueryProvider.notifier).state = val;
          },
          onSubmitted: _onSearch,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'Search components, models, remotes, ICs...',
            hintStyle: GoogleFonts.outfit(
              fontSize: 14,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            fillColor: Colors.transparent,
            prefixIcon: const Icon(
              Icons.search_rounded,
              size: 22,
              color: AppColors.primary,
            ),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 20),
                    onPressed: () {
                      _controller.clear();
                      ref.read(searchQueryProvider.notifier).state = '';
                    },
                  )
                : null,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Sort & Filter',
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Category Filter Pills ──────────────────────────
          Container(
            height: 42,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _SearchFilterPill(
                    label: 'All Categories',
                    isSelected: selectedCategory == null,
                    onTap: () {
                      ref.read(searchCategoryFilterProvider.notifier).state =
                          null;
                    },
                  ),
                  ...ElectronicsCategory.values.map((cat) {
                    return _SearchFilterPill(
                      label: '${cat.iconAsset} ${cat.label}',
                      isSelected: selectedCategory == cat,
                      onTap: () {
                        ref.read(searchCategoryFilterProvider.notifier).state =
                            selectedCategory == cat ? null : cat;
                      },
                    );
                  }),
                ],
              ),
            ),
          ),

          // ── Active Filters Bar ──────────────────────────────
          if (selectedCategory != null ||
              selectedBrand != null ||
              selectedSort != 'featured')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  Text(
                    'Active:',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (selectedCategory != null)
                    _ActiveChip(
                      label: selectedCategory.label,
                      onDeleted: () =>
                          ref
                                  .read(searchCategoryFilterProvider.notifier)
                                  .state =
                              null,
                    ),
                  if (selectedBrand != null)
                    _ActiveChip(
                      label: selectedBrand,
                      onDeleted: () =>
                          ref.read(searchBrandFilterProvider.notifier).state =
                              null,
                    ),
                  if (selectedSort != 'featured')
                    _ActiveChip(
                      label: selectedSort == 'name_asc'
                          ? 'A-Z'
                          : selectedSort == 'name_desc'
                          ? 'Z-A'
                          : selectedSort,
                      onDeleted: () =>
                          ref.read(searchSortProvider.notifier).state =
                              'featured',
                    ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      ref.read(searchCategoryFilterProvider.notifier).state =
                          null;
                      ref.read(searchBrandFilterProvider.notifier).state = null;
                      ref.read(searchSortProvider.notifier).state = 'featured';
                    },
                    child: Text(
                      'Clear all',
                      style: GoogleFonts.outfit(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const Divider(height: 1),

          // ── Search Results List / Empty / Recent Searches ───
          Expanded(
            child: searchResultsAsync.when(
              data: (products) {
                // If search is empty and no category filter, show recent searches & suggestions
                if (_controller.text.isEmpty && selectedCategory == null) {
                  return ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      // Recent searches
                      recentSearchesAsync.when(
                        data: (recent) {
                          if (recent.isEmpty) return const SizedBox.shrink();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Recent Searches',
                                    style: GoogleFonts.outfit(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? AppColors.textPrimary
                                          : AppColors.lightTextPrimary,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => ref
                                        .read(recentSearchesProvider.notifier)
                                        .clearAll(),
                                    child: Text(
                                      'Clear',
                                      style: GoogleFonts.outfit(
                                        fontSize: 12,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: recent.map((s) {
                                  return ActionChip(
                                    avatar: const Icon(
                                      Icons.history_rounded,
                                      size: 14,
                                    ),
                                    label: Text(s),
                                    onPressed: () {
                                      _controller.text = s;
                                      _onSearch(s);
                                    },
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 24),
                            ],
                          );
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),

                      // Popular suggestions
                      Text(
                        'Popular Component Searches',
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            [
                              '555 Timer',
                              'Arduino Uno',
                              'IRFZ44N MOSFET',
                              'BC547',
                              '1N4007 Diode',
                              'ESP32',
                              'Samsung TV Remote',
                              'Voltas AC Remote',
                              'Dell Laptop Battery',
                              'RTX GPU',
                              'Digital Multimeter',
                            ].map((suggestion) {
                              return ActionChip(
                                avatar: const Icon(
                                  Icons.search_rounded,
                                  size: 14,
                                  color: AppColors.primary,
                                ),
                                label: Text(suggestion),
                                onPressed: () {
                                  _controller.text = suggestion;
                                  _onSearch(suggestion);
                                },
                              );
                            }).toList(),
                      ),
                    ],
                  );
                }

                if (products.isEmpty) {
                  return Center(
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
                            'No products found',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.textPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Try different keywords, component IDs or model numbers.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ProductCard(product: products[index]),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Consumer(
          builder: (context, ref, _) {
            final sort = ref.watch(searchSortProvider);
            final brand = ref.watch(searchBrandFilterProvider);
            final isDark = Theme.of(context).brightness == Brightness.dark;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sort & Filters',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Sort Order',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('Featured / Popular'),
                          selected: sort == 'featured',
                          onSelected: (_) {
                            ref.read(searchSortProvider.notifier).state =
                                'featured';
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Name (A–Z)'),
                          selected: sort == 'name_asc',
                          onSelected: (_) {
                            ref.read(searchSortProvider.notifier).state =
                                'name_asc';
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Name (Z–A)'),
                          selected: sort == 'name_desc',
                          onSelected: (_) {
                            ref.read(searchSortProvider.notifier).state =
                                'name_desc';
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (brand != null) ...[
                      Text(
                        'Active Brand Filter: $brand',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          ref.read(searchBrandFilterProvider.notifier).state =
                              null;
                        },
                        child: const Text('Clear Brand Filter'),
                      ),
                    ],
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Apply'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SearchFilterPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SearchFilterPill({
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

class _ActiveChip extends StatelessWidget {
  final String label;
  final VoidCallback onDeleted;

  const _ActiveChip({required this.label, required this.onDeleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.14),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onDeleted,
            child: const Icon(
              Icons.close_rounded,
              size: 13,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
