# Crocs "Coming Soon / Back to Stock" — Implementation Plan

## Overview
When a user taps "Notify Me When Available" in the Crocs app:
1. Immediately acknowledge their interest ("You're on the list!")
2. Once the SKU is restocked, send a "Buy Now" push notification
3. Only notify users who asked, only once per restock

---

## ✅ Done (2026-04-13)

### Simulator
- [x] Downloaded iOS 26.4 runtime to work with Xcode 26.4

### Flutter App
- [x] **Product Detail Page** (`lib/screens/product_detail_page.dart`)
  - Figma replica (screen 009) with Crocs content
  - Image, name, price, rating, store info, description, reviews, featured products
  - Tappable from home page product cards
- [x] **Coming Soon state** on product detail page
  - Orange "Coming Soon" badge instead of availability
  - "Notify Me When Available" button instead of Wishlist + Add to Cart
  - After tap: button turns green → "You're on the list ✓" + snackbar
- [x] **OneSignal tagging** (no login, no backend required)
  - Sets tags directly via SDK: `availability=notify_me_requested`, `product_name=<sku>`
- [x] **Home page** updated
  - All products changed to Crocs
  - Coming soon products: "Crocs Pink Edition" (`pink_clogs`), "Crocs Blue Clogs" (`blue_clogs`)
  - Tapping any card navigates to detail page

### Backend (`backend/index.js`)
- [x] `POST /notify-me` — sets OneSignal tags via REST API
- [x] `POST /simulate-restock` — sends "Buy Now" push to all tagged users

---

## 🔲 Next Steps

### Step 1 — Test the full push flow (Option 1 from PDF)
- [ ] Get OneSignal REST API Key from: OneSignal Dashboard → Settings → Keys & IDs
- [ ] Add to `backend/.env`: `ONESIGNAL_REST_API_KEY=<your key>`
- [ ] Start backend: `cd backend && npm start`
- [ ] Tap "Notify Me" in app → verify tags appear in OneSignal dashboard
- [ ] Call `/simulate-restock` to trigger "Buy Now" push:
  ```sh
  curl -X POST http://localhost:3000/simulate-restock \
    -H "Content-Type: application/json" \
    -d '{"sku":"pink_clogs","productName":"Crocs Pink Edition","price":"Rp. 699.000"}'
  ```
- [ ] Verify push notification is received on device/simulator

### Step 2 — Option 2: OneSignal Journey / Automated Flow (from PDF)
- [ ] Create custom event `notify_me_requested` in OneSignal dashboard
- [ ] Trigger it from Flutter when user taps "Notify Me":
  ```dart
  OneSignal.User.sendOutcome('notify_me_requested');
  // or use custom event API with sku property
  ```
- [ ] Set up Journey in OneSignal dashboard:
  - Entry: custom event `notify_me_requested`
  - Node 1: Immediate push — "Thanks, we'll let you know when Pink Clogs are in stock"
  - Wait Until: custom event `sku_stocked` (with SKU matching)
  - Node 2: "Buy Now" push — "Pink Clogs are back! Tap to buy now"
  - Exit: mark user as notified

### Step 3 — "Back in Stock" UI state
- [ ] Add `isBackInStock` product state
- [ ] When push notification is tapped, navigate to product detail and show it as available
- [ ] Handle deep link: `crocs://product/<sku>`

### Step 4 — Throttling (from PDF)
- [ ] Cap "Notify Me" requests per SKU (e.g. max 1,000 per SKU)
- [ ] Show "Waitlist full" state when cap is reached

---

## Key Files
| File | Purpose |
|------|---------|
| `lib/screens/product_detail_page.dart` | Detail page + Notify Me logic |
| `lib/screens/ecommerce_home_page.dart` | Home page with product list |
| `lib/services/onesignal_auth_service.dart` | OneSignal auth singleton |
| `lib/services/coming_soon_service.dart` | Backend service (for future use) |
| `backend/index.js` | Express backend — JWT + notify-me + simulate-restock |
| `backend/.env` | OneSignal credentials (needs REST API key) |

## Reference
- Figma: https://www.figma.com/design/Rln7pVYbArGhZkyycrNnSK/E-Commerce---Mobile-Apps--Community-
- PDF spec: `~/Desktop/Crocs _Coming Soon_ Flow - Google Docs.pdf`
- OneSignal App ID: `db231987-4182-42ba-a4b2-638cf90b29f6`
