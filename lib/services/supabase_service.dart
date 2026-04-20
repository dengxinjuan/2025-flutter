import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseService._();
  static final SupabaseService instance = SupabaseService._();

  SupabaseClient get client => Supabase.instance.client;
  User? get currentUser => client.auth.currentUser;
  Stream<AuthState> get authStateStream => client.auth.onAuthStateChange;

  Future<void> signIn(String email, String password) =>
      client.auth.signInWithPassword(email: email, password: password);

  Future<void> signUp(String email, String password) =>
      client.auth.signUp(email: email, password: password);

  Future<void> signOut() => client.auth.signOut();
}
