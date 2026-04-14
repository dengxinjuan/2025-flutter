# Crocs E-Commerce Flutter Demo

A Flutter e-commerce demo app featuring a Crocs product catalog with a **Coming Soon / Back-to-Stock** notification flow powered by OneSignal.

---

## Features

- **E-Commerce Home** — Product grid with Featured and Best Sellers sections
- **Product Detail Page** — Figma-replicated detail view with reviews, description, shop info
- **Coming Soon flow** — Products marked as coming soon show a "Notify Me When Available" button
- **OneSignal tagging** — Tapping "Notify Me" sets tags on the user (`availability`, `product_name`) directly via the OneSignal SDK
- **Restock simulation** — Backend endpoint to send a "Buy Now" push to all tagged users (for testing)

---

## Setup

### 1. Flutter app

```bash
flutter pub get
flutter run
```

Add your OneSignal App ID in `lib/config.dart`:
```dart
const String kOneSignalAppId = 'YOUR_ONESIGNAL_APP_ID';
```

### 2. Backend (optional — only needed to test restock push)

```bash
cd backend
cp .env.example .env   # fill in your OneSignal credentials
npm install
npm start              # runs at http://localhost:3000
```

Required `.env` values:
```
ONESIGNAL_APP_ID=
ONESIGNAL_IDENTITY_VERIFICATION_PRIVATE_KEY=
ONESIGNAL_REST_API_KEY=
```

### 3. Test a restock push

```bash
curl -X POST http://localhost:3000/simulate-restock \
  -H "Content-Type: application/json" \
  -d '{"sku":"pink_clogs","productName":"Crocs Pink Edition","price":"Rp. 699.000"}'
```

---

## Backend Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/auth/token` | Issue a JWT for OneSignal Identity Verification |
| `POST` | `/auth/refresh` | Refresh an existing JWT |
| `POST` | `/notify-me` | Set OneSignal tags for a user (coming soon request) |
| `POST` | `/simulate-restock` | Send "Buy Now" push to all tagged users |
| `GET`  | `/health` | Health check |

---

## Project Structure

```
├── lib/
│   ├── main.dart
│   ├── config.dart                  # App config (OneSignal App ID)
│   ├── screens/
│   │   ├── ecommerce_home_page.dart
│   │   ├── product_detail_page.dart
│   │   └── login_screen.dart
│   └── services/
│       ├── onesignal_auth_service.dart
│       └── coming_soon_service.dart
├── backend/
│   ├── index.js
│   ├── .env.example
│   └── .env                         # Never committed
└── crocs-coming-soon-plan.md        # Implementation plan
```
