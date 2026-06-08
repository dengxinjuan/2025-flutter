import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import 'login_screen.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  static const _navy = Color(0xFF0C1A30);
  static const _bg = Color(0xFFFAFAFA);
  static const _red = Color(0xFFFE3A30);

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadOrders());
  }

  Future<void> _loadOrders() async {
    final userId = context.read<AuthProvider>().userId;
    if (userId == null) return;
    setState(() => _loading = true);
    await context.read<OrderProvider>().loadOrders(userId);
    if (!mounted) return;
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final orders = context.watch<OrderProvider>().orders;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28, color: _navy),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Orders',
          style:
              TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _navy),
        ),
        centerTitle: true,
      ),
      body: _buildBody(auth, orders),
    );
  }

  Widget _buildBody(AuthProvider auth, List<Order> orders) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: _red));
    }
    if (orders.isEmpty) {
      return _buildEmptyState(auth.isAuthenticated);
    }
    return RefreshIndicator(
      color: _red,
      onRefresh: () async {
        final userId = context.read<AuthProvider>().userId;
        if (userId == null) return;
        // Force a re-fetch on pull-to-refresh.
        context.read<OrderProvider>().clearForSignOut();
        await context.read<OrderProvider>().loadOrders(userId);
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (_, i) => _buildOrderCard(orders[i]),
      ),
    );
  }

  Widget _buildEmptyState(bool isAuthenticated) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long_outlined,
                size: 72, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text(
              'No orders yet',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700, color: _navy),
            ),
            const SizedBox(height: 8),
            Text(
              'Your placed orders will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
            // Subtle, optional cross-device sync hint for guests — never blocking.
            if (!isAuthenticated) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                ),
                child: Text(
                  'Sign in to sync orders across devices',
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      decoration: TextDecoration.underline),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    final itemCount =
        order.items.fold<int>(0, (sum, item) => sum + item.quantity);

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.id,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _navy),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(order.placedAt),
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: order.items
                  .map((item) => _buildItemRow(item))
                  .toList(),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$itemCount item${itemCount == 1 ? '' : 's'} • ${order.paymentMethod.label}',
                  style:
                      TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                Text(
                  order.formattedTotal,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Confirmed',
        style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E7D32)),
      ),
    );
  }

  Widget _buildItemRow(CartItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.imageUrl,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 48,
                height: 48,
                color: Colors.grey.shade100,
                child: const Icon(Icons.image_not_supported_outlined,
                    size: 20, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _navy),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text('Qty: ${item.quantity}',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade500)),
              ],
            ),
          ),
          Text(
            '\$${item.subtotal.toStringAsFixed(2)}',
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: _navy),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final local = dt.toLocal();
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    final period = local.hour < 12 ? 'AM' : 'PM';
    return '${months[local.month - 1]} ${local.day}, ${local.year} • $hour:$minute $period';
  }
}
