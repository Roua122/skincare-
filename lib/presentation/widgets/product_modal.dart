// presentation/widgets/product_modal.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/app_provider.dart';
import '../../data/models/product.dart';

class ProductModalDetail extends StatelessWidget {
  final Product product;
  const ProductModalDetail({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 15, 25, 25),
      decoration: const BoxDecoration(
        color: Color(0xFFFBFBF9),
        borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // زر الرجوع + المقبض
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: Color(0xFF1B4332),
                  ),
                ),
              ),
              Container(
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 34),
            ],
          ),

          const SizedBox(height: 20),

          // الصورة
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.network(
              product.imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 20),

          // العنوان + السعر
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFFD4AF37),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                "\$${product.price}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1A531A),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          const Text(
            "Product Description",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          Text(
            product.description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 30),

          // الأزرار (مفضلة + سلة)
          Row(
            children: [
              // زر المفضلة
              Consumer<AppProvider>(
                builder: (context, appProvider, child) {
                  final isFav = appProvider.products
                      .firstWhere((p) => p.id == product.id)
                      .isFavorite;

                  return GestureDetector(
                    onTap: () => appProvider.toggleFavorite(product.id),
                    child: Container(
                      height: 60,
                      width: 60,
                      margin: const EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFD4AF37),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: const Color(0xFFD4AF37),
                      ),
                    ),
                  );
                },
              ),

              // زر إضافة للسلة
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    Provider.of<AppProvider>(
                      context,
                      listen: false,
                    ).addToCart(product);

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Added to Bag ✨"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: const Text(
                    "Add to Bag",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
