// data/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  // استخدام API سريع وموثوق ويدعم CORS مباشرة
  static const String url = "https://dummyjson.com/products";

  static Future<List<Product>> fetchProducts() async {
    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 15)); // مهلة 15 ثانية

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse[
            'products']; // DummyJSON يحط المنتجات داخل key 'products'
        return data.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception("فشل التحميل: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("خطأ في الاتصال: $e");
    }
  }
}
