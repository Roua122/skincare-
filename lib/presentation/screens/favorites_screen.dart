// presentation/screens/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/providers/app_provider.dart';
import '../widgets/product_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    final favorites = provider.favoriteProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        centerTitle: false,
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    "No favorites yet",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: favorites.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                return ProductCard(product: favorites[index]);
              },
            ),
    );
  }
}
