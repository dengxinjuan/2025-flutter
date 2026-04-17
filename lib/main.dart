import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'config.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/wishlist_provider.dart';
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

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize(kOneSignalAppId);

  OneSignal.Notifications.addForegroundWillDisplayListener((event) {
    print("🔔 [Foreground] Notification will display: ${event.notification.jsonRepresentation()}");
    print("🔔 [Foreground] Additional data: ${event.notification.additionalData}");
    event.notification.display();
  });

  OneSignal.Notifications.addClickListener((event) {
    print("🔔 [Click] Notification clicked: ${event.notification.jsonRepresentation()}");
    print("🔔 [Click] Additional data: ${event.notification.additionalData}");
  });

  OneSignal.Notifications.requestPermission(true);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) {
          final w = WishlistProvider();
          w.load();
          return w;
        }),
      ],
      child: MaterialApp(
        title: 'Mega Mall',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3669C9)),
        ),
        home: const RootPage(),
      ),
    );
  }
}

/// Root swipeable container: swipe left = E-Commerce, swipe right = Debug.
class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final PageController _pageController = PageController(initialPage: 1);
  int _currentPage = 1; // 0 = Debug, 1 = E-Commerce

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: _pageController,
          onPageChanged: (i) => setState(() => _currentPage = i),
          children: const [
            MyHomePage(title: 'Debug'),
            EcommerceHomePage(),
          ],
        ),
        // Swipe indicator dots
        Positioned(
          top: 52,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(2, (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentPage == i ? 16 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _currentPage == i
                    ? Colors.white
                    : Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(3),
              ),
            )),
          ),
        ),
      ],
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
            const Text(
              '← Swipe right to go to E-Commerce',
              style: TextStyle(fontSize: 12, color: Colors.grey),
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
