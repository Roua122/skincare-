// data/models/product.dart
class Product {
  final String id;
  final String title;
  final String category;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      imageUrl:
          json['image'] ?? json['thumbnail'] ?? '', // يدعم image أو thumbnail
    );
  }

  // 🔥 مهم (Object إلى JSON لو احتجناه لاحقًا)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'description': description,
      'price': price,
      'image': imageUrl,
    };
  }
}
