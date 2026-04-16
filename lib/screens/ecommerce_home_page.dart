import 'package:flutter/material.dart';
import 'product_detail_page.dart';
import 'category_products_page.dart';

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

  // Featured products: Crocs collection
  static const List<Map<String, dynamic>> _featuredProducts = [
    {
      'name': 'Crocs Classic Clog',
      'price': 'Rp. 599.000',
      'imageUrl': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
      'rating': 4.8,
      'reviews': 312,
      'sku': 'classic_clog',
      'isComingSoon': false,
    },
    {
      'name': 'Crocs Pink Edition',
      'price': 'Rp. 699.000',
      'imageUrl': 'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=400',
      'rating': 4.9,
      'reviews': 0,
      'sku': 'pink_clogs',
      'isComingSoon': true,
    },
    {
      'name': 'Crocs Literide Pacer',
      'price': 'Rp. 899.000',
      'imageUrl': 'https://images.unsplash.com/photo-1491553895911-0055eca6402d?w=400',
      'rating': 4.7,
      'reviews': 245,
      'sku': 'literide_pacer',
      'isComingSoon': false,
    },
    {
      'name': 'Crocs Bayaband Clog',
      'price': 'Rp. 549.000',
      'imageUrl': 'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?w=400',
      'rating': 4.6,
      'reviews': 198,
      'sku': 'bayaband_clog',
      'isComingSoon': false,
    },
    {
      'name': 'Crocs Bistro Clog',
      'price': 'Rp. 749.000',
      'imageUrl': 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=400',
      'rating': 4.5,
      'reviews': 134,
      'sku': 'bistro_clog',
      'isComingSoon': false,
    },
  ];

  // Promo banner: Gatis Ongkir / Selama PPKM! / Periode Mei - Agustus 2021
  static const String kBannerImageUrl =
      'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=800';

  // Best Sellers: Crocs products
  static const List<Map<String, dynamic>> _bestSellers = [
    {
      'name': 'Crocs Classic Clog',
      'price': 'Rp. 599.000',
      'imageUrl': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
      'rating': 4.8,
      'reviews': 312,
      'sku': 'classic_clog',
      'isComingSoon': false,
    },
    {
      'name': 'Crocs Pink Edition',
      'price': 'Rp. 699.000',
      'imageUrl': 'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=400',
      'rating': 4.9,
      'reviews': 0,
      'sku': 'pink_clogs',
      'isComingSoon': true,
    },
    {
      'name': 'Crocs Literide Pacer',
      'price': 'Rp. 899.000',
      'imageUrl': 'https://images.unsplash.com/photo-1491553895911-0055eca6402d?w=400',
      'rating': 4.7,
      'reviews': 245,
      'sku': 'literide_pacer',
      'isComingSoon': false,
    },
    {
      'name': 'Crocs Baya Sandal',
      'price': 'Rp. 449.000',
      'imageUrl': 'https://images.unsplash.com/photo-1515955656352-a1fa3ffcd111?w=400',
      'rating': 4.5,
      'reviews': 167,
      'sku': 'baya_sandal',
      'isComingSoon': false,
    },
    {
      'name': 'Crocs Blue Clogs',
      'price': 'Rp. 649.000',
      'imageUrl': 'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=400',
      'rating': 4.7,
      'reviews': 0,
      'sku': 'blue_clogs',
      'isComingSoon': true,
    },
    {
      'name': 'Crocs Kids Classic',
      'price': 'Rp. 349.000',
      'imageUrl': 'https://images.unsplash.com/photo-1582588678413-dbf45f4823e9?w=400',
      'rating': 4.8,
      'reviews': 289,
      'sku': 'kids_classic',
      'isComingSoon': false,
    },
    {
      'name': 'Crocs Classic Tie-Dye',
      'price': 'Rp. 799.000',
      'imageUrl': 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=400',
      'rating': 4.7,
      'reviews': 201,
      'sku': 'tiedye_clog',
      'isComingSoon': false,
    },
    {
      'name': 'Crocs Reviva Sandal',
      'price': 'Rp. 499.000',
      'imageUrl': 'https://images.unsplash.com/photo-1603487742131-4160ec999306?w=400',
      'rating': 4.5,
      'reviews': 112,
      'sku': 'reviva_sandal',
      'isComingSoon': false,
    },
  ];

  // New Arrivals: latest Crocs products
  static const List<Map<String, dynamic>> _newArrivals = [
    {
      'name': 'Crocs Echo Clog',
      'price': 'Rp. 899.000',
      'imageUrl': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
      'rating': 4.8,
      'reviews': 54,
      'sku': 'echo_clog',
      'isComingSoon': false,
    },
    {
      'name': 'Crocs Neo Puff Clog',
      'price': 'Rp. 1.299.000',
      'imageUrl': 'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=400',
      'rating': 4.9,
      'reviews': 28,
      'sku': 'neo_puff_clog',
      'isComingSoon': false,
    },
    {
      'name': 'Crocs Getaway Flip',
      'price': 'Rp. 449.000',
      'imageUrl': 'https://images.unsplash.com/photo-1523779105320-d1cd346ff52b?w=400',
      'rating': 4.6,
      'reviews': 73,
      'sku': 'getaway_flip',
      'isComingSoon': false,
    },
    {
      'name': 'Crocs Blue Clogs',
      'price': 'Rp. 649.000',
      'imageUrl': 'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=400',
      'rating': 4.7,
      'reviews': 0,
      'sku': 'blue_clogs',
      'isComingSoon': true,
    },
  ];

  // Top Rated: highest rated Crocs products
  static const List<Map<String, dynamic>> _topRated = [
    {
      'name': 'Crocs Literide 360',
      'price': 'Rp. 999.000',
      'imageUrl': 'https://images.unsplash.com/photo-1491553895911-0055eca6402d?w=400',
      'rating': 4.9,
      'reviews': 501,
      'sku': 'literide_360',
      'isComingSoon': false,
    },
    {
      'name': 'Crocs Classic Lined',
      'price': 'Rp. 799.000',
      'imageUrl': 'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?w=400',
      'rating': 4.8,
      'reviews': 378,
      'sku': 'classic_lined',
      'isComingSoon': false,
    },
    {
      'name': 'Crocs Crocband Clog',
      'price': 'Rp. 549.000',
      'imageUrl': 'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=400',
      'rating': 4.7,
      'reviews': 422,
      'sku': 'crocband_clog',
      'isComingSoon': false,
    },
    {
      'name': 'Crocs Classic Clog',
      'price': 'Rp. 599.000',
      'imageUrl': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
      'rating': 4.8,
      'reviews': 312,
      'sku': 'classic_clog',
      'isComingSoon': false,
    },
  ];

  // Special Offers: discounted Crocs products
  static const List<Map<String, dynamic>> _specialOffers = [
    {
      'name': 'Crocs Classic Clog',
      'price': 'Rp. 449.000',
      'originalPrice': 'Rp. 599.000',
      'imageUrl': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
      'rating': 4.8,
      'reviews': 312,
      'sku': 'classic_clog_sale',
      'isComingSoon': false,
      'isSale': true,
    },
    {
      'name': 'Crocs Baya Sandal',
      'price': 'Rp. 299.000',
      'originalPrice': 'Rp. 449.000',
      'imageUrl': 'https://images.unsplash.com/photo-1515955656352-a1fa3ffcd111?w=400',
      'rating': 4.5,
      'reviews': 167,
      'sku': 'baya_sandal_sale',
      'isComingSoon': false,
      'isSale': true,
    },
    {
      'name': 'Crocs Crocband Flip',
      'price': 'Rp. 349.000',
      'originalPrice': 'Rp. 499.000',
      'imageUrl': 'https://images.unsplash.com/photo-1523779105320-d1cd346ff52b?w=400',
      'rating': 4.6,
      'reviews': 89,
      'sku': 'crocband_flip_sale',
      'isComingSoon': false,
      'isSale': true,
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
                    const SizedBox(height: 24),
                    _buildSectionWithSeeAll('New Arrivals'),
                    const SizedBox(height: 12),
                    _buildProductSection(_newArrivals),
                    const SizedBox(height: 24),
                    _buildSectionWithSeeAll('Top Rated Product'),
                    const SizedBox(height: 12),
                    _buildProductSection(_topRated),
                    const SizedBox(height: 24),
                    _buildSectionWithSeeAll('Special Offers'),
                    const SizedBox(height: 12),
                    _buildSpecialOffersList(),
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
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CategoryProductsPage(
                  categoryName: cat['label'] as String,
                ),
              ),
            ),
            child: Container(
              width: 72,
              margin: EdgeInsets.only(right: index < _categories.length - 1 ? 14 : 0),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: (cat['color'] as Color).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: (cat['color'] as Color).withValues(alpha: 0.4)),
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
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailPage(
                  name: p['name'] as String,
                  price: p['price'] as String,
                  imageUrl: p['imageUrl'] as String,
                  rating: (p['rating'] as num).toDouble(),
                  reviewCount: p['reviews'] as int,
                  sku: p['sku'] as String? ?? '',
                  isComingSoon: p['isComingSoon'] as bool? ?? false,
                ),
              ),
            ),
            child: Container(
              width: 160,
              margin: EdgeInsets.only(right: index < _featuredProducts.length - 1 ? 14 : 0),
              child: _ProductCard(
                name: p['name'] as String,
                price: p['price'] as String,
                imageUrl: p['imageUrl'] as String,
                isComingSoon: p['isComingSoon'] as bool? ?? false,
              ),
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
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailPage(
                  name: p['name'] as String,
                  price: p['price'] as String,
                  imageUrl: p['imageUrl'] as String,
                  rating: (p['rating'] as num).toDouble(),
                  reviewCount: p['reviews'] as int,
                  sku: p['sku'] as String? ?? '',
                  isComingSoon: p['isComingSoon'] as bool? ?? false,
                ),
              ),
            ),
            child: Container(
              width: 168,
              margin: EdgeInsets.only(right: index < _bestSellers.length - 1 ? 14 : 0),
              child: _BestSellerCard(
                name: p['name'] as String,
                price: p['price'] as String,
                imageUrl: p['imageUrl'] as String,
                rating: (p['rating'] as num).toDouble(),
                reviewCount: p['reviews'] as int,
                isComingSoon: p['isComingSoon'] as bool? ?? false,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductSection(List<Map<String, dynamic>> products) {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final p = products[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailPage(
                  name: p['name'] as String,
                  price: p['price'] as String,
                  imageUrl: p['imageUrl'] as String,
                  rating: (p['rating'] as num).toDouble(),
                  reviewCount: p['reviews'] as int,
                  sku: p['sku'] as String? ?? '',
                  isComingSoon: p['isComingSoon'] as bool? ?? false,
                ),
              ),
            ),
            child: Container(
              width: 168,
              margin: EdgeInsets.only(right: index < products.length - 1 ? 14 : 0),
              child: _BestSellerCard(
                name: p['name'] as String,
                price: p['price'] as String,
                imageUrl: p['imageUrl'] as String,
                rating: (p['rating'] as num).toDouble(),
                reviewCount: p['reviews'] as int,
                isComingSoon: p['isComingSoon'] as bool? ?? false,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSpecialOffersList() {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _specialOffers.length,
        itemBuilder: (context, index) {
          final p = _specialOffers[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailPage(
                  name: p['name'] as String,
                  price: p['price'] as String,
                  imageUrl: p['imageUrl'] as String,
                  rating: (p['rating'] as num).toDouble(),
                  reviewCount: p['reviews'] as int,
                  sku: p['sku'] as String? ?? '',
                  isComingSoon: false,
                ),
              ),
            ),
            child: Container(
              width: 168,
              margin: EdgeInsets.only(right: index < _specialOffers.length - 1 ? 14 : 0),
              child: _BestSellerCard(
                name: p['name'] as String,
                price: p['price'] as String,
                imageUrl: p['imageUrl'] as String,
                rating: (p['rating'] as num).toDouble(),
                reviewCount: p['reviews'] as int,
                isSale: true,
                originalPrice: p['originalPrice'] as String?,
              ),
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
  final bool isComingSoon;
  final bool isSale;
  final String? originalPrice;

  const _BestSellerCard({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    this.isComingSoon = false,
    this.isSale = false,
    this.originalPrice,
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
              if (isComingSoon)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE65100),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Coming Soon',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              if (isSale)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFE3A30),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'SALE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
                    color: Color(0xFFFE3A30),
                  ),
                ),
                if (isSale && originalPrice != null)
                  Text(
                    originalPrice!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                      color: Color(0xFFC4C5C4),
                      decoration: TextDecoration.lineThrough,
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
  final bool isComingSoon;

  const _ProductCard({
    required this.name,
    required this.price,
    required this.imageUrl,
    this.isComingSoon = false,
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
              if (isComingSoon)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE65100),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Coming Soon',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
