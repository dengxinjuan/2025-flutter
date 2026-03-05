import 'package:flutter/material.dart';
import '../services/onesignal_auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = OneSignalAuthService();
  final _userIdController = TextEditingController(text: 'user-123');
  bool _loading = false;
  String? _statusMessage;
  bool _isError = false;

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final userId = _userIdController.text.trim();
    if (userId.isEmpty) {
      _setStatus('Please enter a user ID', isError: true);
      return;
    }

    setState(() {
      _loading = true;
      _statusMessage = null;
    });

    try {
      await _authService.login(userId);
      _setStatus('Logged in as: ${_authService.externalId}');
    } catch (e) {
      _setStatus('Login failed: $e', isError: true);
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _logout() async {
    setState(() => _loading = true);
    try {
      await _authService.logout();
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
    final isLoggedIn = _authService.isLoggedIn;

    return Scaffold(
      appBar: AppBar(
        title: const Text('OneSignal Login'),
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
                          ? 'Logged in as:\n${_authService.externalId}'
                          : 'Not logged in',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isLoggedIn ? Colors.green.shade700 : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            TextField(
              controller: _userIdController,
              enabled: !isLoggedIn && !_loading,
              decoration: const InputDecoration(
                labelText: 'User ID',
                hintText: 'e.g. user-123 or john@example.com',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            if (!isLoggedIn)
              FilledButton.icon(
                onPressed: _loading ? null : _login,
                icon: _loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.login),
                label: Text(_loading ? 'Logging in...' : 'Login'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),

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
                    color: _isError ? Colors.red.shade200 : Colors.blue.shade200,
                  ),
                ),
                child: Text(
                  _statusMessage!,
                  style: TextStyle(
                    color: _isError ? Colors.red.shade700 : Colors.blue.shade700,
                  ),
                ),
              ),

            const Spacer(),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: const Text(
                '📡 Make sure the backend is running:\ncd backend && npm start',
                style: TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
