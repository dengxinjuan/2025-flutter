/// A product loaded from the Supabase `products` table.
///
/// The rest of the app (cards, product detail page, wishlist) was originally
/// built around plain `Map<String, dynamic>` records with string prices like
/// `"$37.99"`. To avoid rewriting every widget, [toCardMap] reproduces that
/// exact legacy shape, so a `Product` is a drop-in replacement for the old
/// hardcoded maps.
class Product {
  final String sku;
  final String name;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final bool isComingSoon;
  final bool isSale;
  final String category;
  final List<String> tags;

  const Product({
    required this.sku,
    required this.name,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.isComingSoon,
    required this.isSale,
    required this.category,
    required this.tags,
  });

  /// Builds a [Product] from a Supabase row.
  factory Product.fromMap(Map<String, dynamic> row) {
    return Product(
      sku: row['sku'] as String,
      name: row['name'] as String,
      price: (row['price'] as num).toDouble(),
      originalPrice: row['original_price'] == null
          ? null
          : (row['original_price'] as num).toDouble(),
      imageUrl: row['image_url'] as String,
      rating: (row['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: (row['review_count'] as num?)?.toInt() ?? 0,
      isComingSoon: row['is_coming_soon'] as bool? ?? false,
      isSale: row['is_sale'] as bool? ?? false,
      category: row['category'] as String? ?? '',
      tags: (row['tags'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
    );
  }

  static String formatPrice(double value) => '\$${value.toStringAsFixed(2)}';

  /// The legacy `Map<String, dynamic>` shape consumed by the existing UI
  /// widgets (product cards, ProductDetailPage navigation, etc.).
  Map<String, dynamic> toCardMap() {
    return {
      'name': name,
      'price': formatPrice(price),
      if (originalPrice != null) 'originalPrice': formatPrice(originalPrice!),
      'imageUrl': imageUrl,
      'rating': rating,
      'reviews': reviewCount,
      'sku': sku,
      'isComingSoon': isComingSoon,
      if (isSale) 'isSale': true,
    };
  }
}
