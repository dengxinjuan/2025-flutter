import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Include the OneSignal package
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'screens/ecommerce_home_page.dart';

const platform = MethodChannel('com.yourapp/notification');

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  platform.setMethodCallHandler((call) async {
    if (call.method == "silentNotification") {
      print("🌙 Dart received silent push: ${call.arguments}");

      // You can trigger state updates, local notifications, etc.
    }
  });

  runApp(const MyApp());

  // Enable verbose logging for debugging (remove in production)
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  // Initialize with your OneSignal App ID
  OneSignal.initialize("db231987-4182-42ba-a4b2-638cf90b29f6");
  // 🔔 Add notification handlers
  OneSignal.Notifications.addForegroundWillDisplayListener((event) {
    print("🔔 [Foreground] Notification will display: ${event.notification.jsonRepresentation()}");
    print("🔔 [Foreground] Additional data: ${event.notification.additionalData}");
    // You can modify or prevent the notification from showing
    // event.preventDefault(); // Prevents the notification from showing
    // Or allow it to show:
    event.notification.display();
  });

  OneSignal.Notifications.addClickListener((event) {
    print("🔔 [Click] Notification clicked: ${event.notification.jsonRepresentation()}");
    print("🔔 [Click] Additional data: ${event.notification.additionalData}");
  });

  // Use this method to prompt for push notifications.
  // We recommend removing this method after testing and instead use In-App Messages to prompt for notification permission.
  OneSignal.Notifications.requestPermission(false);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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

  // Setup MethodChannel for silent push after Flutter is fully initialized
  platform.setMethodCallHandler((call) async {
    if (call.method == "silentNotification") {
      print("🌙 Dart received silent push: ${call.arguments}");

      setState(() {
        _lastNotificationData = call.arguments.toString();
      });
    }
  });

  _loadOneSignalInfo();

  // Watch for live changes to push subscription (observer only fires when native sends a change, not with initial state)
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
  // addObserver does NOT call callback with current state; read current value from SDK getters and setState
  _applyPushSubscriptionFromSdk();
  // Refresh again after a short delay so we pick up values that arrive when lifecycleInit completes
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
      // Push info may be updated later via the observer
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
            // Link to E-Commerce Home (separate page from Figma design)
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
