// Core application constants
class AppConstants {
  AppConstants._();

  static const String appName = 'Circuit Point';
  static const String appTagline =
      'Smart Electrical Calculator & Hardware Catalog';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // SharedPreferences keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyCalculationHistory = 'calculation_history';
  static const String keyRecentCalculators = 'recent_calculators';
  static const String keyFavouriteProducts = 'favourite_products';
  static const String keyRecentSearches = 'recent_searches';
  static const String keyRecentlyViewed = 'recently_viewed';

  // Route names
  static const String routeHome = '/';
  static const String routeCalculators = '/calculators';
  static const String routePowerCalculator = '/power-calculator';
  static const String routeResistorCalculator = '/resistor-calculator';
  static const String routeHistory = '/history';
  static const String routeSettings = '/settings';

  // Electronics routes
  static const String routeElectronics = '/electronics';
  static const String routeElectronicsCategory = '/electronics/category';
  static const String routeElectronicsSearch = '/electronics/search';
  static const String routeElectronicsFavourites = '/favourites';
  static const String routeProductDetail = '/product';

  // Max history items
  static const int maxHistoryItems = 100;
  static const int maxRecentSearches = 10;
  static const int maxRecentlyViewed = 20;

  // Formula reference
  static const String formulaDC = 'P = V × I';
  static const String formulaACSingle = 'P = V × I × PF';
  static const String formulaACThree = 'P = √3 × V × I × PF';
}
