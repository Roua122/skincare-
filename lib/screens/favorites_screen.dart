// screens/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider.dart';
import '../widgets/product_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favs = Provider.of<AppProvider>(context).favoriteProducts;

    return Scaffold(
      appBar: AppBar(title: const Text("Wishlist")),
      body: favs.isEmpty
          ? const Center(child: Text("No favorites yet"))
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: favs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (ctx, i) => ProductCard(product: favs[i]),
            ),
    );
  }
}
