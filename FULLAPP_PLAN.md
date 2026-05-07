# Full App Implementation Plan
_Last updated: 2026-04-20_

## Current State
| What exists | Status |
|---|---|
| Home page (Featured, Best Sellers, New Arrivals, Top Rated, Special Offers) | ✅ Done |
| Category pages with 2-column grid | ✅ Done |
| Product detail page | ✅ Done |
| "Notify Me" / Coming Soon flow (OneSignal) | ✅ Done |
| Login screen (Supabase email/password auth) | ✅ Done |
| Node.js backend (JWT + notify-me + simulate-restock) | ✅ Done |
| Supabase project + all tables (products, profiles, orders, order_items, reviews, wishlists) | ✅ Done |
| Supabase Auth wired (sign in, sign up, sign out, session restore) | ✅ Done |
| Orders persisted to Supabase for logged-in users (guest = in-memory) | ✅ Done |
| Cart (CartProvider + CartPage + Add to Cart wired) | ✅ Done |
| Cart badge on header + ORDER tab navigation | ✅ Done |
| All prices in USD, all UI text in English | ✅ Done |
| Checkout flow (shipping → payment → review → confirmation) | ✅ Done |
| Global search + category search | ✅ Done |
| Filter & Sorting sheet (price range, in-stock, sort) | ✅ Done |
| Wishlist (WishlistProvider + WishlistPage + heart icons) | ✅ Done |
| Orders page, Real backend, Payment integration | ❌ Missing |

---

## Phase 1 — State Management & Navigation (Foundation) ✅ COMPLETE
Everything else depends on this being in place first.

### 1.1 Add state management ✅
- Added `provider: ^6.1.2` package
- Created `CartProvider` (lib/providers/cart_provider.dart) — holds cart items, quantities, USD total
- Wrapped `MaterialApp` in `ChangeNotifierProvider`

### 1.2 Wire up bottom navigation ✅ (partial)
- ORDER tab → navigates to `CartPage` ✅
- Cart badge counter on header icon (home + product detail pages) ✅
- WISHLIST, LOGIN tabs — still UI only (Phase 2/4)

---

## Phase 2 — Authentication ✅ COMPLETE (via Supabase)
### 2.1 Real login / register ✅
- Email + password fields on `LoginScreen`
- Supabase Auth: `signIn`, `signUp`, `signOut`
- Session auto-restored on app start via `Supabase.initialize`
- `AuthProvider` (`lib/providers/auth_provider.dart`) — listens to auth state stream, exposes `isAuthenticated`, `userId`, `email`
- `SupabaseService` singleton (`lib/services/supabase_service.dart`) — wraps Supabase client
- LOGIN tab in bottom nav now navigates to `LoginScreen`
- App fully works without login (guest mode preserved)

### 2.2 Profile page ❌ TODO (high priority for demo)
- Show user email from Supabase Auth
- Logout button
- Link to Orders page

---

## Phase 3 — Cart ✅ COMPLETE
### 3.1 Add to Cart flow ✅
- "Add to Cart" button on `ProductDetailPage` wired to `CartProvider.addItem()`
- Shows floating snackbar confirmation on add
- Cart icon in header shows live red badge with item count

### 3.2 Cart page ✅ (lib/screens/cart_page.dart)
- List of cart items (image, name, price, quantity +/− controls)
- Swipe-to-delete with red background
- Live item count + USD total at bottom
- "Proceed to Checkout" button (coming soon snackbar — Phase 6)
- "Clear" button with confirm dialog

---

## Phase 4 — Wishlist ✅ COMPLETE
### 4.1 Favorite toggle ✅
- Heart icon on category product cards (top-right overlay)
- Tapping toggles the item in `WishlistProvider`
- Persisted to `SharedPreferences` so it survives app restart
- Product detail page Wishlist button synced to global provider state
- Note: heart icons intentionally removed from home page cards (user preference)

### 4.2 Wishlist page ✅ (lib/screens/wishlist_page.dart)
- 2-column grid of favorited products
- Tap heart to remove; tap card to go to product detail
- "Add All to Cart" button
- Clear all with confirm dialog; empty state illustration
- WISHLIST bottom nav tab navigates here

---

## Phase 5 — Search & Filter ✅ COMPLETE
### 5.1 Working search ✅
- Home search bar taps through to `SearchPage` (lib/screens/search_page.dart)
- Searches across all products globally by name in real-time
- Category page has its own inline search bar

### 5.2 Filter & Sorting (category page) ✅
- "Filter & Sorting" bottom sheet matching Figma design:
  - **Filter tab:** Price range slider ($0–$400), "In Stock Only" checkbox
  - **Sorting tab:** Default, Name A–Z, Name Z–A, Price High–Low, Price Low–High
- Active filter badge on button when filters are applied
- Apply/Reset buttons

---

## Phase 6 — Checkout & Orders
### 6.1 Checkout flow ✅ COMPLETE (Supabase-backed)
1. **Shipping** — name, phone, address, city, zip (validated form)
2. **Payment** — choose method (credit card, bank transfer, e-wallet)
3. **Review** — order summary with items, shipping address, payment, USD total
4. **Confirmation** — success screen with order ID, "Continue Shopping"
- Logged-in users: order + items written to Supabase `orders` / `order_items` tables; loaded back on next login
- Guest users: in-memory only (lost on restart)
- `CheckoutReviewPage` shows loading spinner during Supabase write

### 6.2 Payment integration ⏭️ SKIPPED (portfolio decision)
- Real payment (Stripe/Midtrans) skipped — requires hosted backend + business account
- Current fake payment selection screen is sufficient for demo purposes
- Stripe test mode is an option in the future if a real backend is hosted
- **Future:** Stripe with test cards (4242 4242 4242 4242) if needed

### 6.3 Orders page ❌ TODO (high priority for demo)
- List of past orders pulled from Supabase (logged-in users)
- Show order ID, date, total, payment method
- Tap order → order detail with items + shipping info

---

## Phase 7 — Real Backend & Database (Supabase)
### 7.1 Supabase setup ✅ COMPLETE
- Supabase project created, connected via MCP
- All tables created with RLS policies and indexes:
  `products`, `profiles`, `orders`, `order_items`, `reviews`, `wishlists`
- `supabase_flutter 2.12.4` added to `pubspec.yaml`
- `Supabase.initialize()` called in `main()` before `runApp`
- Orders + auth fully wired (see Phase 2 + Phase 6.1)

### 7.2 Reviews migration ❌ (Supabase Phase 2)
- `ReviewProvider.addReview()` → insert into `public.reviews`
- `ReviewProvider.loadReviews(sku)` → query Supabase lazily per SKU
- Remove `SharedPreferences` dependency from `ReviewProvider`

### 7.3 Products from Supabase ❌ (Supabase Phase 3)
- Seed product data into `public.products` table
- Create `lib/models/product.dart` + `lib/services/product_service.dart`
- Replace hardcoded `_featuredProducts`, `_bestSellers` etc. with Supabase queries
- Add loading skeletons while data fetches

### 7.4 Wishlist sync ❌ (Supabase Phase 4)
- `WishlistProvider` split: `loadFromSupabase(userId)` vs `loadGuest()`
- On login: merge guest wishlist into Supabase via upsert
- `toggle()` / `remove()` write to Supabase for auth users, SharedPreferences for guests

---

## Phase 8 — Reviews & Ratings
### 8.1 Product detail
- Show real reviews (reviewer name, rating, comment, date)
- Paginated review list

### 8.2 Submit a review
- Only show "Write a Review" if user purchased the product
- Star picker + text input
- Submit goes to backend

---

## Phase 9 — Push Notifications (extend what's built)
Already have OneSignal wired for "Notify Me". Extend it:

| Trigger | Notification |
|---|---|
| Product back in stock | "Crocs Pink Edition is back!" → deep link to product |
| Order status change | "Your order has shipped!" → deep link to order detail |
| Flash sale starts | "Special Offers just dropped!" → deep link to home |

### 9.1 Deep linking
- Handle `onesignal.notification.opened` callback
- Parse `sku` or `orderId` from notification data
- Navigate to correct screen on tap

---

## Phase 10 — Polish
- **Onboarding screens** — shown once on first launch
- **Empty states** — empty cart, empty wishlist, no search results
- **Offline handling** — show cached data when no internet
- **Image caching** — use `cached_network_image` package instead of `Image.network`
- **App icon & splash screen** — replace default Flutter icon
- **Analytics** — log screen views and button taps to OneSignal or Firebase

---

## Suggested Build Order
```
Phase 1 (State + Nav)  →  Phase 2 (Auth)  →  Phase 3 (Cart)
       ↓
Phase 4 (Wishlist)  →  Phase 5 (Search)  →  Phase 7 (Real backend)
       ↓
Phase 6 (Checkout + Payment)  →  Phase 8 (Reviews)
       ↓
Phase 9 (Notifications)  →  Phase 10 (Polish)
```

## Packages to add
| Package | Purpose | Status |
|---|---|---|
| `provider` | State management | ✅ Added (v6.1.2) |
| `go_router` | Declarative routing + deep links |
| `cached_network_image` | Image caching |
| `flutter_slidable` | Swipe-to-delete in cart |
| `shimmer` | Loading skeleton placeholders |
| `midtrans_sdk` | Payment |
| `supabase_flutter` | Auth + Database (Supabase) | ✅ Added (v2.12.4) |
| `flutter_svg` | SVG icons |
