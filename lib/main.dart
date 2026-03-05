import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'screens/ecommerce_home_page.dart';
import 'screens/login_screen.dart';

const platform = MethodChannel('com.yourapp/notification');

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  platform.setMethodCallHandler((call) async {
    if (call.method == "silentNotification") {
      print("🌙 Dart received silent push: ${call.arguments}");
    }
  });

  runApp(const MyApp());

  OneSignal.initialize("db231987-4182-42ba-a4b2-638cf90b29f6");

  OneSignal.Notifications.addForegroundWillDisplayListener((event) {
    print("🔔 [Foreground] Notification will display: ${event.notification.jsonRepresentation()}");
    print("🔔 [Foreground] Additional data: ${event.notification.additionalData}");
    event.notification.display();
  });

  OneSignal.Notifications.addClickListener((event) {
    print("🔔 [Click] Notification clicked: ${event.notification.jsonRepresentation()}");
    print("🔔 [Click] Additional data: ${event.notification.additionalData}");
  });

  OneSignal.Notifications.requestPermission(false);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OneSignal Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'OneSignal testing!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _userId;
  String? _subscriptionId;
  String? _pushToken;
  bool _optedIn = false;
  String? _lastNotificationData;

  @override
  void initState() {
    super.initState();

    platform.setMethodCallHandler((call) async {
      if (call.method == "silentNotification") {
        print("🌙 Dart received silent push: ${call.arguments}");
        setState(() {
          _lastNotificationData = call.arguments.toString();
        });
      }
    });

    _loadOneSignalInfo();

    OneSignal.User.pushSubscription.addObserver((state) {
      setState(() {
        _subscriptionId = state.current.id;
        _pushToken = state.current.token;
        _optedIn = state.current.optedIn;
      });

      print("🔁 [Observer] Push Subscription ID: ${state.current.id}");
      print("🔑 [Observer] Push Token: ${state.current.token}");
      print("✅ [Observer] Opted In: ${state.current.optedIn}");
    });

    _applyPushSubscriptionFromSdk();
    Future.delayed(const Duration(milliseconds: 1500), _applyPushSubscriptionFromSdk);
  }

  void _applyPushSubscriptionFromSdk() {
    if (!mounted) return;
    final id = OneSignal.User.pushSubscription.id;
    final token = OneSignal.User.pushSubscription.token;
    final optedIn = OneSignal.User.pushSubscription.optedIn ?? false;
    setState(() {
      if (id != null && id.isNotEmpty) _subscriptionId = id;
      if (token != null) _pushToken = token;
      _optedIn = optedIn;
    });
  }

  Future<void> _loadOneSignalInfo() async {
    final userId = await OneSignal.User.getOnesignalId();
    setState(() {
      _userId = userId;
    });
  }

  Future<void> _requestPermission() async {
    await OneSignal.Notifications.requestPermission(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.login),
                label: const Text('Login / Logout'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => const EcommerceHomePage(),
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_bag_outlined),
                label: const Text('Open E-Commerce Home'),
              ),
            ),
            const SizedBox(height: 20),
            const Text("🔔 OneSignal Info", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text("👤 OneSignal ID:\n${_userId ?? "Loading..."}"),
            const SizedBox(height: 12),
            Text("🔁 Push Subscription ID:\n${_subscriptionId ?? "Waiting..."}"),
            const SizedBox(height: 12),
            Text("🔑 Push Token:\n${_pushToken ?? "Waiting..."}"),
            const SizedBox(height: 12),
            Text("✅ Opted In: ${_optedIn ? "Yes" : "No"}"),
            const SizedBox(height: 12),
            Text("📩 Last Notification:\n${_lastNotificationData ?? "None received"}"),
            ElevatedButton(
              onPressed: _requestPermission,
              child: const Text("🔔 Request Notification Permission"),
            ),
          ],
        ),
      ),
    );
  }
}
