import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../data/product_repository.dart';
import '../domain/electronics_models.dart';

// ── Repository Provider ──────────────────────────────────────────────────────
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return LocalProductRepository();
});

// ── Data Providers ───────────────────────────────────────────────────────────
final allProductsProvider = FutureProvider<List<ElectronicsProduct>>((
  ref,
) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getAllProducts();
});

final featuredProductsProvider = FutureProvider<List<ElectronicsProduct>>((
  ref,
) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getFeaturedProducts();
});

final categoryProductsProvider =
    FutureProvider.family<List<ElectronicsProduct>, ElectronicsCategory>((
      ref,
      category,
    ) async {
      final repo = ref.watch(productRepositoryProvider);
      return repo.getProductsByCategory(category);
    });

final categoryBrandsProvider =
    FutureProvider.family<List<String>, ElectronicsCategory>((
      ref,
      category,
    ) async {
      final repo = ref.watch(productRepositoryProvider);
      return repo.getBrandsForCategory(category);
    });

final categorySubcategoriesProvider =
    FutureProvider.family<List<String>, ElectronicsCategory>((
      ref,
      category,
    ) async {
      final repo = ref.watch(productRepositoryProvider);
      return repo.getSubcategoriesForCategory(category);
    });

final productDetailProvider =
    FutureProvider.family<ElectronicsProduct?, String>((ref, id) async {
      final repo = ref.watch(productRepositoryProvider);
      return repo.getProductById(id);
    });

final relatedProductsProvider =
    FutureProvider.family<List<ElectronicsProduct>, List<String>>((
      ref,
      ids,
    ) async {
      final repo = ref.watch(productRepositoryProvider);
      return repo.getRelatedProducts(ids);
    });

// ── Search State ─────────────────────────────────────────────────────────────
final searchQueryProvider = StateProvider<String>((ref) => '');
final searchCategoryFilterProvider = StateProvider<ElectronicsCategory?>(
  (ref) => null,
);
final searchBrandFilterProvider = StateProvider<String?>((ref) => null);
final searchSubcategoryFilterProvider = StateProvider<String?>((ref) => null);
final searchSortProvider = StateProvider<String>((ref) => 'featured');
final remoteModelSearchQueryProvider = StateProvider<String>((ref) => '');

// ── Search Results ───────────────────────────────────────────────────────────
final searchResultsProvider = FutureProvider<List<ElectronicsProduct>>((
  ref,
) async {
  final repo = ref.watch(productRepositoryProvider);
  final query = ref.watch(searchQueryProvider);
  final category = ref.watch(searchCategoryFilterProvider);
  final brand = ref.watch(searchBrandFilterProvider);
  final subcategory = ref.watch(searchSubcategoryFilterProvider);
  final sortBy = ref.watch(searchSortProvider);

  return repo.search(
    query: query,
    category: category,
    brand: brand,
    subcategory: subcategory,
    sortBy: sortBy,
  );
});

final remoteModelSearchResultsProvider =
    FutureProvider<List<ElectronicsProduct>>((ref) async {
      final repo = ref.watch(productRepositoryProvider);
      final query = ref.watch(remoteModelSearchQueryProvider);
      if (query.trim().isEmpty) return [];
      return repo.searchRemotesByModel(query);
    });

// ── Favourites State (Persistent) ────────────────────────────────────────────
final favouritesProvider =
    AsyncNotifierProvider<FavouritesNotifier, Set<String>>(
      FavouritesNotifier.new,
    );

class FavouritesNotifier extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(AppConstants.keyFavouriteProducts) ?? [];
    return list.toSet();
  }

  Future<void> toggleFavourite(String productId) async {
    final current = state.valueOrNull ?? <String>{};
    final updated = Set<String>.from(current);
    if (updated.contains(productId)) {
      updated.remove(productId);
    } else {
      updated.add(productId);
    }
    state = AsyncData(updated);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      AppConstants.keyFavouriteProducts,
      updated.toList(),
    );
  }

  bool isFavourite(String productId) {
    return state.valueOrNull?.contains(productId) ?? false;
  }
}

final favouriteProductsListProvider = FutureProvider<List<ElectronicsProduct>>((
  ref,
) async {
  final favIds = ref.watch(favouritesProvider).valueOrNull ?? <String>{};
  if (favIds.isEmpty) return [];
  final repo = ref.watch(productRepositoryProvider);
  final all = await repo.getAllProducts();
  return all.where((p) => favIds.contains(p.id)).toList();
});

// ── Recent Searches State (Persistent) ───────────────────────────────────────
final recentSearchesProvider =
    AsyncNotifierProvider<RecentSearchesNotifier, List<String>>(
      RecentSearchesNotifier.new,
    );

class RecentSearchesNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(AppConstants.keyRecentSearches) ?? [];
  }

  Future<void> addSearch(String query) async {
    final q = query.trim();
    if (q.isEmpty) return;
    final current = state.valueOrNull ?? [];
    final updated = [
      q,
      ...current.where((item) => item.toLowerCase() != q.toLowerCase()),
    ].take(AppConstants.maxRecentSearches).toList();
    state = AsyncData(updated);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(AppConstants.keyRecentSearches, updated);
  }

  Future<void> removeSearch(String query) async {
    final current = state.valueOrNull ?? [];
    final updated = current.where((item) => item != query).toList();
    state = AsyncData(updated);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(AppConstants.keyRecentSearches, updated);
  }

  Future<void> clearAll() async {
    state = const AsyncData([]);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.keyRecentSearches);
  }
}

// ── Recently Viewed State (Persistent) ───────────────────────────────────────
final recentlyViewedProvider =
    AsyncNotifierProvider<RecentlyViewedNotifier, List<String>>(
      RecentlyViewedNotifier.new,
    );

class RecentlyViewedNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(AppConstants.keyRecentlyViewed) ?? [];
  }

  Future<void> addViewed(String productId) async {
    if (productId.isEmpty) return;
    final current = state.valueOrNull ?? [];
    final updated = [
      productId,
      ...current.where((id) => id != productId),
    ].take(AppConstants.maxRecentlyViewed).toList();
    state = AsyncData(updated);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(AppConstants.keyRecentlyViewed, updated);
  }

  Future<void> clearAll() async {
    state = const AsyncData([]);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.keyRecentlyViewed);
  }
}

final recentlyViewedProductsListProvider =
    FutureProvider<List<ElectronicsProduct>>((ref) async {
      final ids = ref.watch(recentlyViewedProvider).valueOrNull ?? [];
      if (ids.isEmpty) return [];
      final repo = ref.watch(productRepositoryProvider);
      final all = await repo.getAllProducts();
      final map = {for (final p in all) p.id: p};
      return ids.map((id) => map[id]).whereType<ElectronicsProduct>().toList();
    });
