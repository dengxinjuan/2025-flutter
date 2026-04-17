import 'package:flutter/material.dart';
import 'category_products_page.dart' show allProducts;
import 'product_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const _navy = Color(0xFF0C1A30);
  static const _blue = Color(0xFF3669C9);
  static const _red = Color(0xFFFE3A30);

  final _controller = TextEditingController();
  String _query = '';

  List<Map<String, dynamic>> get _results {
    if (_query.trim().isEmpty) return [];
    final q = _query.trim().toLowerCase();
    return allProducts
        .where((p) => (p['name'] as String).toLowerCase().contains(q))
        .toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28, color: _navy),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: (v) => setState(() => _query = v),
          style: const TextStyle(fontSize: 15, color: _navy),
          decoration: InputDecoration(
            hintText: 'Search products...',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
            border: InputBorder.none,
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, size: 18, color: Colors.grey.shade500),
                    onPressed: () {
                      _controller.clear();
                      setState(() => _query = '');
                    },
                  )
                : null,
          ),
        ),
      ),
      body: _query.trim().isEmpty
          ? _buildEmptyPrompt()
          : results.isEmpty
              ? _buildNoResults()
              : _buildResults(results),
    );
  }

  Widget _buildEmptyPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Search for products',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No results for "$_query"',
            style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(List<Map<String, dynamic>> results) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final p = results[i];
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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                  child: Image.network(
                    p['imageUrl'] as String,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey.shade100,
                      child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p['name'] as String,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600, color: _navy),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          p['price'] as String,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold, color: _red),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFC107)),
                            const SizedBox(width: 3),
                            Text(
                              '${(p['rating'] as num).toStringAsFixed(1)}',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                            if (p['isComingSoon'] == true) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE65100),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Coming Soon',
                                  style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
