import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import 'checkout_confirmation_page.dart';
import 'checkout_widgets.dart';

class CheckoutReviewPage extends StatelessWidget {
  final ShippingInfo shippingInfo;
  final PaymentMethod paymentMethod;

  const CheckoutReviewPage({
    super.key,
    required this.shippingInfo,
    required this.paymentMethod,
  });

  static const _navy = Color(0xFF0C1A30);
  static const _blue = Color(0xFF3669C9);
  static const _bg = Color(0xFFFAFAFA);
  static const _red = Color(0xFFFE3A30);

  void _placeOrder(BuildContext context) {
    final cart = context.read<CartProvider>();
    final orders = context.read<OrderProvider>();
    final order = orders.placeOrder(
      items: cart.items.values.toList(),
      shippingInfo: shippingInfo,
      paymentMethod: paymentMethod,
      total: cart.totalPrice,
    );
    cart.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => CheckoutConfirmationPage(order: order)),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

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
          'Review Order',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _navy),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          buildStepIndicator(step: 3),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    title: 'Items (${cart.itemCount})',
                    child: Column(
                      children: cart.items.values
                          .map((item) => _buildItemRow(item))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    title: 'Shipping Address',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(shippingInfo.fullName,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600, color: _navy)),
                        const SizedBox(height: 4),
                        Text(shippingInfo.phone,
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                        const SizedBox(height: 4),
                        Text(
                          '${shippingInfo.address}, ${shippingInfo.city} ${shippingInfo.zipCode}',
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    title: 'Payment Method',
                    child: Row(
                      children: [
                        Text(paymentMethod.icon, style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 10),
                        Text(
                          paymentMethod.label,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500, color: _navy),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    title: 'Order Summary',
                    child: Column(
                      children: [
                        _buildSummaryRow('Subtotal', cart.formattedTotal),
                        const SizedBox(height: 8),
                        _buildSummaryRow('Shipping', 'Free'),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(height: 1),
                        ),
                        _buildSummaryRow(
                          'Total',
                          cart.formattedTotal,
                          isBold: true,
                          valueColor: _red,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          buildBottomButton(
            label: 'Place Order',
            onTap: () => _placeOrder(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
          Text(
            title,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w700, color: _navy),
          ),
          const SizedBox(height: 12),
          child,
        ],
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
                child: const Icon(Icons.image_not_supported_outlined, size: 20, color: Colors.grey),
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
                        fontSize: 13, fontWeight: FontWeight.w500, color: _navy),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text('Qty: ${item.quantity}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              ],
            ),
          ),
          Text(
            '\$${item.subtotal.toStringAsFixed(2)}',
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: _red),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isBold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
                color: isBold ? _navy : Colors.grey.shade600)),
        Text(value,
            style: TextStyle(
                fontSize: 13,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                color: valueColor ?? _navy)),
      ],
    );
  }
}
