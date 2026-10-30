import '../domain/electronics_models.dart';
import 'product_database.dart';

abstract class ProductRepository {
  Future<List<ElectronicsProduct>> getAllProducts();
  Future<List<ElectronicsProduct>> getProductsByCategory(
    ElectronicsCategory category,
  );
  Future<ElectronicsProduct?> getProductById(String id);
  Future<List<ElectronicsProduct>> getRelatedProducts(List<String> ids);
  Future<List<ElectronicsProduct>> getFeaturedProducts();
  Future<List<String>> getBrandsForCategory(ElectronicsCategory category);
  Future<List<String>> getSubcategoriesForCategory(
    ElectronicsCategory category,
  );
  Future<List<ElectronicsProduct>> search({
    String? query,
    ElectronicsCategory? category,
    String? brand,
    String? subcategory,
    String? sortBy,
  });
  Future<List<ElectronicsProduct>> searchRemotesByModel(String modelNumber);
}

class LocalProductRepository implements ProductRepository {
  final List<ElectronicsProduct> _products;

  LocalProductRepository({List<ElectronicsProduct>? products})
    : _products = products ?? ProductDatabase.allProducts;

  @override
  Future<List<ElectronicsProduct>> getAllProducts() async {
    return _products;
  }

  @override
  Future<List<ElectronicsProduct>> getProductsByCategory(
    ElectronicsCategory category,
  ) async {
    return _products.where((p) => p.category == category).toList();
  }

  @override
  Future<ElectronicsProduct?> getProductById(String id) async {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<ElectronicsProduct>> getRelatedProducts(List<String> ids) async {
    if (ids.isEmpty) return [];
    return _products.where((p) => ids.contains(p.id)).toList();
  }

  @override
  Future<List<ElectronicsProduct>> getFeaturedProducts() async {
    final featured = _products.where((p) => p.isFeatured).toList();
    if (featured.isNotEmpty) return featured;
    return _products.take(8).toList();
  }

  @override
  Future<List<String>> getBrandsForCategory(
    ElectronicsCategory category,
  ) async {
    final brands = <String>{};
    for (final p in _products.where((p) => p.category == category)) {
      if (p.brand != null && p.brand!.trim().isNotEmpty) {
        brands.add(p.brand!.trim());
      }
      for (final b in p.laptopBrands) {
        if (b.trim().isNotEmpty) brands.add(b.trim());
      }
    }
    final list = brands.toList()..sort();
    return list;
  }

  @override
  Future<List<String>> getSubcategoriesForCategory(
    ElectronicsCategory category,
  ) async {
    final subcats =
        _products
            .where((p) => p.category == category)
            .map((p) => p.subcategory)
            .where((s) => s.trim().isNotEmpty)
            .toSet()
            .toList()
          ..sort();
    return subcats;
  }

  @override
  Future<List<ElectronicsProduct>> search({
    String? query,
    ElectronicsCategory? category,
    String? brand,
    String? subcategory,
    String? sortBy,
  }) async {
    var result = List<ElectronicsProduct>.from(_products);

    if (category != null) {
      result = result.where((p) => p.category == category).toList();
    }

    if (subcategory != null && subcategory.isNotEmpty && subcategory != 'All') {
      result = result.where((p) => p.subcategory == subcategory).toList();
    }

    if (brand != null && brand.isNotEmpty && brand != 'All') {
      final bLower = brand.toLowerCase();
      result = result.where((p) {
        final matchesDirect = p.brand?.toLowerCase() == bLower;
        final matchesLaptop = p.laptopBrands.any(
          (b) => b.toLowerCase() == bLower,
        );
        return matchesDirect || matchesLaptop;
      }).toList();
    }

    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      result = result.where((p) => p.matchesSearch(q)).toList();
    }

    if (sortBy == 'name_asc') {
      result.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    } else if (sortBy == 'name_desc') {
      result.sort(
        (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()),
      );
    } else if (sortBy == 'featured') {
      result.sort(
        (a, b) => (b.isFeatured ? 1 : 0).compareTo(a.isFeatured ? 1 : 0),
      );
    }

    return result;
  }

  @override
  Future<List<ElectronicsProduct>> searchRemotesByModel(
    String modelNumber,
  ) async {
    if (modelNumber.trim().isEmpty) return [];
    final q = modelNumber.trim().toLowerCase();
    return _products
        .where(
          (p) =>
              p.category == ElectronicsCategory.remoteControls &&
              p.compatibleModels.any((m) => m.toLowerCase().contains(q)),
        )
        .toList();
  }
}
