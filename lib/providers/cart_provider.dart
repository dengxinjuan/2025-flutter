import 'package:flutter/foundation.dart';

class CartItem {
  final String sku;
  final String name;
  final String price;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.sku,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });

  // Parse "$37.99" → 37.99
  double get numericPrice {
    final cleaned = price.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleaned) ?? 0;
  }

  double get subtotal => numericPrice * quantity;
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => Map.unmodifiable(_items);

  /// Total number of individual units across all items
  int get itemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);

  /// Total price in numeric form
  double get totalPrice => _items.values.fold(0, (sum, item) => sum + item.subtotal);

  /// Formatted total price e.g. "$74.98"
  String get formattedTotal {
    return '\$${totalPrice.toStringAsFixed(2)}';
  }

  bool contains(String sku) => _items.containsKey(sku);

  int quantityOf(String sku) => _items[sku]?.quantity ?? 0;

  void addItem({
    required String sku,
    required String name,
    required String price,
    required String imageUrl,
  }) {
    if (_items.containsKey(sku)) {
      _items[sku]!.quantity++;
    } else {
      _items[sku] = CartItem(
        sku: sku,
        name: name,
        price: price,
        imageUrl: imageUrl,
      );
    }
    notifyListeners();
  }

  void increaseQuantity(String sku) {
    if (_items.containsKey(sku)) {
      _items[sku]!.quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(String sku) {
    if (!_items.containsKey(sku)) return;
    if (_items[sku]!.quantity > 1) {
      _items[sku]!.quantity--;
    } else {
      _items.remove(sku);
    }
    notifyListeners();
  }

  void removeItem(String sku) {
    _items.remove(sku);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
