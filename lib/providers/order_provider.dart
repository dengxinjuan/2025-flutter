import 'package:flutter/foundation.dart';
import 'cart_provider.dart';

class ShippingInfo {
  final String fullName;
  final String phone;
  final String address;
  final String city;
  final String zipCode;

  ShippingInfo({
    required this.fullName,
    required this.phone,
    required this.address,
    required this.city,
    required this.zipCode,
  });
}

enum PaymentMethod { creditCard, bankTransfer, eWallet }

extension PaymentMethodLabel on PaymentMethod {
  String get label {
    switch (this) {
      case PaymentMethod.creditCard:
        return 'Credit / Debit Card';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.eWallet:
        return 'E-Wallet';
    }
  }

  String get icon {
    switch (this) {
      case PaymentMethod.creditCard:
        return '💳';
      case PaymentMethod.bankTransfer:
        return '🏦';
      case PaymentMethod.eWallet:
        return '📱';
    }
  }
}

class Order {
  final String id;
  final List<CartItem> items;
  final ShippingInfo shippingInfo;
  final PaymentMethod paymentMethod;
  final double total;
  final DateTime placedAt;

  Order({
    required this.id,
    required this.items,
    required this.shippingInfo,
    required this.paymentMethod,
    required this.total,
    required this.placedAt,
  });

  String get formattedTotal => '\$${total.toStringAsFixed(2)}';
}

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  Order placeOrder({
    required List<CartItem> items,
    required ShippingInfo shippingInfo,
    required PaymentMethod paymentMethod,
    required double total,
  }) {
    final order = Order(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      items: List.from(items),
      shippingInfo: shippingInfo,
      paymentMethod: paymentMethod,
      total: total,
      placedAt: DateTime.now(),
    );
    _orders.insert(0, order);
    notifyListeners();
    return order;
  }
}
