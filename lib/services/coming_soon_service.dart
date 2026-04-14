import 'dart:convert';
import 'package:http/http.dart' as http;

const String _backendUrl = 'http://localhost:3000';

class ComingSoonService {
  /// Registers the current user for a "notify me" alert on a coming soon SKU.
  /// Calls backend which sets OneSignal tags:
  ///   availability = notify_me_requested
  ///   product_name = <sku>
  Future<void> requestNotification({
    required String externalId,
    required String sku,
    required String productName,
  }) async {
    final response = await http.post(
      Uri.parse('$_backendUrl/notify-me'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'externalId': externalId,
        'sku': sku,
        'productName': productName,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to register notification: ${response.body}');
    }
  }

  /// Simulates a restock event (for testing only).
  /// Sends a "Buy Now" push to all users tagged for this SKU.
  Future<void> simulateRestock({
    required String sku,
    required String productName,
    String? price,
    String? imageUrl,
  }) async {
    final response = await http.post(
      Uri.parse('$_backendUrl/simulate-restock'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'sku': sku,
        'productName': productName,
        'price': price,
        'imageUrl': imageUrl,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to simulate restock: ${response.body}');
    }
  }
}
