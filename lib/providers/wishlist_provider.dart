import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistItem {
  final String sku;
  final String name;
  final String price;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final bool isComingSoon;

  WishlistItem({
    required this.sku,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    this.isComingSoon = false,
  });

  Map<String, dynamic> toJson() => {
        'sku': sku,
        'name': name,
        'price': price,
        'imageUrl': imageUrl,
        'rating': rating,
        'reviewCount': reviewCount,
        'isComingSoon': isComingSoon,
      };

  factory WishlistItem.fromJson(Map<String, dynamic> json) => WishlistItem(
        sku: json['sku'] as String,
        name: json['name'] as String,
        price: json['price'] as String,
        imageUrl: json['imageUrl'] as String,
        rating: (json['rating'] as num).toDouble(),
        reviewCount: json['reviewCount'] as int,
        isComingSoon: json['isComingSoon'] as bool? ?? false,
      );
}

class WishlistProvider extends ChangeNotifier {
  static const _prefsKey = 'wishlist_items';

  final Map<String, WishlistItem> _items = {};

  List<WishlistItem> get items => _items.values.toList();

  bool contains(String sku) => _items.containsKey(sku);

  /// Load saved wishlist from SharedPreferences on app start
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      for (final entry in list) {
        final item = WishlistItem.fromJson(entry as Map<String, dynamic>);
        _items[item.sku] = item;
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _items.values.map((e) => e.toJson()).toList();
    await prefs.setString(_prefsKey, jsonEncode(list));
  }

  void toggle({
    required String sku,
    required String name,
    required String price,
    required String imageUrl,
    required double rating,
    required int reviewCount,
    bool isComingSoon = false,
  }) {
    if (_items.containsKey(sku)) {
      _items.remove(sku);
    } else {
      _items[sku] = WishlistItem(
        sku: sku,
        name: name,
        price: price,
        imageUrl: imageUrl,
        rating: rating,
        reviewCount: reviewCount,
        isComingSoon: isComingSoon,
      );
    }
    notifyListeners();
    _save();
  }

  void remove(String sku) {
    _items.remove(sku);
    notifyListeners();
    _save();
  }

  void clear() {
    _items.clear();
    notifyListeners();
    _save();
  }
}
