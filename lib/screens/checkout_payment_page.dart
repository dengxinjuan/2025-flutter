import 'package:flutter/material.dart';
import '../providers/order_provider.dart';
import 'checkout_review_page.dart';
import 'checkout_widgets.dart';

class CheckoutPaymentPage extends StatefulWidget {
  final ShippingInfo shippingInfo;

  const CheckoutPaymentPage({super.key, required this.shippingInfo});

  @override
  State<CheckoutPaymentPage> createState() => _CheckoutPaymentPageState();
}

class _CheckoutPaymentPageState extends State<CheckoutPaymentPage> {
  static const _navy = Color(0xFF0C1A30);
  static const _blue = Color(0xFF3669C9);
  static const _bg = Color(0xFFFAFAFA);

  PaymentMethod _selected = PaymentMethod.creditCard;

  void _next() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CheckoutReviewPage(
          shippingInfo: widget.shippingInfo,
          paymentMethod: _selected,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'Payment Method',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _navy),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          buildStepIndicator(step: 2),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Payment Method',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _navy),
                  ),
                  const SizedBox(height: 16),
                  ...PaymentMethod.values.map((method) => _buildMethodTile(method)),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF4FF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _blue.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lock_outline, size: 18, color: _blue),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Your payment info is encrypted and secure.',
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          buildBottomButton(label: 'Review Order', onTap: _next),
        ],
      ),
    );
  }

  Widget _buildMethodTile(PaymentMethod method) {
    final isSelected = _selected == method;
    return GestureDetector(
      onTap: () => setState(() => _selected = method),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _blue : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
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
            Text(method.icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                method.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: _navy,
                ),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? _blue : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: _blue,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
