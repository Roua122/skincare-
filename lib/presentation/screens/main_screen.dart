// presentation/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/providers/app_provider.dart';
import '../../core/theme/app_theme.dart';

import 'home_screen.dart';
import 'category_screen.dart';
import 'favorites_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  late AnimationController _heartController;

  @override
  void initState() {
    super.initState();

    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      lowerBound: 0.9,
      upperBound: 1.2,
    );

    _heartController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _heartController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  final List<Widget> _screens = const [
    HomeScreen(),
    CategoryScreen(),
    FavoritesScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final cartCount = provider.cartCount;
        final hasFav = provider.favoriteProducts.isNotEmpty;
        return Container(
          decoration: AppTheme.backgroundGradient,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() => _currentIndex = index);
              },
              destinations: [
                const NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),

                const NavigationDestination(
                  icon: Icon(Icons.category_outlined),
                  label: 'Explore',
                ),

                // ❤️ المفضلة (نبض فقط بدون ألوان ثابتة)
                NavigationDestination(
                  icon: AnimatedBuilder(
                    animation: _heartController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _heartController.value,
                        child: Icon(
                          Icons.favorite,
                          color: hasFav
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).disabledColor,
                        ),
                      );
                    },
                  ),
                  label: 'Wishlist',
                ),

                // 🛍️ السلة
                NavigationDestination(
                  icon: Badge(
                    label: Text('$cartCount'),
                    isLabelVisible: cartCount > 0,
                    child: const Icon(Icons.shopping_bag_outlined),
                  ),
                  label: 'Cart',
                ),

                const NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
