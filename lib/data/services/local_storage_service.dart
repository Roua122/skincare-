// data/services/local_storage_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/product.dart';

class LocalStorageService {
  static Future<File> _getFavoritesFile() async {
    final directory = await getApplicationSupportDirectory();
    final file = File('${directory.path}/favorites.json');
    await file.parent.create(recursive: true);
    return file;
  }

  static Future<File> _getCacheFile() async {
    final directory = await getApplicationSupportDirectory();
    final file = File('${directory.path}/products_cache.json');
    await file.parent.create(recursive: true);
    return file;
  }

  // حفظ المفضلات
  static Future<void> saveFavorites(List<Product> favorites) async {
    try {
      final file = await _getFavoritesFile();
      final jsonList = favorites.map((p) => p.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonList));
    } catch (e) {
      print("Error saving favorites: $e");
    }
  }

  // تحميل المفضلات
  static Future<List<Product>> loadFavorites() async {
    try {
      final file = await _getFavoritesFile();
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonList = jsonDecode(contents);
        return jsonList.map((json) => Product.fromJson(json)).toList();
      }
    } catch (e) {
      print("Error loading favorites: $e");
    }
    return [];
  }

  // ✅ Exercise 3: حفظ Cache
  static Future<void> cacheProducts(String jsonString) async {
    try {
      final file = await _getCacheFile();
      await file.writeAsString(jsonString);
    } catch (e) {
      print("Error caching products: $e");
    }
  }

  // ✅ Exercise 3: تحميل Cache
  static Future<String?> loadCachedProducts() async {
    try {
      final file = await _getCacheFile();
      if (await file.exists()) {
        return await file.readAsString();
      }
    } catch (e) {
      print("Error loading cached products: $e");
    }
    return null;
  }
}
