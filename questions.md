# Questions & Answers

A record of questions asked during the OneSignal Identity Verification implementation.

---

## JWT & Backend

**Q: Should we remove `-----BEGIN PRIVATE KEY-----` from the key?**
No. The `jsonwebtoken` library requires the full PEM format including the headers to recognize it as a PEM key. Removing the headers will break signing.

---

**Q: The key has `-----BEGIN PRIVATE KEY-----` instead of `-----BEGIN EC PRIVATE KEY-----`. Is that correct?**
Yes. There are two valid formats for EC private keys:
- `-----BEGIN EC PRIVATE KEY-----` — SEC1 / traditional EC format
- `-----BEGIN PRIVATE KEY-----` — PKCS#8 format (EC key wrapped in a standard container)

Both are valid. The `jsonwebtoken` library supports both for ES256 signing.

---

**Q: The OneSignal docs use `GET /generate-jwt/:externalId`. Our backend uses `POST /auth/token`. Why the difference?**
The docs use a simplified GET example just to demonstrate the concept. Our backend uses `POST` with a JSON body, which is the correct production practice — putting sensitive user IDs in URLs is less secure as URLs get logged by servers, proxies, and browser history.

---

**Q: What is `iat` in the JWT payload?**
`iat` stands for **Issued At** — a standard JWT field recording when the token was created. It's automatically added by the `jsonwebtoken` library. OneSignal doesn't require it but won't reject it either. It simply gets ignored.

- `iat` = when the token was created
- `exp` = `iat` + 3600 seconds (1 hour later)

---

**Q: The OneSignal docs don't mention `iat`. Is it a problem?**
No. The docs only list the fields they require (`iss`, `exp`, `identity`). Extra fields like `iat` are standard JWT fields that OneSignal will simply ignore.

---

## Subscriptions

**Q: When should I include subscriptions in the JWT — when user adds email? Push?**

| Subscription type | Include in JWT? | Notes |
|------------------|----------------|-------|
| Push | No | Handled automatically by the SDK |
| Email | Yes | Include in `subscriptions` field when user provides email |
| SMS | Yes | Include in `subscriptions` field when user provides phone number |

---

**Q: What if the user doesn't have an external ID when they provide an email — will the method fail?**
`identity` (which contains `external_id`) is a required field in the JWT payload. Without it the JWT itself is invalid. OneSignal needs to know which user to attach the email subscription to. If the user has no account yet, assign them a temporary ID (e.g. a UUID or `guest-{timestamp}`) before calling `OneSignal.login()`.

---

## iOS Simulator Networking

**Q: Why does the OneSignal external ID never appear in the dashboard when testing on the iOS Simulator?**

Root cause: the iOS Simulator cached a QUIC (HTTP/3) connection to `api.onesignal.com`. QUIC uses **UDP port 443**, which many Wi-Fi routers silently block. When UDP is blocked the QUIC connection stalls for **120 seconds** before failing, and the iOS OS never falls back to TCP. The OneSignal SDK then reschedules its initialization retry for another 135 seconds. Since the SDK never successfully reached the server, no OneSignal user is created and nothing appears in the dashboard.

The stuck state makes it worse: the SDK caches the failed login locally and on every subsequent launch says `"not creating new user due to logging into the same user"`, skipping the server call entirely.

**Fix:** Erase the Simulator to clear the QUIC Alt-Svc cache and the stuck SDK state:
```bash
xcrun simctl erase <device-udid>
# or via Xcode: Device and Simulators window → Erase All Content and Settings
```

After erasing, the Simulator will use HTTP/2 (TCP) which works reliably. If the issue recurs, erase again or test on a **real physical device** where QUIC fallback works properly.

