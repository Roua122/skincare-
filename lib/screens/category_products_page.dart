// screens/category_products_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider.dart';
import '../widgets/product_card.dart';

class CategoryProductsPage extends StatelessWidget {
  final String category;

  const CategoryProductsPage({required this.category});

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<AppProvider>(
      context,
    ).products.where((p) => p.category == category).toList();

    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (ctx, i) => ProductCard(product: products[i]),
      ),
    );
  }
}
