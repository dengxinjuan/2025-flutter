import 'package:flutter/foundation.dart';
import 'cart_provider.dart';
import '../services/supabase_service.dart';

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
  String? _loadedForUserId;

  List<Order> get orders => List.unmodifiable(_orders);

  Future<Order> placeOrder({
    required List<CartItem> items,
    required ShippingInfo shippingInfo,
    required PaymentMethod paymentMethod,
    required double total,
    String? userId,
  }) async {
    final displayId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';

    if (userId != null) {
      String? orderId;
      try {
        final row = await SupabaseService.instance.client
            .from('orders')
            .insert({
              'user_id': userId,
              'display_id': displayId,
              'total': total,
              'payment_method': paymentMethod.name,
              'ship_full_name': shippingInfo.fullName,
              'ship_phone': shippingInfo.phone,
              'ship_address': shippingInfo.address,
              'ship_city': shippingInfo.city,
              'ship_zip': shippingInfo.zipCode,
            })
            .select('id')
            .single();
        orderId = row['id'] as String;

        await SupabaseService.instance.client.from('order_items').insert(
          items
              .map((item) => {
                    'order_id': orderId,
                    'sku': item.sku,
                    'name': item.name,
                    'price': item.numericPrice,
                    'image_url': item.imageUrl,
                    'quantity': item.quantity,
                  })
              .toList(),
        );
      } catch (e) {
        if (orderId != null) {
          await SupabaseService.instance.client
              .from('orders')
              .delete()
              .eq('id', orderId);
        }
        rethrow;
      }
    }

    final order = Order(
      id: displayId,
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

  Future<void> loadOrders(String userId) async {
    if (_loadedForUserId == userId) return;
    _loadedForUserId = userId;
    try {
      final rows = await SupabaseService.instance.client
          .from('orders')
          .select('*, order_items(*)')
          .eq('user_id', userId)
          .order('placed_at', ascending: false);

      _orders.clear();
      for (final row in rows) {
        final itemRows = row['order_items'] as List;
        final items = itemRows
            .map((i) => CartItem(
                  sku: i['sku'] as String,
                  name: i['name'] as String,
                  price: '\$${(i['price'] as num).toStringAsFixed(2)}',
                  imageUrl: i['image_url'] as String,
                  quantity: i['quantity'] as int,
                ))
            .toList();

        _orders.add(Order(
          id: row['display_id'] as String,
          items: items,
          shippingInfo: ShippingInfo(
            fullName: row['ship_full_name'] as String,
            phone: row['ship_phone'] as String,
            address: row['ship_address'] as String,
            city: row['ship_city'] as String,
            zipCode: row['ship_zip'] as String,
          ),
          paymentMethod: PaymentMethod.values.firstWhere(
            (m) => m.name == row['payment_method'],
            orElse: () => PaymentMethod.creditCard,
          ),
          total: (row['total'] as num).toDouble(),
          placedAt: DateTime.parse(row['placed_at'] as String),
        ));
      }
      notifyListeners();
    } catch (_) {
      _loadedForUserId = null;
    }
  }

  void clearForSignOut() {
    _orders.clear();
    _loadedForUserId = null;
    notifyListeners();
  }
}
