// provider.dart
import 'package:flutter/material.dart';
import 'models.dart';

class AppProvider with ChangeNotifier {
  // ================= PRODUCTS (4 per category) =================
  final List<Product> _products = [
    // 🧼 CLEANSERS (الغسول)
    Product(
      id: 'c1',
      title: 'Velvet Glow Cleanser',
      category: 'Cleansers',
      description: 'Deep cleansing foam.',
      price: 22,
      imageUrl:
          'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?q=80&w=800&auto=format&fit=crop',
    ),
    Product(
      id: 'c2',
      title: 'Milk Cleanser',
      category: 'Cleansers',
      description: 'Gentle milk formula.',
      price: 18,
      imageUrl:
          'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?q=80&w=800&auto=format&fit=crop',
    ),
    Product(
      id: 'c3',
      title: 'Charcoal Cleanser',
      category: 'Cleansers',
      description: 'Deep pore cleansing.',
      price: 25,
      imageUrl:
          'https://images.unsplash.com/photo-1598440947611-37d40a3f9e94?q=80&w=800&auto=format&fit=crop',
    ),
    Product(
      id: 'c4',
      title: 'Foam Cleanser',
      category: 'Cleansers',
      description: 'Daily gentle foam.',
      price: 20,
      imageUrl:
          'https://images.unsplash.com/photo-1615395701366-2673998f98f6?q=80&w=800&auto=format&fit=crop',
    ),

    // 💧 SERUMS (السيروم)
    Product(
      id: 's1',
      title: 'Vitamin C Serum',
      category: 'Serums',
      description: 'Brightening serum.',
      price: 45,
      imageUrl:
          'https://images.unsplash.com/photo-1599305090598-fe179d501227?q=80&w=800&auto=format&fit=crop',
    ),
    Product(
      id: 's2',
      title: 'Hyaluronic Acid',
      category: 'Serums',
      description: 'Deep hydration.',
      price: 38,
      imageUrl:
          'https://images.unsplash.com/photo-1629198688000-71f23e745b6e?q=80&w=800&auto=format&fit=crop',
    ),
    Product(
      id: 's3',
      title: 'Retinol Serum',
      category: 'Serums',
      description: 'Anti-aging care.',
      price: 55,
      imageUrl:
          'https://images.unsplash.com/photo-1608248593842-801061f52d50?q=80&w=800&auto=format&fit=crop',
    ),
    Product(
      id: 's4',
      title: 'Niacinamide Serum',
      category: 'Serums',
      description: 'Oil control formula.',
      price: 32,
      imageUrl:
          'https://images.unsplash.com/photo-1620916297397-a4a5402a3c6c?q=80&w=800&auto=format&fit=crop',
    ),

    // 🧴 MOISTURIZERS (المرطبات)
    Product(
      id: 'm1',
      title: 'Daily Moisturizer',
      category: 'Moisturizers',
      description: 'Light hydration.',
      price: 30,
      imageUrl:
          'https://images.unsplash.com/photo-1601049541541-610738e4a9e2?q=80&w=800&auto=format&fit=crop',
    ),
    Product(
      id: 'm2',
      title: 'Night Repair Cream',
      category: 'Moisturizers',
      description: 'Night recovery.',
      price: 42,
      imageUrl:
          'https://images.unsplash.com/photo-1552662321-45053629e1f5?q=80&w=800&auto=format&fit=crop',
    ),
    Product(
      id: 'm3',
      title: 'Water Gel Cream',
      category: 'Moisturizers',
      description: 'Cooling hydration.',
      price: 28,
      imageUrl:
          'https://images.unsplash.com/photo-1547887538-e3a2f32cb1cc?q=80&w=800&auto=format&fit=crop',
    ),
    Product(
      id: 'm4',
      title: 'SPF Moisturizer',
      category: 'Moisturizers',
      description: 'Sun protection.',
      price: 26,
      imageUrl:
          'https://images.unsplash.com/photo-1611078489935-0cb964de46d6?q=80&w=800&auto=format&fit=crop',
    ),

    // 🧖 MASKS (الماسكات)
    Product(
      id: 'k1',
      title: 'Pink Clay Mask',
      category: 'Masks',
      description: 'Detox mask.',
      price: 29,
      imageUrl:
          'https://images.unsplash.com/photo-1556228720-1c2ae6ba6ceb?q=80&w=800&auto=format&fit=crop',
    ),
    Product(
      id: 'k2',
      title: 'Green Tea Mask',
      category: 'Masks',
      description: 'Antioxidant mask.',
      price: 15,
      imageUrl:
          'https://images.unsplash.com/photo-1571781926291-c477eb0024cb?q=80&w=800&auto=format&fit=crop',
    ),
    Product(
      id: 'k3',
      title: 'Sleeping Mask',
      category: 'Masks',
      description: 'Overnight glow.',
      price: 33,
      imageUrl:
          'https://images.unsplash.com/photo-1590156546946-ce55a12a6a5d?q=80&w=800&auto=format&fit=crop',
    ),
    Product(
      id: 'k4',
      title: 'Vitamin E Mask',
      category: 'Masks',
      description: 'Hydration boost.',
      price: 20,
      imageUrl:
          'https://images.unsplash.com/photo-1580870059714-388bd25eb054?q=80&w=800&auto=format&fit=crop',
    ),
  ];

  // ================= CART =================
  final Map<String, CartItem> _cartItems = {};

  List<Product> get products => _products;

  List<Product> get favoriteProducts =>
      _products.where((p) => p.isFavorite).toList();

  Map<String, CartItem> get cartItems => _cartItems;

  int get cartCount {
    int count = 0;
    _cartItems.forEach((k, v) => count += v.quantity);
    return count;
  }

  double get totalPrice {
    double total = 0;
    _cartItems.forEach((k, v) {
      total += v.product.price * v.quantity;
    });
    return total;
  }

  // ================= FAVORITE =================
  void toggleFavorite(String id) {
    final index = _products.indexWhere((p) => p.id == id);

    if (index != -1) {
      _products[index] = Product(
        id: _products[index].id,
        title: _products[index].title,
        category: _products[index].category,
        description: _products[index].description,
        price: _products[index].price,
        imageUrl: _products[index].imageUrl,
        isFavorite: !_products[index].isFavorite,
      );

      notifyListeners();
    }
  }

  // ================= CART =================
  void addToCart(Product product) {
    if (_cartItems.containsKey(product.id)) {
      _cartItems.update(
        product.id,
        (item) => CartItem(
          id: item.id,
          product: item.product,
          quantity: item.quantity + 1,
        ),
      );
    } else {
      _cartItems[product.id] = CartItem(
        id: DateTime.now().toString(),
        product: product,
        quantity: 1,
      );
    }

    notifyListeners();
  }

  void removeFromCart(String id) {
    _cartItems.remove(id);
    notifyListeners();
  }

  void increaseQty(String id) {
    if (_cartItems.containsKey(id)) {
      _cartItems[id]!.quantity++;
      notifyListeners();
    }
  }

  void decreaseQty(String id) {
    if (_cartItems.containsKey(id)) {
      if (_cartItems[id]!.quantity > 1) {
        _cartItems[id]!.quantity--;
      } else {
        _cartItems.remove(id);
      }
      notifyListeners();
    }
  }
}
