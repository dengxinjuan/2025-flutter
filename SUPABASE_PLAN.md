# Supabase Backend Integration — Mega Mall Flutter App

## Context
All product data is hardcoded in Dart. Cart and orders are in-memory only (lost on app restart). The login screen is UI-only. The goal is to wire Supabase as the real backend: persist orders, auth, reviews, and eventually products — without breaking the existing UI.

---

## What You Do Manually First (before any coding)

1. Go to [supabase.com](https://supabase.com) → create new project "mega-mall"
2. In **SQL Editor → New Query**, run the schema SQL below
3. In **SQL Editor**, run the product seed SQL below
4. Go to **Project Settings → API** → copy your **Project URL** and **anon public key**
5. Open `lib/config.dart` and add:
   ```dart
   const String kSupabaseUrl = 'https://YOUR_PROJECT_ID.supabase.co';
   const String kSupabaseAnonKey = 'YOUR_ANON_KEY';
   ```

---

## SQL Schema (run once in Supabase SQL Editor)

```sql
-- PRODUCTS
CREATE TABLE public.products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sku TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  price NUMERIC(10,2) NOT NULL,
  original_price NUMERIC(10,2),
  image_url TEXT NOT NULL,
  rating NUMERIC(3,2) NOT NULL DEFAULT 0,
  review_count INT NOT NULL DEFAULT 0,
  is_coming_soon BOOLEAN NOT NULL DEFAULT FALSE,
  is_sale BOOLEAN NOT NULL DEFAULT FALSE,
  category TEXT NOT NULL,
  tags TEXT[] DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
CREATE POLICY "products_public_read" ON public.products FOR SELECT USING (true);

-- PROFILES (auto-created on signup)
CREATE TABLE public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT,
  full_name TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "profiles_own" ON public.profiles FOR ALL
  USING (auth.uid() = id) WITH CHECK (auth.uid() = id);

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  INSERT INTO public.profiles (id, email) VALUES (NEW.id, NEW.email);
  RETURN NEW;
END;
$$;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ORDERS
CREATE TABLE public.orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  display_id TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'placed',
  total NUMERIC(10,2) NOT NULL,
  payment_method TEXT NOT NULL,
  ship_full_name TEXT NOT NULL,
  ship_phone TEXT NOT NULL,
  ship_address TEXT NOT NULL,
  ship_city TEXT NOT NULL,
  ship_zip TEXT NOT NULL,
  placed_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
CREATE POLICY "orders_own_read" ON public.orders FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "orders_own_insert" ON public.orders FOR INSERT WITH CHECK (auth.uid() = user_id);

-- ORDER ITEMS
CREATE TABLE public.order_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID NOT NULL REFERENCES public.orders(id) ON DELETE CASCADE,
  sku TEXT NOT NULL,
  name TEXT NOT NULL,
  price NUMERIC(10,2) NOT NULL,
  image_url TEXT NOT NULL,
  quantity INT NOT NULL DEFAULT 1
);
ALTER TABLE public.order_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "order_items_read" ON public.order_items FOR SELECT
  USING (EXISTS (SELECT 1 FROM public.orders o WHERE o.id = order_id AND o.user_id = auth.uid()));
CREATE POLICY "order_items_insert" ON public.order_items FOR INSERT
  WITH CHECK (EXISTS (SELECT 1 FROM public.orders o WHERE o.id = order_id AND o.user_id = auth.uid()));

-- REVIEWS
CREATE TABLE public.reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sku TEXT NOT NULL,
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  reviewer_name TEXT NOT NULL,
  rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;
CREATE POLICY "reviews_public_read" ON public.reviews FOR SELECT USING (true);
CREATE POLICY "reviews_auth_insert" ON public.reviews FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);

-- WISHLISTS
CREATE TABLE public.wishlists (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  sku TEXT NOT NULL,
  name TEXT NOT NULL,
  price TEXT NOT NULL,
  image_url TEXT NOT NULL,
  rating NUMERIC(3,2) NOT NULL,
  review_count INT NOT NULL DEFAULT 0,
  is_coming_soon BOOLEAN NOT NULL DEFAULT FALSE,
  added_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (user_id, sku)
);
ALTER TABLE public.wishlists ENABLE ROW LEVEL SECURITY;
CREATE POLICY "wishlists_own" ON public.wishlists FOR ALL
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- INDEXES
CREATE INDEX idx_orders_user_id ON public.orders(user_id);
CREATE INDEX idx_order_items_order_id ON public.order_items(order_id);
CREATE INDEX idx_reviews_sku ON public.reviews(sku);
CREATE INDEX idx_wishlists_user_id ON public.wishlists(user_id);
CREATE INDEX idx_products_tags ON public.products USING gin(tags);
```

---

## Phased Implementation

### Phase 1 — Foundation + Auth + Orders (this session)
**Highest priority: orders are lost on every restart. Fix that first.**

#### Files to create
- `lib/services/supabase_service.dart` — thin singleton wrapping `Supabase.instance.client`; exposes `signIn`, `signUp`, `signOut`, `currentUser`, `authStateStream`
- `lib/providers/auth_provider.dart` — `ChangeNotifier` that reads `currentUser` on init and listens to `authStateStream`; exposes `isAuthenticated`, `userId`

#### Files to modify

**`pubspec.yaml`** — add `supabase_flutter: ^2.8.0` under dependencies

**`lib/main.dart`**
- Make `main()` async; call `await Supabase.initialize(url: kSupabaseUrl, anonKey: kSupabaseAnonKey)` before `runApp`
- Add `AuthProvider` as first provider in `MultiProvider`
- Replace plain `ChangeNotifierProvider<OrderProvider>` with `ChangeNotifierProxyProvider<AuthProvider, OrderProvider>`:
  - on auth: call `orders.loadOrders(userId)` 
  - on sign-out: call `orders.clearForSignOut()`

**`lib/providers/order_provider.dart`**
- Add `String? _loadedForUserId` guard (prevent duplicate fetches)
- `placeOrder()` becomes `Future<Order>`:
  1. Insert row into `public.orders` → get back UUID
  2. Batch-insert `CartItem`s into `public.order_items`
  3. On failure: delete orphan order row
  4. Fall back to in-memory if user is not authenticated (guest mode preserved)
- Add `loadOrders(String userId)` — queries orders + order_items from Supabase, populates `_orders`
- Add `clearForSignOut()` — clears `_orders` and `_loadedForUserId`

**`lib/screens/login_screen.dart`**
- Replace `_userIdController` with `_emailController` + `_passwordController`
- `_login()` calls `SupabaseService.instance.signIn(email, password)` — catch `AuthException`, show `message`
- Add Sign Up button calling `SupabaseService.instance.signUp(email, password)`  
- `_logout()` calls `SupabaseService.instance.signOut()`
- Remove the "Make sure backend is running" amber warning banner
- Keep all existing visual structure (AppBar, button styling)

**`lib/screens/checkout_review_page.dart`**
- `_placeOrder()` becomes `async` (currently sync) — show loading spinner on "Place Order" button while the Supabase write completes

---

### Phase 2 — Reviews Migration
- `ReviewProvider.addReview()` → insert into `public.reviews` (with `user_id` if authenticated)
- `ReviewProvider.loadReviews(sku)` → query Supabase lazily (once per SKU per session via `Set<String> _loadedSkus`)
- Map `created_at` ISO timestamp → relative date string in `Review.fromJson`
- Remove `SharedPreferences` dependency from `ReviewProvider`

### Phase 3 — Products from Supabase
- Create `lib/models/product.dart` — `Product` model with `fromJson` mapping snake_case columns; `price` getter returns `'\$${value.toStringAsFixed(2)}'`
- Create `lib/services/product_service.dart` — `fetchByTag(tag)`, `fetchByCategory(category)`, `searchProducts(query)`
- `EcommerceHomePage` — replace `static const` lists with async fetches in `initState`; add loading skeleton
- `CategoryProductsPage` — replace `_categoryProducts` map with `ProductService.fetchByCategory()` in `initState`
- `ProductDetailPage` — replace hardcoded `_crocs` list with `ProductService.fetchByCategory('Fashion', limit: 3)`

### Phase 4 — Wishlist Sync
- `WishlistProvider` gets `loadFromSupabase(userId)` / `loadGuest()` split
- `toggle()` / `remove()` write to Supabase for auth users, SharedPreferences for guests
- On login: merge guest wishlist into Supabase via upsert

---

## Key Technical Constraints

| Constraint | Solution |
|---|---|
| `placeOrder` currently sync | Make async, show loader in `CheckoutReviewPage` |
| `price` is String in Dart, NUMERIC in DB | `Product` model formats on read; Cart/Wishlist keep String |
| RLS blocks unauthenticated order writes | Guest orders remain in-memory only |
| Auth state available before `runApp` | `Supabase.initialize()` restores session; `AuthProvider` reads it immediately in constructor |
| Duplicate `loadOrders` calls | `_loadedForUserId` guard in `OrderProvider` |

---

## Critical Files

| File | Change |
|---|---|
| `lib/config.dart` | Add `kSupabaseUrl`, `kSupabaseAnonKey` |
| `pubspec.yaml` | Add `supabase_flutter: ^2.8.0` |
| `lib/main.dart` | Async init, ProxyProvider wiring |
| `lib/providers/order_provider.dart` | Full rewrite — Supabase persistence |
| `lib/screens/login_screen.dart` | Replace OneSignal auth with Supabase Auth |
| `lib/screens/checkout_review_page.dart` | Make `_placeOrder` async |
| `lib/services/supabase_service.dart` | New file |
| `lib/providers/auth_provider.dart` | New file |

---

## Verification
1. Run `flutter pub get` after adding the package
2. Cold-start the app → place an order → force-quit → reopen → order should still appear
3. Sign up with email → sign out → sign in → wishlist and orders should persist
4. Check Supabase dashboard Table Editor to confirm rows were inserted
