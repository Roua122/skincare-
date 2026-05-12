// data/providers/app_provider.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:skincare/data/services/api_service.dart';
import '../models/product.dart';
import '../services/local_storage_service.dart';

class CartItem {
  final String id;
  final Product product;
  int quantity;

  CartItem({
    required this.id,
    required this.product,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'product': product.toJson(),
        'quantity': quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json['id'],
        product: Product.fromJson(json['product']),
        quantity: json['quantity'],
      );
}

class AppProvider with ChangeNotifier {
  // ================= PRODUCTS =================
  List<Product> _products = [];
  bool isLoading = true;
  bool isOfflineMode = false;
  String? _error;

  String? get error => _error;
  List<Product> get products => _products;

  // ================= CART =================
  final Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get cartItems => _cartItems;

  int get cartCount {
    int count = 0;
    for (var item in _cartItems.values) {
      count += item.quantity;
    }
    return count;
  }

  double get totalPrice {
    double total = 0;
    for (var item in _cartItems.values) {
      total += item.product.price * item.quantity;
    }
    return total;
  }

  // ================= FAVORITES =================
  List<Product> get favoriteProducts =>
      _products.where((p) => p.isFavorite).toList();

  // ================= INIT =================
  Future<void> init() async {
    await loadProducts();

    await Future.wait([
      _loadSavedFavorites(),
      _loadSavedCart(),
    ]);
  }

  // ================= LOAD PRODUCTS =================
  Future<void> loadProducts({bool forceRefresh = false}) async {
    // منع التحميل المتكرر إذا كانت البيانات موجودة والتحميل ليس قسرياً
    if (!forceRefresh && isLoading && _products.isNotEmpty) return;

    isLoading = true;
    _error = null;
    notifyListeners();

    // متغير لتتبع ما إذا تم التحميل بنجاح من الإنترنت
    bool onlineSuccess = false;

    try {
      // محاولة التحميل من الإنترنت
      _products = await ApiService.fetchProducts();
      onlineSuccess = true;
      isOfflineMode = false;

      // حفظ البيانات في الكاش (للاستخدام دون اتصال لاحقاً)
      final jsonString = jsonEncode(_products.map((p) => p.toJson()).toList());
      await LocalStorageService.cacheProducts(jsonString);
      print("✅ تم تحميل ${_products.length} منتج من الإنترنت وحفظها في الكاش");
    } catch (networkError) {
      // فشل الاتصال بالإنترنت أو مهلة زمنية
      print("❌ فشل الاتصال: $networkError. محاولة التحميل من الكاش...");
      try {
        final cached = await LocalStorageService.loadCachedProducts();
        if (cached != null && cached.isNotEmpty) {
          final List<dynamic> jsonList = jsonDecode(cached);
          if (jsonList.isNotEmpty) {
            _products = jsonList.map((json) => Product.fromJson(json)).toList();
            isOfflineMode = true;
            _error = "وضع غير متصل - يتم عرض بيانات مخزنة مؤقتاً";
            print("✅ تم تحميل ${_products.length} منتج من الكاش");
          } else {
            _products = [];
            _error = "لا توجد بيانات مخزنة صالحة";
          }
        } else {
          _products = [];
          _error = "لا يوجد اتصال بالإنترنت ولا توجد بيانات مخزنة مسبقًا";
        }
      } catch (cacheError) {
        // أي خطأ في قراءة أو تحليل الكاش (مثل ملف تالف)
        _products = [];
        _error = "خطأ في قراءة البيانات المخزنة: $cacheError";
        print("❌ خطأ في الكاش: $cacheError");
      }
    } finally {
      // 🔥 أهم خطوة: نضمن تعيين isLoading = false في جميع الأحوال
      isLoading = false;
      if (hasListeners) notifyListeners();
    }

    // إذا نجح التحميل من الإنترنت، يمكننا تحديث المفضلات والسلة (اختياري)
    if (onlineSuccess) {
      await _applySavedFavorites();
      await _loadSavedCart(); // تأكد من وجود هذه الدالة
    } else {
      // في وضع الأوفلاين، نطبق المفضلات المخزنة على البيانات الحالية (من الكاش)
      await _applySavedFavorites();
    }
  }

  // ================= FAVORITES =================
  void toggleFavorite(String id) async {
    final index = _products.indexWhere((p) => p.id.toString() == id);

    if (index != -1) {
      _products[index].isFavorite = !_products[index].isFavorite;

      notifyListeners();

      await LocalStorageService.saveFavorites(favoriteProducts);
    }
  }

  Future<void> _loadSavedFavorites() async {
    await _applySavedFavorites();
  }

  Future<void> _applySavedFavorites() async {
    final saved = await LocalStorageService.loadFavorites();

    for (var fav in saved) {
      final index = _products.indexWhere(
        (p) => p.id.toString() == fav.id.toString(),
      );

      if (index != -1) {
        _products[index].isFavorite = true;
      }
    }
  }

  bool isFavorite(String id) {
    return _products.any(
      (p) => p.id.toString() == id && p.isFavorite,
    );
  }

  // ================= CART =================
  Future<void> addToCart(Product product) async {
    final id = product.id.toString();

    if (_cartItems.containsKey(id)) {
      _cartItems[id]!.quantity++;
    } else {
      _cartItems[id] = CartItem(id: id, product: product);
    }

    await _saveCart();
    notifyListeners();
  }

  Future<void> increaseQty(String id) async {
    if (_cartItems.containsKey(id)) {
      _cartItems[id]!.quantity++;
      await _saveCart();
      notifyListeners();
    }
  }

  Future<void> decreaseQty(String id) async {
    if (_cartItems.containsKey(id)) {
      if (_cartItems[id]!.quantity > 1) {
        _cartItems[id]!.quantity--;
      } else {
        _cartItems.remove(id);
      }

      await _saveCart();
      notifyListeners();
    }
  }

  Future<void> removeFromCart(String id) async {
    _cartItems.remove(id);
    await _saveCart();
    notifyListeners();
  }

  Future<void> clearCart() async {
    _cartItems.clear();
    await _saveCart();
    notifyListeners();
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();

    final jsonList = _cartItems.values.map((e) => e.toJson()).toList();

    await prefs.setString('cart_items', jsonEncode(jsonList));
  }

  Future<void> _loadSavedCart() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString('cart_items');

    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);

      _cartItems.clear();

      for (var json in jsonList) {
        final item = CartItem.fromJson(json);
        _cartItems[item.id] = item;
      }
    }

    notifyListeners();
  }
}
