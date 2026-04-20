import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  StreamSubscription<AuthState>? _sub;

  AuthProvider() {
    _user = SupabaseService.instance.currentUser;
    _sub = SupabaseService.instance.authStateStream.listen((state) {
      _user = state.session?.user;
      notifyListeners();
    });
  }

  bool get isAuthenticated => _user != null;
  String? get userId => _user?.id;
  String? get email => _user?.email;

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
