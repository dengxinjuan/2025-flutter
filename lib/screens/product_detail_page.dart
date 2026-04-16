import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/cart_provider.dart';
import 'cart_page.dart';

class ProductDetailPage extends StatefulWidget {
  final String name;
  final String price;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final bool isComingSoon;
  final String sku;

  const ProductDetailPage({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    this.isComingSoon = false,
    this.sku = '',
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool _isWishlisted = false;
  bool _notifyRequested = false;
  bool _notifyLoading = false;

  static const _navyBlack = Color(0xFF0C1A30);
  static const _blueOcean = Color(0xFF3669C9);
  static const _redVelvet = Color(0xFFFE3A30);
  static const _offGrey = Color(0xFFFAFAFA);
  static const _darkGrey = Color(0xFF838589);
  static const _earthGreen = Color(0xFF3A9B7A);
  static const _labelGreen = Color(0xFFEEFAF6);

  static const _crocs = [
    {
      'name': 'Crocs Classic Clog',
      'price': '\$37.99',
      'imageUrl': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
      'rating': 4.8,
      'reviews': 312,
    },
    {
      'name': 'Crocs Bayaband Clog',
      'price': '\$40.99',
      'imageUrl': 'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=400',
      'rating': 4.6,
      'reviews': 198,
    },
    {
      'name': 'Crocs Literide Pacer',
      'price': '\$55.99',
      'imageUrl': 'https://images.unsplash.com/photo-1491553895911-0055eca6402d?w=400',
      'rating': 4.7,
      'reviews': 245,
    },
  ];

  static const _reviews = [
    {
      'name': 'Sarah Johnson',
      'date': '2 weeks ago',
      'rating': 5,
      'avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
      'comment': 'Absolutely love these Crocs! Super comfortable for all-day wear. The material is lightweight and my feet never hurt.',
    },
    {
      'name': 'Michael Chen',
      'date': '1 month ago',
      'rating': 4,
      'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
      'comment': 'Great quality and very comfortable. Runs true to size. Would definitely recommend to anyone looking for casual everyday footwear.',
    },
    {
      'name': 'Emma Davis',
      'date': '2 months ago',
      'rating': 5,
      'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
      'comment': 'Best purchase this year! The ventilation holes keep my feet cool and the classic design goes with everything.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildStatusBarAndHeader(context)),
              SliverToBoxAdapter(child: _buildImageSection()),
              SliverToBoxAdapter(child: _buildProductInfo()),
              SliverToBoxAdapter(child: _buildDivider()),
              SliverToBoxAdapter(child: _buildShopRow()),
              SliverToBoxAdapter(child: _buildDivider()),
              SliverToBoxAdapter(child: _buildDescription()),
              SliverToBoxAdapter(child: _buildDivider()),
              SliverToBoxAdapter(child: _buildReviewsSection()),
              SliverToBoxAdapter(child: _buildFeaturedProducts()),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBarAndHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 55,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios, size: 20, color: _navyBlack),
              ),
              const Expanded(
                child: Text(
                  'Detail Product',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.refresh, size: 20, color: _navyBlack),
              ),
              Consumer<CartProvider>(
                builder: (context, cart, _) => Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CartPage()),
                      ),
                      icon: const Icon(Icons.shopping_cart_outlined, size: 20, color: _navyBlack),
                    ),
                    if (cart.itemCount > 0)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFE3A30),
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                          child: Text(
                            cart.itemCount > 99 ? '99+' : '${cart.itemCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
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

  Widget _buildImageSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(25, 16, 25, 0),
      height: 300,
      decoration: BoxDecoration(
        color: _offGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              widget.imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: _offGrey,
                child: const Icon(Icons.image_not_supported_outlined, size: 60, color: Colors.grey),
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 15,
            child: Text(
              '1/5 Photos',
              style: TextStyle(
                fontSize: 14,
                color: _navyBlack.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 16, 25, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _navyBlack,
              height: 1.33,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.price,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: _redVelvet,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFC107)),
              const SizedBox(width: 4),
              Text(
                widget.rating.toString(),
                style: const TextStyle(fontSize: 14, color: _navyBlack),
              ),
              const SizedBox(width: 10),
              Text(
                '${widget.reviewCount} Reviews',
                style: const TextStyle(fontSize: 14, color: _navyBlack),
              ),
              const Spacer(),
              widget.isComingSoon
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Coming Soon',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFE65100),
                        ),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: _labelGreen,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Available : 150',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _earthGreen,
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Divider(height: 1, color: Color(0xFFEDEDED)),
    );
  }

  Widget _buildShopRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.network(
              'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=100',
              width: 45,
              height: 45,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 45,
                height: 45,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFEDEDED)),
                child: const Icon(Icons.store, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Crocs Official Store',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _navyBlack,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text(
                      'Official Store',
                      style: TextStyle(fontSize: 12, color: _navyBlack),
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.verified, size: 16, color: _blueOcean),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: _navyBlack),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 16, 25, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description Product',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _navyBlack,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'The Crocs Classic Clog is the iconic shoe that started it all. Made with Croslite™ foam — a proprietary closed-cell resin material — these shoes are soft, comfortable, and lightweight. The ventilation holes offer breathability and help shed water and debris.',
            style: TextStyle(fontSize: 14, color: _navyBlack, height: 1.57),
          ),
          const SizedBox(height: 12),
          const Text(
            'Fully molded Croslite™ foam construction makes them buoyant, soft, and comfortable. Easy to clean — simply rinse with water. Pivoting heel straps provide a more secure fit. Available in a wide range of sizes and colors for the whole family.',
            style: TextStyle(fontSize: 14, color: _navyBlack, height: 1.57),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 16, 25, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Review (${widget.reviewCount})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _navyBlack,
                ),
              ),
              const Spacer(),
              const Icon(Icons.star_rounded, size: 16, color: Color(0xFFFFC107)),
              const SizedBox(width: 4),
              Text(
                widget.rating.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: _navyBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ..._reviews.map((r) => _buildReviewItem(r)),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: _navyBlack),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'See All Review',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _navyBlack,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> review) {
    final rating = review['rating'] as int;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  review['avatar'] as String,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFEDEDED)),
                    child: const Icon(Icons.person, color: Colors.grey, size: 20),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          review['name'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _navyBlack,
                          ),
                        ),
                        Text(
                          review['date'] as String,
                          style: const TextStyle(fontSize: 12, color: _darkGrey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: List.generate(5, (i) => Icon(
                        i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                        size: 14,
                        color: i < rating ? const Color(0xFFFFC107) : const Color(0xFFEDEDED),
                      )),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review['comment'] as String,
            style: const TextStyle(
              fontSize: 12,
              color: _navyBlack,
              height: 1.67,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: _offGrey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 16, 25, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Featured Product',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: _navyBlack,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _blueOcean,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  itemCount: _crocs.length,
                  itemBuilder: (context, index) {
                    final p = _crocs[index];
                    return Container(
                      width: 156,
                      margin: EdgeInsets.only(right: index < _crocs.length - 1 ? 15 : 0),
                      child: _FeaturedCard(
                        name: p['name'] as String,
                        price: p['price'] as String,
                        imageUrl: p['imageUrl'] as String,
                        rating: (p['rating'] as num).toDouble(),
                        reviews: p['reviews'] as int,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleNotifyMe() async {
    setState(() => _notifyLoading = true);
    final sku = widget.sku.isNotEmpty ? widget.sku : widget.name.toLowerCase().replaceAll(' ', '_');

    // Ensure user has a stable external_id — generate once and persist it
    final prefs = await SharedPreferences.getInstance();
    String? persistedId = prefs.getString('onesignal_external_id');
    if (persistedId == null || persistedId.isEmpty) {
      persistedId = 'user_${DateTime.now().millisecondsSinceEpoch}';
      await prefs.setString('onesignal_external_id', persistedId);
    }
    final existingId = await OneSignal.User.getExternalId();
    if (existingId != persistedId) {
      await OneSignal.login(persistedId);
      print('🔑 [Auth] Logged in as: $persistedId');
    }

    await OneSignal.User.addTags({
      'availability': 'notify_me_requested',
      'product_name': sku,
    });
    try {
      await OneSignal.User.trackEvent('notify_me_requested', {'sku': sku});
      print('✅ [trackEvent] notify_me_requested fired, sku=$sku');
    } catch (e) {
      print('❌ [trackEvent] failed: $e');
    }
    setState(() {
      _notifyRequested = true;
      _notifyLoading = false;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("You're on the list! We'll let you know when ${widget.name} is back in stock."),
          backgroundColor: _earthGreen,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  Widget _buildBottomBar() {
    if (widget.isComingSoon) {
      return SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
          color: Colors.white,
          child: GestureDetector(
            onTap: _notifyRequested || _notifyLoading ? null : _handleNotifyMe,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: _notifyRequested ? _earthGreen : _blueOcean,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: _notifyLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _notifyRequested ? Icons.check_circle_outline : Icons.notifications_outlined,
                            size: 18,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _notifyRequested ? "You're on the list!" : 'Notify Me When Available',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      );
    }

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isWishlisted = !_isWishlisted),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: _isWishlisted ? _redVelvet : Colors.white,
                    border: Border.all(color: _isWishlisted ? _redVelvet : _navyBlack),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isWishlisted ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: _isWishlisted ? Colors.white : _navyBlack,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isWishlisted ? 'Wishlisted' : 'Wishlist',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: _isWishlisted ? Colors.white : _navyBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  context.read<CartProvider>().addItem(
                    sku: widget.sku.isNotEmpty ? widget.sku : widget.name,
                    name: widget.name,
                    price: widget.price,
                    imageUrl: widget.imageUrl,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${widget.name} added to cart'),
                      backgroundColor: _blueOcean,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: _blueOcean,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'Add to Cart',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final String name;
  final String price;
  final String imageUrl;
  final double rating;
  final int reviews;

  const _FeaturedCard({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: SizedBox(
              width: double.infinity,
              height: 130,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFFAFAFA),
                  child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0C1A30),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFE3A30),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 11, color: Color(0xFFFFC107)),
                    const SizedBox(width: 3),
                    Text(
                      rating.toString(),
                      style: const TextStyle(fontSize: 10, color: Color(0xFF0C1A30)),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$reviews Reviews',
                      style: const TextStyle(fontSize: 10, color: Color(0xFF0C1A30)),
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
