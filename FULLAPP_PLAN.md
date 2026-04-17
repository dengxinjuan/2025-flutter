# Full App Implementation Plan
_Last updated: 2026-04-17_

## Current State
| What exists | Status |
|---|---|
| Home page (Featured, Best Sellers, New Arrivals, Top Rated, Special Offers) | ✅ Done |
| Category pages with 2-column grid | ✅ Done |
| Product detail page | ✅ Done |
| "Notify Me" / Coming Soon flow (OneSignal) | ✅ Done |
| Login screen (UI only) | ⚠️ UI only |
| Node.js backend (JWT + notify-me + simulate-restock) | ✅ Done |
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

## Phase 2 — Authentication
### 2.1 Real login / register
- Add email + password fields to `LoginScreen`
- Connect to backend (`POST /login`, `POST /register`)
- Store JWT token in `SharedPreferences`
- Auto-login on app start if token exists
- Logout clears token and resets OneSignal external ID

### 2.2 Profile page
- Show user name, email, avatar
- Edit profile info
- Logout button

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
### 6.1 Checkout flow ✅ COMPLETE (no real backend)
1. **Shipping** — name, phone, address, city, zip (validated form)
2. **Payment** — choose method (credit card, bank transfer, e-wallet)
3. **Review** — order summary with items, shipping address, payment, USD total
4. **Confirmation** — success screen with order ID, "Continue Shopping"
- `OrderProvider` stores placed orders in memory

### 6.2 Payment integration
- Integrate **Midtrans** (standard for Indonesian apps)
  - Backend: create Midtrans transaction token
  - App: open Midtrans payment page via WebView
  - Handle success/failure callbacks

### 6.3 Orders page
- List of past orders with status (Processing, Shipped, Delivered)
- Tap order → order detail with items + tracking info

---

## Phase 7 — Real Backend & Database
Currently all product data is hardcoded in Dart. This needs to move to a database.

### 7.1 Database
- Add **Supabase** or extend existing Node.js backend with **SQLite/PostgreSQL**
- Tables: `users`, `products`, `categories`, `orders`, `order_items`, `reviews`

### 7.2 API endpoints needed
| Method | Endpoint | Purpose |
|---|---|---|
| GET | `/products` | All products (with filters) |
| GET | `/products/:sku` | Single product detail |
| GET | `/categories` | Category list |
| POST | `/cart` | Add to cart (server-side cart) |
| POST | `/orders` | Place order |
| GET | `/orders/:userId` | User order history |
| POST | `/reviews` | Submit review |

### 7.3 App changes
- Replace hardcoded `_featuredProducts`, `_bestSellers` etc. with API calls
- Add loading skeletons while data fetches
- Handle errors / empty states

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
| `supabase_flutter` | Database (if using Supabase) |
| `flutter_svg` | SVG icons |
