import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wishlist_provider.dart';
import '../providers/cart_provider.dart';
import 'product_detail_page.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  static const _navy = Color(0xFF0C1A30);
  static const _blue = Color(0xFF3669C9);
  static const _red = Color(0xFFFE3A30);
  static const _bg = Color(0xFFFAFAFA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Consumer<WishlistProvider>(
                builder: (context, wishlist, _) {
                  if (wishlist.items.isEmpty) return _buildEmptyState();
                  return _buildGrid(context, wishlist);
                },
              ),
            ),
            Consumer<WishlistProvider>(
              builder: (context, wishlist, _) {
                if (wishlist.items.isEmpty) return const SizedBox.shrink();
                return _buildAddAllBar(context, wishlist);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 55,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.chevron_left, size: 28, color: _navy),
            ),
          ),
          const Text(
            'My Wishlist',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _navy),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Consumer<WishlistProvider>(
              builder: (context, wishlist, _) => wishlist.items.isEmpty
                  ? const SizedBox(width: 48)
                  : TextButton(
                      onPressed: () => _confirmClear(context, wishlist),
                      child: const Text('Clear',
                          style: TextStyle(color: _red, fontSize: 13)),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'Your wishlist is empty',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: _navy),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the heart on any product to save it',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context, WishlistProvider wishlist) {
    final items = wishlist.items;
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.68,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailPage(
                name: item.name,
                price: item.price,
                imageUrl: item.imageUrl,
                rating: item.rating,
                reviewCount: item.reviewCount,
                sku: item.sku,
                isComingSoon: item.isComingSoon,
              ),
            ),
          ),
          child: _WishlistCard(item: item),
        );
      },
    );
  }

  Widget _buildAddAllBar(BuildContext context, WishlistProvider wishlist) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: () {
            final cart = context.read<CartProvider>();
            for (final item in wishlist.items) {
              cart.addItem(
                sku: item.sku,
                name: item.name,
                price: item.price,
                imageUrl: item.imageUrl,
              );
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${wishlist.items.length} item${wishlist.items.length == 1 ? '' : 's'} added to cart'),
                backgroundColor: _blue,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _blue,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          icon: const Icon(Icons.shopping_cart_outlined, size: 18, color: Colors.white),
          label: const Text(
            'Add All to Cart',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _confirmClear(BuildContext context, WishlistProvider wishlist) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear wishlist?'),
        content: const Text('All saved items will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              wishlist.clear();
              Navigator.pop(context);
            },
            child: const Text('Clear', style: TextStyle(color: _red)),
          ),
        ],
      ),
    );
  }
}

class _WishlistCard extends StatelessWidget {
  final WishlistItem item;

  const _WishlistCard({required this.item});

  static const _navy = Color(0xFF0C1A30);
  static const _red = Color(0xFFFE3A30);

  @override
  Widget build(BuildContext context) {
    final wishlist = context.read<WishlistProvider>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade100,
                      child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: GestureDetector(
                  onTap: () => wishlist.remove(item.sku),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite, size: 18, color: _red),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _navy),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item.price,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _red),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 13, color: Color(0xFFFFC107)),
                    const SizedBox(width: 3),
                    Text(
                      item.rating.toStringAsFixed(1),
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
