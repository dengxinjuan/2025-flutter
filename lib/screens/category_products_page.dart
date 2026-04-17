import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wishlist_provider.dart';
import 'product_detail_page.dart';

// Products mapped to each category
const Map<String, List<Map<String, dynamic>>> _categoryProducts = {
  // ── FASHION ── All Crocs footwear + fashion accessories ──────────────────
  'Fashion': [
    {
      'name': 'Crocs Classic Clog',
      'price': '\$37.99',
      'imageUrl': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
      'rating': 4.8,
      'reviews': 312,
      'sku': 'classic_clog',
      'isComingSoon': false,
    },
    {
      'name': 'Crocs Pink Edition',
      'price': '\$43.99',
      'imageUrl': 'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=400',
      'rating': 4.9,
      'reviews': 0,
      'sku': 'pink_clogs',
      'isComingSoon': true,
    },
    {
      'name': 'Crocs Classic Tie-Dye',
      'price': '\$49.99',
      'imageUrl': 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=400',
      'rating': 4.7,
      'reviews': 201,
      'sku': 'tiedye_clog',
      'isComingSoon': false,
    },
    {
      'name': 'Crocs Bayaband Clog',
      'price': '\$34.99',
      'imageUrl': 'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?w=400',
      'rating': 4.6,
      'reviews': 198,
      'sku': 'bayaband_clog',
      'isComingSoon': false,
    },
    {
      'name': 'Crocs Bistro Clog',
      'price': '\$46.99',
      'imageUrl': 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=400',
      'rating': 4.5,
      'reviews': 134,
      'sku': 'bistro_clog',
      'isComingSoon': false,
    },
    {
      'name': 'Crocs Literide Pacer',
      'price': '\$55.99',
      'imageUrl': 'https://images.unsplash.com/photo-1491553895911-0055eca6402d?w=400',
      'rating': 4.7,
      'reviews': 245,
      'sku': 'literide_pacer',
      'isComingSoon': false,
    },
    {
      'name': 'Crocs Literide 360',
      'price': '\$62.99',
      'imageUrl': 'https://images.unsplash.com/photo-1491553895911-0055eca6402d?w=400',
      'rating': 4.9,
      'reviews': 501,
      'sku': 'literide_360',
      'isComingSoon': false,
    },
    {
      'name': 'Crocs Echo Clog',
      'price': '\$55.99',
      'imageUrl': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
      'rating': 4.8,
      'reviews': 54,
      'sku': 'echo_clog',
      'isComingSoon': false,
    },
    {
      'name': 'Crocs Reviva Sandal',
      'price': '\$31.99',
      'imageUrl': 'https://images.unsplash.com/photo-1515955656352-a1fa3ffcd111?w=400',
      'rating': 4.5,
      'reviews': 112,
      'sku': 'reviva_sandal',
      'isComingSoon': false,
    },
    {
      'name': 'Crocs Classic Lined',
      'price': '\$49.99',
      'imageUrl': 'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?w=400',
      'rating': 4.8,
      'reviews': 378,
      'sku': 'classic_lined',
      'isComingSoon': false,
    },
    {
      'name': 'Crocs Crocband Clog',
      'price': '\$34.99',
      'imageUrl': 'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=400',
      'rating': 4.7,
      'reviews': 422,
      'sku': 'crocband_clog',
      'isComingSoon': false,
    },
    {
      'name': 'Crocs Getaway Flip',
      'price': '\$27.99',
      'imageUrl': 'https://images.unsplash.com/photo-1523779105320-d1cd346ff52b?w=400',
      'rating': 4.6,
      'reviews': 73,
      'sku': 'getaway_flip',
      'isComingSoon': false,
    },
    {
      'name': 'Crocs Baya Sandal',
      'price': '\$27.99',
      'imageUrl': 'https://images.unsplash.com/photo-1515955656352-a1fa3ffcd111?w=400',
      'rating': 4.5,
      'reviews': 167,
      'sku': 'baya_sandal',
      'isComingSoon': false,
    },
    {
      'name': 'Crocs Classic Sandal',
      'price': '\$24.99',
      'imageUrl': 'https://images.unsplash.com/photo-1523779105320-d1cd346ff52b?w=400',
      'rating': 4.4,
      'reviews': 134,
      'sku': 'classic_sandal',
      'isComingSoon': false,
    },
    {
      'name': 'Crocs Swiftwater Sandal',
      'price': '\$34.99',
      'imageUrl': 'https://images.unsplash.com/photo-1603487742131-4160ec999306?w=400',
      'rating': 4.6,
      'reviews': 98,
      'sku': 'swiftwater_sandal',
      'isComingSoon': false,
    },
    {
      'name': 'Crocs Crocband Flip',
      'price': '\$24.99',
      'imageUrl': 'https://images.unsplash.com/photo-1515955656352-a1fa3ffcd111?w=400',
      'rating': 4.5,
      'reviews': 89,
      'sku': 'crocband_flip',
      'isComingSoon': false,
    },
    {
      'name': 'Crocs Blue Clogs',
      'price': '\$40.99',
      'imageUrl': 'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=400',
      'rating': 4.7,
      'reviews': 0,
      'sku': 'blue_clogs',
      'isComingSoon': true,
    },
    {
      'name': 'Crocs Neo Puff Clog',
      'price': '\$81.99',
      'imageUrl': 'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=400',
      'rating': 4.9,
      'reviews': 28,
      'sku': 'neo_puff_clog',
      'isComingSoon': false,
    },
    {
      'name': 'Crocs Kids Classic',
      'price': '\$21.99',
      'imageUrl': 'https://images.unsplash.com/photo-1582588678413-dbf45f4823e9?w=400',
      'rating': 4.8,
      'reviews': 289,
      'sku': 'kids_classic',
      'isComingSoon': false,
    },
    {
      'name': 'Leather Tote Bag',
      'price': '\$27.99',
      'imageUrl': 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400',
      'rating': 4.7,
      'reviews': 183,
      'sku': 'leather_tote',
      'isComingSoon': false,
    },
    {
      'name': 'Silk Scarf',
      'price': '\$11.99',
      'imageUrl': 'https://images.unsplash.com/photo-1601924994987-69e26d50dc26?w=400',
      'rating': 4.5,
      'reviews': 97,
      'sku': 'silk_scarf',
      'isComingSoon': false,
    },
    {
      'name': 'Sunglasses UV400',
      'price': '\$18.99',
      'imageUrl': 'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=400',
      'rating': 4.6,
      'reviews': 214,
      'sku': 'sunglasses_uv400',
      'isComingSoon': false,
    },
  ],

  // ── FOODS ── Food & beverage products only ────────────────────────────────
  'Foods': [
    {
      'name': 'Organic Apple Set',
      'price': '\$2.99',
      'imageUrl': 'https://images.unsplash.com/photo-1567306226416-28f0efdc88ce?w=400',
      'rating': 4.7,
      'reviews': 521,
      'sku': 'organic_apples',
      'isComingSoon': false,
    },
    {
      'name': 'Premium Coffee Beans',
      'price': '\$11.99',
      'imageUrl': 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=400',
      'rating': 4.9,
      'reviews': 743,
      'sku': 'coffee_beans',
      'isComingSoon': false,
    },
    {
      'name': 'Artisan Chocolate Box',
      'price': '\$7.99',
      'imageUrl': 'https://images.unsplash.com/photo-1549007994-cb92caebd54b?w=400',
      'rating': 4.8,
      'reviews': 398,
      'sku': 'chocolate_box',
      'isComingSoon': false,
    },
    {
      'name': 'Matcha Green Tea Set',
      'price': '\$5.99',
      'imageUrl': 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=400',
      'rating': 4.6,
      'reviews': 267,
      'sku': 'matcha_tea',
      'isComingSoon': false,
    },
    {
      'name': 'Fresh Fruit Basket',
      'price': '\$12.99',
      'imageUrl': 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=400',
      'rating': 4.8,
      'reviews': 184,
      'sku': 'fruit_basket',
      'isComingSoon': false,
    },
    {
      'name': 'Assorted Snack Box',
      'price': '\$9.99',
      'imageUrl': 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400',
      'rating': 4.5,
      'reviews': 312,
      'sku': 'snack_box',
      'isComingSoon': false,
    },
  ],

  // ── GIFT ── Gift-ready items only ─────────────────────────────────────────
  'Gift': [
    {
      'name': 'Crocs Gift Bundle',
      'price': '\$55.99',
      'imageUrl': 'https://images.unsplash.com/photo-1512909006721-3d6018887383?w=400',
      'rating': 4.9,
      'reviews': 87,
      'sku': 'gift_bundle',
      'isComingSoon': false,
    },
    {
      'name': 'Crocs Jibbitz 5-Pack',
      'price': '\$12.99',
      'imageUrl': 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=400',
      'rating': 4.7,
      'reviews': 156,
      'sku': 'jibbitz_pack',
      'isComingSoon': false,
    },
    {
      'name': 'Crocs Mini Charm Set',
      'price': '\$9.99',
      'imageUrl': 'https://images.unsplash.com/photo-1558769132-cb1aea458c5e?w=400',
      'rating': 4.6,
      'reviews': 203,
      'sku': 'mini_charm',
      'isComingSoon': false,
    },
    {
      'name': 'Luxury Gift Box',
      'price': '\$15.99',
      'imageUrl': 'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=400',
      'rating': 4.8,
      'reviews': 142,
      'sku': 'luxury_gift_box',
      'isComingSoon': false,
    },
    {
      'name': 'Scented Candle Set',
      'price': '\$10.99',
      'imageUrl': 'https://images.unsplash.com/photo-1602928321679-560bb453f190?w=400',
      'rating': 4.7,
      'reviews': 319,
      'sku': 'candle_set',
      'isComingSoon': false,
    },
    {
      'name': 'Fresh Flower Bouquet',
      'price': '\$21.99',
      'imageUrl': 'https://images.unsplash.com/photo-1487530811176-3780de880c2d?w=400',
      'rating': 4.9,
      'reviews': 88,
      'sku': 'flower_bouquet',
      'isComingSoon': false,
    },
  ],

  // ── GADGET ── Electronics & smart devices only ────────────────────────────
  'Gadget': [
    {
      'name': 'Wireless Earbuds Pro',
      'price': '\$55.99',
      'imageUrl': 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=400',
      'rating': 4.8,
      'reviews': 634,
      'sku': 'wireless_earbuds',
      'isComingSoon': false,
    },
    {
      'name': 'Smart Watch Series 5',
      'price': '\$93.99',
      'imageUrl': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400',
      'rating': 4.7,
      'reviews': 412,
      'sku': 'smart_watch',
      'isComingSoon': false,
    },
    {
      'name': 'Portable Power Bank',
      'price': '\$21.99',
      'imageUrl': 'https://images.unsplash.com/photo-1585771724684-38269d6639fd?w=400',
      'rating': 4.6,
      'reviews': 287,
      'sku': 'power_bank',
      'isComingSoon': false,
    },
    {
      'name': 'Bluetooth Speaker',
      'price': '\$43.99',
      'imageUrl': 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=400',
      'rating': 4.8,
      'reviews': 356,
      'sku': 'bluetooth_speaker',
      'isComingSoon': false,
    },
    {
      'name': 'Action Camera 4K',
      'price': '\$81.99',
      'imageUrl': 'https://images.unsplash.com/photo-1512790182412-b19e6d62bc39?w=400',
      'rating': 4.7,
      'reviews': 198,
      'sku': 'action_camera',
      'isComingSoon': false,
    },
    {
      'name': 'Drone Mini Pro',
      'price': '\$154.99',
      'imageUrl': 'https://images.unsplash.com/photo-1579829366248-204fe8413f31?w=400',
      'rating': 4.6,
      'reviews': 143,
      'sku': 'drone_mini',
      'isComingSoon': false,
    },
  ],

  // ── COMP ── Computer & desk accessories only ──────────────────────────────
  'Comp': [
    {
      'name': 'Laptop Stand Aluminium',
      'price': '\$21.99',
      'imageUrl': 'https://images.unsplash.com/photo-1593642632559-0c6d3fc62b89?w=400',
      'rating': 4.8,
      'reviews': 476,
      'sku': 'laptop_stand',
      'isComingSoon': false,
    },
    {
      'name': 'Mechanical Keyboard',
      'price': '\$55.99',
      'imageUrl': 'https://images.unsplash.com/photo-1561112078-7d24e04c3407?w=400',
      'rating': 4.7,
      'reviews': 321,
      'sku': 'mech_keyboard',
      'isComingSoon': false,
    },
    {
      'name': 'Wireless Mouse',
      'price': '\$17.99',
      'imageUrl': 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=400',
      'rating': 4.6,
      'reviews': 589,
      'sku': 'wireless_mouse',
      'isComingSoon': false,
    },
    {
      'name': 'USB-C Hub 7-in-1',
      'price': '\$27.99',
      'imageUrl': 'https://images.unsplash.com/photo-1587202372775-e229f172b9d7?w=400',
      'rating': 4.5,
      'reviews': 203,
      'sku': 'usbc_hub',
      'isComingSoon': false,
    },
    {
      'name': 'Monitor 27" 4K',
      'price': '\$312.99',
      'imageUrl': 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?w=400',
      'rating': 4.8,
      'reviews': 167,
      'sku': 'monitor_4k',
      'isComingSoon': false,
    },
    {
      'name': 'Webcam HD 1080p',
      'price': '\$37.99',
      'imageUrl': 'https://images.unsplash.com/photo-1596742578443-7682ef5251cd?w=400',
      'rating': 4.6,
      'reviews': 234,
      'sku': 'webcam_hd',
      'isComingSoon': false,
    },
  ],
};

// Flat list of all products across every category — used by SearchPage
final List<Map<String, dynamic>> allProducts = _categoryProducts.values
    .expand((list) => list)
    .toList();

class CategoryProductsPage extends StatefulWidget {
  final String categoryName;

  const CategoryProductsPage({super.key, required this.categoryName});

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

enum _SortOption { none, nameAZ, nameZA, priceHigh, priceLow }

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  _SortOption _sort = _SortOption.none;
  RangeValues _priceRange = const RangeValues(0, 400);
  bool _hideComingSoon = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  double _parsePrice(String price) {
    final cleaned = price.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleaned) ?? 0;
  }

  List<Map<String, dynamic>> get _filteredProducts {
    final base = _categoryProducts[widget.categoryName] ?? [];
    var list = base.where((p) {
      final name = (p['name'] as String).toLowerCase();
      final price = _parsePrice(p['price'] as String);
      final comingSoon = p['isComingSoon'] as bool? ?? false;
      if (_query.isNotEmpty && !name.contains(_query.toLowerCase())) return false;
      if (price < _priceRange.start || price > _priceRange.end) return false;
      if (_hideComingSoon && comingSoon) return false;
      return true;
    }).toList();

    switch (_sort) {
      case _SortOption.nameAZ:
        list.sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));
      case _SortOption.nameZA:
        list.sort((a, b) => (b['name'] as String).compareTo(a['name'] as String));
      case _SortOption.priceLow:
        list.sort((a, b) => _parsePrice(a['price']).compareTo(_parsePrice(b['price'])));
      case _SortOption.priceHigh:
        list.sort((a, b) => _parsePrice(b['price']).compareTo(_parsePrice(a['price'])));
      case _SortOption.none:
        break;
    }
    return list;
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FilterSheet(
        currentSort: _sort,
        currentPriceRange: _priceRange,
        hideComingSoon: _hideComingSoon,
        onApply: (sort, priceRange, hideComingSoon) {
          setState(() {
            _sort = sort;
            _priceRange = priceRange;
            _hideComingSoon = hideComingSoon;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category title
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 16, 25, 12),
                    child: Text(
                      widget.categoryName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0C1A30),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  // Search bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: TextField(
                        controller: _searchCtrl,
                        onChanged: (v) => setState(() => _query = v),
                        style: const TextStyle(fontSize: 14, color: Color(0xFF0C1A30)),
                        decoration: InputDecoration(
                          hintText: 'Search in ${widget.categoryName}...',
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          suffixIcon: _query.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear, size: 16, color: Colors.grey.shade400),
                                  onPressed: () {
                                    _searchCtrl.clear();
                                    setState(() => _query = '');
                                  },
                                )
                              : const Padding(
                                  padding: EdgeInsets.only(right: 14),
                                  child: Icon(Icons.search, color: Color(0xFF0C1A30), size: 20),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Product grid
                  Expanded(
                    child: _filteredProducts.isEmpty
                        ? const Center(
                            child: Text(
                              'No products in this category yet.',
                              style: TextStyle(color: Color(0xFF838589)),
                            ),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              childAspectRatio: 0.62,
                            ),
                            itemCount: _filteredProducts.length,
                            itemBuilder: (context, index) {
                              final p = _filteredProducts[index];
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
                                child: _CategoryProductCard(
                                  sku: p['sku'] as String? ?? '',
                                  name: p['name'] as String,
                                  price: p['price'] as String,
                                  imageUrl: p['imageUrl'] as String,
                                  rating: (p['rating'] as num).toDouble(),
                                  reviewCount: p['reviews'] as int,
                                  isComingSoon: p['isComingSoon'] as bool? ?? false,
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
            // Filter & Sorting button
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 12, 25, 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: _showFilterSheet,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: (_sort != _SortOption.none || _priceRange != const RangeValues(0, 400) || _hideComingSoon)
                          ? const Color(0xFF3669C9)
                          : const Color(0xFF0C1A30),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.tune,
                        size: 18,
                        color: (_sort != _SortOption.none || _priceRange != const RangeValues(0, 400) || _hideComingSoon)
                            ? const Color(0xFF3669C9)
                            : const Color(0xFF0C1A30),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Filter & Sorting',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: (_sort != _SortOption.none || _priceRange != const RangeValues(0, 400) || _hideComingSoon)
                              ? const Color(0xFF3669C9)
                              : const Color(0xFF0C1A30),
                        ),
                      ),
                      if (_sort != _SortOption.none || _priceRange != const RangeValues(0, 400) || _hideComingSoon) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3669C9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${[
                              _sort != _SortOption.none,
                              _priceRange != const RangeValues(0, 400),
                              _hideComingSoon,
                            ].where((v) => v).length}',
                            style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      height: 55,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Back button
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.chevron_left, size: 28, color: Color(0xFF0C1A30)),
            ),
          ),
          // Title
          const Text(
            'Category',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0C1A30),
              letterSpacing: 0.2,
            ),
          ),
          // Cart icon
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart_outlined, size: 20, color: Color(0xFF0C1A30)),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryProductCard extends StatelessWidget {
  final String sku;
  final String name;
  final String price;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final bool isComingSoon;

  const _CategoryProductCard({
    required this.sku,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    this.isComingSoon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
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
                      child: const Icon(Icons.image_not_supported_outlined, size: 32, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              if (isComingSoon)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE65100),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Coming Soon',
                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
              Positioned(
                top: 6,
                right: 6,
                child: Consumer<WishlistProvider>(
                  builder: (context, wishlist, _) {
                    final isWishlisted = wishlist.contains(sku);
                    return GestureDetector(
                      onTap: () => wishlist.toggle(
                        sku: sku,
                        name: name,
                        price: price,
                        imageUrl: imageUrl,
                        rating: rating,
                        reviewCount: reviewCount,
                        isComingSoon: isComingSoon,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isWishlisted ? Icons.favorite : Icons.favorite_border,
                          size: 16,
                          color: isWishlisted ? const Color(0xFFFE3A30) : Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          // Info
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0C1A30),
                    letterSpacing: 0.2,
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
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 11, color: Color(0xFFFFC107)),
                    const SizedBox(width: 3),
                    Text(
                      rating.toString(),
                      style: const TextStyle(fontSize: 10, color: Color(0xFF0C1A30), letterSpacing: 0.2),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '$reviewCount Reviews',
                        style: const TextStyle(fontSize: 10, color: Color(0xFF0C1A30), letterSpacing: 0.2),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.more_vert, size: 14, color: Color(0xFF838589)),
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

// ── Filter & Sorting bottom sheet ────────────────────────────────────────────

class _FilterSheet extends StatefulWidget {
  final _SortOption currentSort;
  final RangeValues currentPriceRange;
  final bool hideComingSoon;
  final void Function(_SortOption sort, RangeValues priceRange, bool hideComingSoon) onApply;

  const _FilterSheet({
    required this.currentSort,
    required this.currentPriceRange,
    required this.hideComingSoon,
    required this.onApply,
  });

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet>
    with SingleTickerProviderStateMixin {
  static const _navy = Color(0xFF0C1A30);
  static const _blue = Color(0xFF3669C9);
  static const _green = Color(0xFF3A9B7A);

  late TabController _tabController;
  late _SortOption _sort;
  late RangeValues _priceRange;
  late bool _hideComingSoon;

  static const double _priceMin = 0;
  static const double _priceMax = 400;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _sort = widget.currentSort;
    _priceRange = widget.currentPriceRange;
    _hideComingSoon = widget.hideComingSoon;
    // Open on Sorting tab if a sort is active
    if (_sort != _SortOption.none) _tabController.index = 1;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _reset() {
    setState(() {
      _sort = _SortOption.none;
      _priceRange = const RangeValues(_priceMin, _priceMax);
      _hideComingSoon = false;
    });
  }

  void _apply() {
    widget.onApply(_sort, _priceRange, _hideComingSoon);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter & Sorting',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _navy, letterSpacing: 0.2),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, size: 22, color: _navy),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Tab bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TabBar(
              controller: _tabController,
              labelColor: _navy,
              unselectedLabelColor: _navy,
              labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              indicatorColor: _navy,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 2,
              dividerColor: Colors.transparent,
              tabs: const [Tab(text: 'Filter'), Tab(text: 'Sorting')],
            ),
          ),
          const Divider(height: 1),
          // Tab content
          SizedBox(
            height: 300,
            child: TabBarView(
              controller: _tabController,
              children: [_buildFilterTab(), _buildSortingTab()],
            ),
          ),
          // Reset + Apply buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 8, 25, 28),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: _reset,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: _navy),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Reset',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: _navy)),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _apply,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _blue,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Apply',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Price Range',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: _navy)),
          const SizedBox(height: 16),
          RangeSlider(
            values: _priceRange,
            min: _priceMin,
            max: _priceMax,
            activeColor: _blue,
            inactiveColor: const Color(0xFFEDEDED),
            onChanged: (v) => setState(() => _priceRange = v),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('\$${_priceRange.start.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _navy)),
                Text('\$${_priceRange.end.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _navy)),
              ],
            ),
          ),
          const Divider(height: 32),
          _buildCheckRow(
            label: 'In Stock Only',
            checked: _hideComingSoon,
            onTap: () => setState(() => _hideComingSoon = !_hideComingSoon),
            isGreen: _hideComingSoon,
          ),
        ],
      ),
    );
  }

  Widget _buildSortingTab() {
    final options = [
      (_SortOption.none, 'Default'),
      (_SortOption.nameAZ, 'Name (A-Z)'),
      (_SortOption.nameZA, 'Name (Z-A)'),
      (_SortOption.priceHigh, 'Price (High-Low)'),
      (_SortOption.priceLow, 'Price (Low-High)'),
    ];
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: options.length,
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 25, endIndent: 25),
      itemBuilder: (context, i) {
        final (opt, label) = options[i];
        return _buildCheckRow(
          label: label,
          checked: _sort == opt,
          onTap: () => setState(() => _sort = opt),
          isGreen: _sort == opt,
        );
      },
    );
  }

  Widget _buildCheckRow({
    required String label,
    required bool checked,
    required VoidCallback onTap,
    bool isGreen = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: _navy)),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: checked ? _green : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: checked ? null : Border.all(color: Colors.grey.shade400),
              ),
              child: checked
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

