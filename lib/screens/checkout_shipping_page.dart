import 'package:flutter/material.dart';
import '../providers/order_provider.dart';
import 'checkout_payment_page.dart';
import 'checkout_widgets.dart';

class CheckoutShippingPage extends StatefulWidget {
  const CheckoutShippingPage({super.key});

  @override
  State<CheckoutShippingPage> createState() => _CheckoutShippingPageState();
}

class _CheckoutShippingPageState extends State<CheckoutShippingPage> {
  static const _navy = Color(0xFF0C1A30);
  static const _blue = Color(0xFF3669C9);
  static const _bg = Color(0xFFFAFAFA);

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _zipCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _zipCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_formKey.currentState!.validate()) {
      final info = ShippingInfo(
        fullName: _nameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
        city: _cityCtrl.text.trim(),
        zipCode: _zipCtrl.text.trim(),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CheckoutPaymentPage(shippingInfo: info)),
      );
    }
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
          'Shipping Details',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _navy),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          buildStepIndicator(step: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildField(
                      controller: _nameCtrl,
                      label: 'Full Name',
                      hint: 'John Smith',
                      icon: Icons.person_outline,
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      controller: _phoneCtrl,
                      label: 'Phone Number',
                      hint: '+1 234 567 8900',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      controller: _addressCtrl,
                      label: 'Street Address',
                      hint: '123 Main St, Apt 4B',
                      icon: Icons.home_outlined,
                      maxLines: 2,
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildField(
                            controller: _cityCtrl,
                            label: 'City',
                            hint: 'New York',
                            icon: Icons.location_city_outlined,
                            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildField(
                            controller: _zipCtrl,
                            label: 'ZIP Code',
                            hint: '10001',
                            icon: Icons.markunread_mailbox_outlined,
                            keyboardType: TextInputType.number,
                            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
          buildBottomButton(label: 'Continue to Payment', onTap: _next),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _navy),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(fontSize: 14, color: _navy),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: Icon(icon, size: 20, color: Colors.grey.shade500),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: _blue, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFFE3A30)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFFE3A30), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

