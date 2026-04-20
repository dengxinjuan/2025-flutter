import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Review {
  final String id;
  final String reviewerName;
  final int rating;
  final String comment;
  final String date;

  Review({
    required this.id,
    required this.reviewerName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'reviewerName': reviewerName,
        'rating': rating,
        'comment': comment,
        'date': date,
      };

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json['id'] as String,
        reviewerName: json['reviewerName'] as String,
        rating: json['rating'] as int,
        comment: json['comment'] as String,
        date: json['date'] as String,
      );
}

class ReviewProvider extends ChangeNotifier {
  static const _prefsKey = 'reviews_v1';
  final Map<String, List<Review>> _reviewsBySku = {};

  List<Review> getReviews(String sku) =>
      List.unmodifiable(_reviewsBySku[sku] ?? []);

  double getAverageRating(String sku) {
    final reviews = _reviewsBySku[sku];
    if (reviews == null || reviews.isEmpty) return 0;
    return reviews.map((r) => r.rating).reduce((a, b) => a + b) /
        reviews.length;
  }

  int getCount(String sku) => (_reviewsBySku[sku] ?? []).length;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      for (final entry in map.entries) {
        _reviewsBySku[entry.key] = (entry.value as List<dynamic>)
            .map((e) => Review.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final map = _reviewsBySku.map(
      (sku, reviews) =>
          MapEntry(sku, reviews.map((r) => r.toJson()).toList()),
    );
    await prefs.setString(_prefsKey, jsonEncode(map));
  }

  void seedIfEmpty(String sku, List<Review> seeds) {
    if (_reviewsBySku.containsKey(sku)) return;
    _reviewsBySku[sku] = List.of(seeds);
    notifyListeners();
    _save();
  }

  void addReview(String sku, Review review) {
    _reviewsBySku.putIfAbsent(sku, () => []);
    _reviewsBySku[sku]!.insert(0, review);
    notifyListeners();
    _save();
  }
}
