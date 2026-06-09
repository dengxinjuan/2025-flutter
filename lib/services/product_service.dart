import '../models/product.dart';
import 'supabase_service.dart';

/// Loads products from the Supabase `products` table.
///
/// The `products` table is publicly readable (RLS `products_public_read`),
/// so these queries work for guests and logged-in users alike — keeping the
/// app guest-first.
///
/// Each query returns legacy card maps (`List<Map<String, dynamic>>`) so the
/// existing card/detail widgets keep working without changes. Use
/// [productsByTag]/[productsByCategory] for `Product` objects if needed.
class ProductService {
  ProductService._();
  static final ProductService instance = ProductService._();

  static const _table = 'products';
  static const _columns =
      'sku, name, price, original_price, image_url, rating, review_count, '
      'is_coming_soon, is_sale, category, tags';

  // Home-page section tags.
  static const tagFeatured = 'featured';
  static const tagBestSeller = 'best_seller';
  static const tagNewArrival = 'new_arrival';
  static const tagTopRated = 'top_rated';
  static const tagSpecialOffer = 'special_offer';

  /// Fetch products carrying [tag], ordered by review count (most-reviewed
  /// first) — a sensible default for "featured / best sellers" style rows.
  Future<List<Product>> productsByTag(String tag) async {
    final rows = await SupabaseService.instance.client
        .from(_table)
        .select(_columns)
        .contains('tags', [tag])
        .order('review_count', ascending: false);
    return (rows as List)
        .map((r) => Product.fromMap(r as Map<String, dynamic>))
        .toList();
  }

  /// Fetch every product in [category], ordered alphabetically by name.
  Future<List<Product>> productsByCategory(String category) async {
    final rows = await SupabaseService.instance.client
        .from(_table)
        .select(_columns)
        .eq('category', category)
        .order('name', ascending: true);
    return (rows as List)
        .map((r) => Product.fromMap(r as Map<String, dynamic>))
        .toList();
  }

  /// Fetch all products (used by global search). Excludes sale variants
  /// (category `Offers`) so duplicates of the same item don't surface twice.
  Future<List<Product>> allProducts() async {
    final rows = await SupabaseService.instance.client
        .from(_table)
        .select(_columns)
        .neq('category', 'Offers')
        .order('name', ascending: true);
    return (rows as List)
        .map((r) => Product.fromMap(r as Map<String, dynamic>))
        .toList();
  }

  // ── Convenience wrappers returning legacy card maps ──────────────────────

  Future<List<Map<String, dynamic>>> _cardsByTag(String tag) async =>
      (await productsByTag(tag)).map((p) => p.toCardMap()).toList();

  Future<List<Map<String, dynamic>>> featured() => _cardsByTag(tagFeatured);
  Future<List<Map<String, dynamic>>> bestSellers() =>
      _cardsByTag(tagBestSeller);
  Future<List<Map<String, dynamic>>> newArrivals() =>
      _cardsByTag(tagNewArrival);
  Future<List<Map<String, dynamic>>> topRated() => _cardsByTag(tagTopRated);
  Future<List<Map<String, dynamic>>> specialOffers() =>
      _cardsByTag(tagSpecialOffer);

  Future<List<Map<String, dynamic>>> categoryCards(String category) async =>
      (await productsByCategory(category)).map((p) => p.toCardMap()).toList();

  Future<List<Map<String, dynamic>>> allCards() async =>
      (await allProducts()).map((p) => p.toCardMap()).toList();
}
