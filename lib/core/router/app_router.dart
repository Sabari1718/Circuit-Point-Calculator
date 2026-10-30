import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_screen.dart';
import '../../features/power_calculator/presentation/power_calculator_screen.dart';
import '../../features/resistor_calculator/presentation/resistor_calculator_screen.dart';
import '../../features/history/presentation/history_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/calculators/presentation/calculators_screen.dart';
import '../../features/electronics/presentation/electronics_home_screen.dart';
import '../../features/electronics/presentation/category_products_screen.dart';
import '../../features/electronics/presentation/electronics_search_screen.dart';
import '../../features/electronics/presentation/product_detail_screen.dart';
import '../../features/electronics/presentation/favourites_screen.dart';
import '../../shared/widgets/scaffold_with_nav.dart';
import '../constants/app_constants.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppConstants.routeHome,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithNav(child: child);
        },
        routes: [
          GoRoute(
            path: AppConstants.routeHome,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppConstants.routeCalculators,
            builder: (context, state) => const CalculatorsScreen(),
          ),
          GoRoute(
            path: AppConstants.routeElectronics,
            builder: (context, state) => const ElectronicsHomeScreen(),
          ),
          GoRoute(
            path: AppConstants.routeElectronicsFavourites,
            builder: (context, state) => const FavouritesScreen(),
          ),
          GoRoute(
            path: AppConstants.routeSettings,
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: AppConstants.routeHistory,
            builder: (context, state) => const HistoryScreen(),
          ),
        ],
      ),
      // Calculators routes (Full-screen)
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppConstants.routePowerCalculator,
        builder: (context, state) => const PowerCalculatorScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppConstants.routeResistorCalculator,
        builder: (context, state) => const ResistorCalculatorScreen(),
      ),
      // Electronics sub-routes
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '${AppConstants.routeElectronicsCategory}/:category',
        builder: (context, state) {
          final category = state.pathParameters['category'] ?? '';
          return CategoryProductsScreen(categoryName: category);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppConstants.routeElectronicsSearch,
        builder: (context, state) => const ElectronicsSearchScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '${AppConstants.routeProductDetail}/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ProductDetailScreen(productId: id);
        },
      ),
    ],
  );
});
