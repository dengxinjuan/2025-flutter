import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/supabase_service.dart';

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

/// Guest-first wishlist:
/// - Guests: persisted locally via SharedPreferences only.
/// - Logged-in users: also synced to Supabase `wishlists` (guest items are
///   pushed up on sign-in, then cloud items merged back).
class WishlistProvider extends ChangeNotifier {
  static const _prefsKey = 'wishlist_items';

  final Map<String, WishlistItem> _items = {};
  String? _userId;

  /// Resolves once the initial local load from SharedPreferences completes.
  late final Future<void> _localLoaded;

  WishlistProvider() {
    _localLoaded = load();
  }

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

  /// Called by the auth-driven proxy in main.dart. On sign-in, merges the local
  /// wishlist into Supabase and pulls the cloud copy back. On sign-out, keeps
  /// the current items on-device but stops syncing.
  Future<void> setUser(String? userId) async {
    if (_userId == userId) return;
    _userId = userId;
    if (userId == null) return; // signed out → stay local-only
    await _localLoaded;
    await _pushLocalToCloud();
    await _loadFromCloud();
  }

  Map<String, dynamic> _toRow(WishlistItem e) => {
        'user_id': _userId,
        'sku': e.sku,
        'name': e.name,
        'price': e.price,
        'image_url': e.imageUrl,
        'rating': e.rating,
        'review_count': e.reviewCount,
        'is_coming_soon': e.isComingSoon,
      };

  Future<void> _pushLocalToCloud() async {
    if (_userId == null || _items.isEmpty) return;
    try {
      await SupabaseService.instance.client.from('wishlists').upsert(
            _items.values.map(_toRow).toList(),
            onConflict: 'user_id,sku',
          );
    } catch (_) {}
  }

  Future<void> _loadFromCloud() async {
    if (_userId == null) return;
    try {
      final rows = await SupabaseService.instance.client
          .from('wishlists')
          .select()
          .eq('user_id', _userId!);
      for (final r in rows) {
        final item = WishlistItem(
          sku: r['sku'] as String,
          name: r['name'] as String,
          price: r['price'] as String,
          imageUrl: r['image_url'] as String,
          rating: (r['rating'] as num).toDouble(),
          reviewCount: r['review_count'] as int,
          isComingSoon: r['is_coming_soon'] as bool? ?? false,
        );
        _items[item.sku] = item;
      }
      notifyListeners();
      await _save();
    } catch (_) {}
  }

  Future<void> _upsertToCloud(WishlistItem item) async {
    if (_userId == null) return;
    try {
      await SupabaseService.instance.client
          .from('wishlists')
          .upsert(_toRow(item), onConflict: 'user_id,sku');
    } catch (_) {}
  }

  Future<void> _deleteFromCloud(String sku) async {
    if (_userId == null) return;
    try {
      await SupabaseService.instance.client
          .from('wishlists')
          .delete()
          .eq('user_id', _userId!)
          .eq('sku', sku);
    } catch (_) {}
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
      _deleteFromCloud(sku);
    } else {
      final item = WishlistItem(
        sku: sku,
        name: name,
        price: price,
        imageUrl: imageUrl,
        rating: rating,
        reviewCount: reviewCount,
        isComingSoon: isComingSoon,
      );
      _items[sku] = item;
      _upsertToCloud(item);
    }
    notifyListeners();
    _save();
  }

  void remove(String sku) {
    _items.remove(sku);
    _deleteFromCloud(sku);
    notifyListeners();
    _save();
  }

  void clear() {
    _items.clear();
    notifyListeners();
    _save();
    if (_userId != null) {
      try {
        SupabaseService.instance.client
            .from('wishlists')
            .delete()
            .eq('user_id', _userId!);
      } catch (_) {}
    }
  }
}
