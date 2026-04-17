import 'package:flutter/material.dart';
import '../providers/order_provider.dart';
import 'ecommerce_home_page.dart';

class CheckoutConfirmationPage extends StatelessWidget {
  final Order order;

  const CheckoutConfirmationPage({super.key, required this.order});

  static const _navy = Color(0xFF0C1A30);
  static const _blue = Color(0xFF3669C9);
  static const _green = Color(0xFF3A9B7A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              // Success icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _green.withValues(alpha: 0.12),
                ),
                child: const Icon(Icons.check_circle_rounded, size: 60, color: _green),
              ),
              const SizedBox(height: 24),
              const Text(
                'Order Placed!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _navy),
              ),
              const SizedBox(height: 8),
              Text(
                'Your order has been confirmed.',
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 32),
              // Order details card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    _buildRow('Order ID', order.id, mono: true),
                    const Divider(height: 24),
                    _buildRow('Items', '${order.items.fold(0, (s, i) => s + i.quantity)} item(s)'),
                    const SizedBox(height: 8),
                    _buildRow('Total', order.formattedTotal, bold: true),
                    const SizedBox(height: 8),
                    _buildRow('Payment', order.paymentMethod.label),
                    const SizedBox(height: 8),
                    _buildRow(
                      'Ship to',
                      '${order.shippingInfo.fullName}, ${order.shippingInfo.city}',
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // CTA buttons
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const EcommerceHomePage()),
                      (_) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Continue Shopping',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const EcommerceHomePage()),
                  (_) => false,
                ),
                child: const Text(
                  'View My Orders',
                  style: TextStyle(fontSize: 14, color: _blue, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool bold = false, bool mono = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 13,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              color: _navy,
              fontFamily: mono ? 'monospace' : null,
            ),
          ),
        ),
      ],
    );
  }
}
