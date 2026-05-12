// presentation/widgets/product_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart'; // 🔥 أعدنا استيراد المكتبة

import 'product_modal.dart';
import '../../data/providers/app_provider.dart';
import '../../data/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  // 🔥 دالة بناء الصورة تدعم الكاش (حفظ الصور) ودائرة التحميل
  Widget buildImage(String url) {
    if (url.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        // 🔥 دائرة التحميل التي تظهر أثناء جلب الصورة من الإنترنت
        placeholder: (context, url) => Container(
          color: Colors.grey.shade100,
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.grey,
            ),
          ),
        ),
        // 🔥 في حال لم تكن الصورة محفوظة في الكاش ولم يوجد إنترنت
        errorWidget: (context, url, error) => Container(
          color: Colors.grey.shade100,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off_rounded, size: 30, color: Colors.grey),
              SizedBox(height: 5),
              Text(
                "Offline",
                style: TextStyle(fontSize: 10, color: Colors.grey),
              )
            ],
          ),
        ),
      );
    } else {
      // للصور المحلية (Assets)
      return Image.asset(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey.shade100,
          child: const Center(
            child:
                Icon(Icons.broken_image_rounded, size: 40, color: Colors.grey),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final isFav = product.isFavorite;

        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              builder: (_) => ProductModalDetail(product: product),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= صورة المنتج مع أيقونة القلب =================
                Expanded(
                  flex: 2,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)),
                        child: buildImage(product.imageUrl),
                      ),
                      // أيقونة القلب (المفضلة)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => provider.toggleFavorite(product.id),
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white,
                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: Colors.red,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // ================= معلومات المنتج وزر السلة =================
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\$${product.price.toStringAsFixed(2)}",
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                provider.addToCart(product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Added to cart 🛒"),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.shopping_bag_outlined,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
