import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../data/mock_data.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = true;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  ProductProvider() {
    _init();
  }

  Future<void> _init() async {
    _products = await MockData.getProducts();
    _isLoading = false;
    notifyListeners();
  }

  void addProduct(Product product) {
    _products.insert(0, product);
    notifyListeners();
  }
}
