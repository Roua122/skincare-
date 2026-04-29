// screens/category_screen.dart
import 'package:flutter/material.dart';
import 'category_products_page.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final cats = [
      {
        'title': 'Cleansers',
        'icon': Icons.water_drop_rounded,
        'color': Colors.blue.shade100,
      },
      {
        'title': 'Serums',
        'icon': Icons.science_rounded,
        'color': Colors.purple.shade100,
      },
      {
        'title': 'Moisturizers',
        'icon': Icons.spa_rounded,
        'color': Colors.green.shade100,
      },
      {
        'title': 'Masks',
        'icon': Icons.face_retouching_natural_rounded,
        'color': Colors.orange.shade100,
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Collections",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: cats.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (ctx, i) => InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (c) =>
                  CategoryProductsPage(category: cats[i]['title'] as String),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: cats[i]['color'] as Color,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  cats[i]['icon'] as IconData,
                  size: 50,
                  color: const Color(0xFF1A531A),
                ),
                const SizedBox(height: 10),
                Text(
                  cats[i]['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
