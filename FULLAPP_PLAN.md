# Full App Implementation Plan
_Last updated: 2026-04-16_

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
| Wishlist, Orders, Search, Checkout, Payment | ❌ Missing |

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

## Phase 4 — Wishlist
### 4.1 Favorite toggle
- Heart icon on every product card (home + category pages)
- Tapping toggles the item in `WishlistProvider`
- Persisted to `SharedPreferences` so it survives app restart

### 4.2 Wishlist page
- Grid of favorited products
- Tap to go to product detail
- "Add All to Cart" button

---

## Phase 5 — Search & Filter
### 5.1 Working search
- Search bar on home page and category page becomes functional
- Searches across all products by name
- Shows results in real-time as user types

### 5.2 Filter & Sorting (category page)
- "Filter & Sorting" bottom sheet with:
  - Sort by: Price (low→high, high→low), Rating, Newest
  - Filter by: Price range slider, Rating (4★+, 3★+), Coming Soon toggle
- Apply/Reset buttons

---

## Phase 6 — Checkout & Orders
### 6.1 Checkout flow (3 screens)
1. **Shipping** — name, address, city, postal code
2. **Payment** — choose method (bank transfer, credit card, e-wallet)
3. **Review** — order summary, place order button

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
