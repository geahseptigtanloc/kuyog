import 'package:flutter/material.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;
  String? selectedVariant;

  CartItem({required this.product, this.quantity = 1, this.selectedVariant});

  double get subtotal => product.price * quantity;
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  String _promoCode = '';
  bool _useKuyogMiles = false;

  List<CartItem> get items => _items;
  String get promoCode => _promoCode;
  bool get useKuyogMiles => _useKuyogMiles;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.subtotal);

  double get deliveryFee => _items.isEmpty ? 0 : 100;

  double get discount => _useKuyogMiles ? 50 : 0;

  double get total => subtotal + deliveryFee - discount;

  void addToCart(Product product, {String? variant}) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id && item.selectedVariant == variant,
    );
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(product: product, selectedVariant: variant));
    }
    notifyListeners();
  }

  void removeFromCart(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void updateQuantity(int index, int quantity) {
    if (quantity <= 0) {
      _items.removeAt(index);
    } else {
      _items[index].quantity = quantity;
    }
    notifyListeners();
  }

  void setPromoCode(String code) {
    _promoCode = code;
    notifyListeners();
  }

  void toggleKuyogMiles() {
    _useKuyogMiles = !_useKuyogMiles;
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _promoCode = '';
    _useKuyogMiles = false;
    notifyListeners();
  }
}
