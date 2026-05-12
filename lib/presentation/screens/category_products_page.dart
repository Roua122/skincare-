// presentation/screens/category_products_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/app_provider.dart';
import '../widgets/product_card.dart';

class CategoryProductsPage extends StatelessWidget {
  final String category;
  const CategoryProductsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final allProducts = provider.products;

    final displayedProducts = allProducts;

    return Scaffold(
      // 🔥 حل مشكلة السواد
      backgroundColor: const Color(0xFFF8F8F5),

      appBar: AppBar(
        title: Text(category),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: Container(
        // 🔥 خلفية ناعمة (بيج + أبيض + أخضر خفيف مثل ما طلبت)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF8F8F5),
              Color(0xFFFFFFFF),
              Color(0xFFEAF3EA),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: provider.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF1A531A),
                ),
              )
            : displayedProducts.isEmpty
                ? const Center(
                    child: Text('لا توجد منتجات متاحة حالياً'),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: displayedProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (ctx, i) =>
                        ProductCard(product: displayedProducts[i]),
                  ),
      ),
    );
  }
}