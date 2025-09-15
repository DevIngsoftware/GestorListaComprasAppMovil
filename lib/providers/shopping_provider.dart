import 'package:flutter/material.dart';
import '../models/product.dart';
import 'auth_provider.dart';

class ShoppingProvider extends ChangeNotifier {
  final AuthProvider auth;
  List<Product> items = [];

  ShoppingProvider(this.auth);

  Future<void> fetchProducts() async {
    if (!auth.isAuthenticated) return;
    try {
      final res = await auth.api.getProducts();
      items = res.map<Product>((e) => Product.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addProduct(Product p) async {
    if (!auth.isAuthenticated) return;
    final res = await auth.api.addProduct(p.toJson());
    items.add(Product.fromJson(res));
    notifyListeners();
  }

  Future<void> updateProduct(Product p) async {
    if (!auth.isAuthenticated || p.id == null) return;
    final res = await auth.api.updateProduct(p.id!, p.toJson());
    final index = items.indexWhere((e) => e.id == p.id);
    if (index != -1) {
      items[index] = Product.fromJson(res);
      notifyListeners();
    }
  }

  Future<void> removeProduct(Product p) async {
    if (!auth.isAuthenticated || p.id == null) return;
    await auth.api.deleteProduct(p.id!);
    items.removeWhere((e) => e.id == p.id);
    notifyListeners();
  }

  Future<void> toggleAcquired(Product p) async {
    p.acquired = !p.acquired;
    await updateProduct(p);
  }
}
