import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/auth_provider.dart';
import '../services/supabase_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _statusMessage;
  bool _isError = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      _setStatus('Please enter your email and password', isError: true);
      return;
    }
    setState(() {
      _loading = true;
      _statusMessage = null;
    });
    try {
      await SupabaseService.instance.signIn(email, password);
      _setStatus('Logged in successfully');
    } on AuthException catch (e) {
      _setStatus(e.message, isError: true);
    } catch (e) {
      _setStatus('Login failed: $e', isError: true);
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      _setStatus('Please enter your email and password', isError: true);
      return;
    }
    setState(() {
      _loading = true;
      _statusMessage = null;
    });
    try {
      await SupabaseService.instance.signUp(email, password);
      _setStatus('Account created! Check your email to confirm.');
    } on AuthException catch (e) {
      _setStatus(e.message, isError: true);
    } catch (e) {
      _setStatus('Sign up failed: $e', isError: true);
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _logout() async {
    setState(() => _loading = true);
    try {
      await SupabaseService.instance.signOut();
      _setStatus('Logged out successfully');
    } catch (e) {
      _setStatus('Logout failed: $e', isError: true);
    } finally {
      setState(() => _loading = false);
    }
  }

  void _setStatus(String message, {bool isError = false}) {
    setState(() {
      _statusMessage = message;
      _isError = isError;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isLoggedIn = auth.isAuthenticated;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isLoggedIn ? Colors.green.shade50 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isLoggedIn ? Colors.green.shade300 : Colors.grey.shade300,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isLoggedIn ? Icons.verified_user : Icons.person_outline,
                    color: isLoggedIn ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isLoggedIn
                          ? 'Logged in as:\n${auth.email}'
                          : 'Not logged in',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isLoggedIn
                            ? Colors.green.shade700
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            TextField(
              controller: _emailController,
              enabled: !isLoggedIn && !_loading,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'you@example.com',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _passwordController,
              enabled: !isLoggedIn && !_loading,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            if (!isLoggedIn) ...[
              FilledButton.icon(
                onPressed: _loading ? null : _login,
                icon: _loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.login),
                label: Text(_loading ? 'Logging in...' : 'Login'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _loading ? null : _signUp,
                icon: const Icon(Icons.person_add_outlined),
                label: const Text('Create Account'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],

            if (isLoggedIn)
              OutlinedButton.icon(
                onPressed: _loading ? null : _logout,
                icon: _loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.logout),
                label: Text(_loading ? 'Logging out...' : 'Logout'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),

            const SizedBox(height: 20),

            if (_statusMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isError ? Colors.red.shade50 : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        _isError ? Colors.red.shade200 : Colors.blue.shade200,
                  ),
                ),
                child: Text(
                  _statusMessage!,
                  style: TextStyle(
                    color:
                        _isError ? Colors.red.shade700 : Colors.blue.shade700,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
