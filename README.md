# 2025-flutter

A Flutter app with OneSignal push notifications and Identity Verification.

---

## Run the Flutter App

```bash
# 1. Boot the iOS Simulator
open -a Simulator

# 2. Run the app
flutter run
```

> First time? Run `flutter pub get` before `flutter run`.

---

## Run the Backend (OneSignal JWT Server)

The backend generates JWTs for OneSignal Identity Verification.

### 1. Set up the `.env` file

```bash
cd backend
cp .env.example .env
```

Edit `backend/.env` and fill in:
- `ONESIGNAL_APP_ID` — your OneSignal App ID
- `ONESIGNAL_IDENTITY_VERIFICATION_PRIVATE_KEY` — your PEM private key (with `\n` for newlines)

### 2. Install dependencies

```bash
cd backend
npm install
```

### 3. Start the server

```bash
cd backend
npm start
```

The server runs at **http://localhost:3000**.

### 4. Test it's working

```bash
# Health check
curl http://localhost:3000/health

# Generate a JWT for a user
curl -X POST http://localhost:3000/auth/token \
  -H "Content-Type: application/json" \
  -d '{"userId": "my-user-123"}'
```

### API Endpoints

| Method | Endpoint | Body | Description |
|--------|----------|------|-------------|
| `POST` | `/auth/token` | `{ "userId": "..." }` | Issue a JWT for a user |
| `POST` | `/auth/login` | `{ "userId": "..." }` | Same as `/auth/token` |
| `POST` | `/auth/refresh` | `{ "externalId": "..." }` | Refresh an existing JWT |
| `GET`  | `/health` | — | Check server status |

> From an Android emulator use `http://10.0.2.2:3000` instead of `localhost`.

---

## Project Structure

```
2025-flutter/
├── lib/                  # Flutter app source
│   ├── main.dart         # App entry point
│   └── screens/          # App screens
├── backend/              # Node.js JWT server
│   ├── index.js          # Express server
│   ├── .env              # Secrets (never commit this)
│   └── .env.example      # Template for .env
├── android/              # Android project
└── ios/                  # iOS project
```
