// data/services/cart_storage_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../data/providers/app_provider.dart'; // لاستيراد تعريف CartItem
import '../models/product.dart';

class CartStorageService {
  static Future<File> _getCartFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/cart.json');
    await file.parent.create(recursive: true);
    return file;
  }

  static Future<void> saveCart(List<CartItem> items) async {
    try {
      final file = await _getCartFile();
      final jsonList = items
          .map((item) => {
                'id': item.id,
                'product': item.product.toJson(),
                'quantity': item.quantity,
              })
          .toList();
      await file.writeAsString(jsonEncode(jsonList));
    } catch (e) {
      print("Error saving cart: $e");
    }
  }

  static Future<List<CartItem>> loadCart() async {
    try {
      final file = await _getCartFile();
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonList = jsonDecode(contents);
        return jsonList
            .map((json) => CartItem(
                  id: json['id'],
                  product: Product.fromJson(json['product']),
                  quantity: json['quantity'],
                ))
            .toList();
      }
    } catch (e) {
      print("Error loading cart: $e");
    }
    return [];
  }
}
