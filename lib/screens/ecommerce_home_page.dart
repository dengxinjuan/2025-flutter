import 'package:flutter/material.dart';

/// E-Commerce Home (unlogged) – replica of Figma design from screenshot.
/// Header (Mega Mall blue), search ("Search Product Name"), promo banner (Gatis Ongkir),
/// Categories with See All, Featured Product with See All, real product photos.
class EcommerceHomePage extends StatefulWidget {
  const EcommerceHomePage({super.key});

  @override
  State<EcommerceHomePage> createState() => _EcommerceHomePageState();
}

class _EcommerceHomePageState extends State<EcommerceHomePage> {
  int _selectedNavIndex = 0;

  // Categories from design: Foods, Gift, Fashion, Gadget, Comp (circular icons)
  static const List<Map<String, dynamic>> _categories = [
    {'label': 'Foods', 'icon': Icons.restaurant, 'color': Color(0xFF4CAF50)},
    {'label': 'Gift', 'icon': Icons.card_giftcard, 'color': Color(0xFFE91E63)},
    {'label': 'Fashion', 'icon': Icons.checkroom, 'color': Color(0xFFFFC107)},
    {'label': 'Gadget', 'icon': Icons.headphones, 'color': Color(0xFF9C27B0)},
    {'label': 'Comp', 'icon': Icons.computer, 'color': Color(0xFF4CAF50)},
  ];

  // Featured products: TMA-2 HD Wireless, real headphone photos
  static const List<Map<String, dynamic>> _featuredProducts = [
    {
      'name': 'TMA-2 HD Wireless',
      'price': 'Rp. 1.500.000',
      'imageUrl': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
    },
    {
      'name': 'TMA-2 HD Wireless',
      'price': 'Rp. 1.500.000',
      'imageUrl': 'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=400',
    },
    {
      'name': 'TMA-2 HD Wireless',
      'price': 'Rp. 1.500.000',
      'imageUrl': 'https://images.unsplash.com/photo-1546435770-a3e426bf472b?w=400',
    },
  ];

  // Promo banner: Gatis Ongkir / Selama PPKM! / Periode Mei - Agustus 2021
  static const String kBannerImageUrl =
      'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=800';

  // Best Sellers: more products with rating and options (matches screenshot)
  static const List<Map<String, dynamic>> _bestSellers = [
    {
      'name': 'TMA-2 HD Wireless',
      'price': 'Rp. 1.500.000',
      'imageUrl': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
      'rating': 4.6,
      'reviews': 86,
    },
    {
      'name': 'TMA-2 HD Wireless',
      'price': 'Rp. 1.500.000',
      'imageUrl': 'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=400',
      'rating': 4.6,
      'reviews': 86,
    },
    {
      'name': 'Cordless Drill Pro',
      'price': 'Rp. 899.000',
      'imageUrl': 'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=400',
      'rating': 4.8,
      'reviews': 124,
    },
    {
      'name': 'Wireless Earbuds',
      'price': 'Rp. 649.000',
      'imageUrl': 'https://images.unsplash.com/photo-1546435770-a3e426bf472b?w=400',
      'rating': 4.5,
      'reviews': 72,
    },
    {
      'name': 'Smart Watch Series',
      'price': 'Rp. 2.199.000',
      'imageUrl': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400',
      'rating': 4.7,
      'reviews': 203,
    },
    {
      'name': 'Bluetooth Speaker',
      'price': 'Rp. 449.000',
      'imageUrl': 'https://images.unsplash.com/photo-1545127398-14699f92334b?w=400',
      'rating': 4.4,
      'reviews': 58,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchBar(),
                    const SizedBox(height: 16),
                    _buildPromoBanner(),
                    const SizedBox(height: 24),
                    _buildSectionWithSeeAll('Categories'),
                    const SizedBox(height: 12),
                    _buildCategoriesRow(),
                    const SizedBox(height: 24),
                    _buildSectionWithSeeAll('Featured Product'),
                    const SizedBox(height: 12),
                    _buildFeaturedProductList(),
                    const SizedBox(height: 24),
                    _buildSectionWithSeeAll('Best Sellers'),
                    const SizedBox(height: 12),
                    _buildBestSellersList(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      color: Colors.white,
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Mega Mall',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2196F3),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined, color: Color(0xFF333333)),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart_outlined, color: Color(0xFF333333)),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: TextField(
          readOnly: true,
          onTap: () {},
          decoration: InputDecoration(
            hintText: 'Search Product Name',
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.search, color: Color(0xFF2196F3), size: 24),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                kBannerImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: const Color(0xFF2196F3)),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      const Color(0xFF2196F3).withOpacity(0.92),
                      const Color(0xFF2196F3).withOpacity(0.6),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Gatis Ongkir',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Selama PPKM!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Periode Mei - Agustus 2021',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionWithSeeAll(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'See All',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2196F3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesRow() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          return Container(
            width: 72,
            margin: EdgeInsets.only(right: index < _categories.length - 1 ? 14 : 0),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: (cat['color'] as Color).withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: (cat['color'] as Color).withOpacity(0.4)),
                  ),
                  child: Icon(
                    cat['icon'] as IconData,
                    color: cat['color'] as Color,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  cat['label'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedProductList() {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _featuredProducts.length,
        itemBuilder: (context, index) {
          final p = _featuredProducts[index];
          return Container(
            width: 160,
            margin: EdgeInsets.only(right: index < _featuredProducts.length - 1 ? 14 : 0),
            child: _ProductCard(
              name: p['name'] as String,
              price: p['price'] as String,
              imageUrl: p['imageUrl'] as String,
            ),
          );
        },
      ),
    );
  }

  Widget _buildBestSellersList() {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _bestSellers.length,
        itemBuilder: (context, index) {
          final p = _bestSellers[index];
          return Container(
            width: 168,
            margin: EdgeInsets.only(right: index < _bestSellers.length - 1 ? 14 : 0),
            child: _BestSellerCard(
              name: p['name'] as String,
              price: p['price'] as String,
              imageUrl: p['imageUrl'] as String,
              rating: (p['rating'] as num).toDouble(),
              reviewCount: p['reviews'] as int,
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNav() {
    const items = [
      (icon: Icons.home_outlined, label: 'HOME'),
      (icon: Icons.favorite_border, label: 'WISHLIST'),
      (icon: Icons.shopping_bag_outlined, label: 'ORDER'),
      (icon: Icons.person_outline, label: 'LOGIN'),
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 0.5)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final selected = _selectedNavIndex == index;
              return InkWell(
                onTap: () => setState(() => _selectedNavIndex = index),
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selected
                              ? const Color(0xFF2196F3).withOpacity(0.12)
                              : Colors.transparent,
                        ),
                        child: Icon(
                          item.icon,
                          size: 24,
                          color: selected
                              ? const Color(0xFF2196F3)
                              : const Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                          color: selected
                              ? const Color(0xFF2196F3)
                              : const Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _BestSellerCard extends StatelessWidget {
  final String name;
  final String price;
  final String imageUrl;
  final double rating;
  final int reviewCount;

  const _BestSellerCard({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
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
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey.shade100,
                        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      );
                    },
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported_outlined, size: 40, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_horiz, size: 22, color: Color(0xFF666666)),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.9),
                    padding: const EdgeInsets.all(6),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Color(0xFF1A1A1A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFFE53935),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 16, color: Color(0xFFFFC107)),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$reviewCount Reviews',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
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

class _ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String imageUrl;

  const _ProductCard({
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey.shade100,
                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  );
                },
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported_outlined, size: 40, color: Colors.grey),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Color(0xFF1A1A1A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFFE53935),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
