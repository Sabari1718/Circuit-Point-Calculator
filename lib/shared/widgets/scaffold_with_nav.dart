import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

class ScaffoldWithNav extends StatelessWidget {
  final Widget child;
  const ScaffoldWithNav({super.key, required this.child});

  static const _tabs = [
    AppConstants.routeHome,
    AppConstants.routeCalculators,
    AppConstants.routeElectronics,
    AppConstants.routeElectronicsFavourites,
    AppConstants.routeSettings,
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    for (int i = 0; i < _tabs.length; i++) {
      if (location == _tabs[i]) return i;
    }
    // Match nested electronics routes to electronics tab
    if (location.startsWith('/electronics')) return 2;
    if (location.startsWith('/product')) return 2;
    if (location.startsWith('/favourites')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final index = _currentIndex(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (i) => context.go(_tabs[i]),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.calculate_outlined),
              selectedIcon: Icon(Icons.calculate_rounded),
              label: 'Calculators',
            ),
            NavigationDestination(
              icon: Icon(Icons.memory_outlined),
              selectedIcon: Icon(Icons.memory_rounded),
              label: 'Electronics',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_border_rounded),
              selectedIcon: Icon(Icons.favorite_rounded),
              label: 'Favourites',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
