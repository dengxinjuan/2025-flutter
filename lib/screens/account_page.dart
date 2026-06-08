import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/supabase_service.dart';
import 'login_screen.dart';
import 'orders_page.dart';
import 'wishlist_page.dart';

/// Guest-first account hub. Never forces login — sign-in is optional and only
/// used to sync orders across devices.
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  static const _navy = Color(0xFF0C1A30);
  static const _bg = Color(0xFFFAFAFA);
  static const _red = Color(0xFFFE3A30);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isLoggedIn = auth.isAuthenticated;

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
          'Account',
          style:
              TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _navy),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildProfileHeader(context, auth, isLoggedIn),
          const SizedBox(height: 24),
          _buildMenuCard([
            _MenuRow(
              icon: Icons.receipt_long_outlined,
              label: 'My Orders',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OrdersPage()),
              ),
            ),
            _MenuRow(
              icon: Icons.favorite_border,
              label: 'Wishlist',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WishlistPage()),
              ),
            ),
          ]),
          const SizedBox(height: 24),
          if (isLoggedIn)
            _buildSignOutButton(context)
          else
            _buildSignInButton(context),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(
      BuildContext context, AuthProvider auth, bool isLoggedIn) {
    final email = auth.email ?? '';
    final initial =
        email.isNotEmpty ? email[0].toUpperCase() : '?';

    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: isLoggedIn
                ? _red.withValues(alpha: 0.12)
                : Colors.grey.shade200,
            child: isLoggedIn
                ? Text(
                    initial,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: _red),
                  )
                : Icon(Icons.person_outline,
                    size: 28, color: Colors.grey.shade500),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLoggedIn ? email : 'Guest',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _navy),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  isLoggedIn
                      ? 'Signed in'
                      : 'Shopping as guest • sign in to sync orders',
                  style:
                      TextStyle(fontSize: 13, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> rows) {
    final children = <Widget>[];
    for (var i = 0; i < rows.length; i++) {
      children.add(rows[i]);
      if (i < rows.length - 1) {
        children.add(const Divider(height: 1, indent: 52));
      }
    }
    return Container(
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
      child: Column(children: children),
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        ),
        icon: const Icon(Icons.login, size: 18),
        label: const Text('Sign In / Create Account',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: _red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () async {
          await SupabaseService.instance.signOut();
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Signed out')),
          );
        },
        icon: const Icon(Icons.logout, size: 18, color: _red),
        label: const Text('Sign Out',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: _red)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: _red),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuRow(
      {required this.icon, required this.label, required this.onTap});

  static const _navy = Color(0xFF0C1A30);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, size: 22, color: _navy),
      title: Text(label,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w500, color: _navy)),
      trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
    );
  }
}
