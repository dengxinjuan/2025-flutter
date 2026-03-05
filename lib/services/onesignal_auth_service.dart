import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';

/// Backend base URL.
/// - iOS Simulator  → localhost resolves directly
/// - Android Emulator → use http://10.0.2.2:3000
/// - Real device (same Wi-Fi) → http://<your-computer-IP>:3000
const String _backendUrl = 'http://localhost:3000';

class OneSignalAuthService {
  String? _externalId;

  String? get externalId => _externalId;
  bool get isLoggedIn => _externalId != null;

  /// Call backend to get a JWT, then log the user into OneSignal.
  /// [userId] is your app's identifier for the user (email, username, ID, etc.)
  Future<void> login(String userId) async {
    final response = await http.post(
      Uri.parse('$_backendUrl/auth/token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Backend error ${response.statusCode}: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final externalId = data['externalId'] as String;

    _externalId = externalId;

    await OneSignal.login(externalId);

    print('✅ [Auth] Logged in as: $externalId');
  }

  /// Log the user out of OneSignal and clear the local session.
  Future<void> logout() async {
    await OneSignal.logout();
    _externalId = null;
    print('🚪 [Auth] Logged out');
  }
}
