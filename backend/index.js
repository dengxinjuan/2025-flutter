/**
 * OneSignal Identity Verification – JWT backend
 * Run locally: cd backend && npm install && npm start
 * Server listens on http://localhost:3000 (use http://10.0.2.2:3000 from Android emulator)
 */

require('dotenv').config();
const express = require('express');
const cors = require('cors');
const jwt = require('jsonwebtoken');

const app = express();
const PORT = process.env.PORT || 3000;

// ----- Middleware -----
// Allow JSON body (e.g. { "userId": "..." })
app.use(express.json());
// Allow Flutter app (emulator or device) to call this server
app.use(cors());

// ----- Env: OneSignal App ID and private key (PEM) -----
const APP_ID = process.env.ONESIGNAL_APP_ID;
const PRIVATE_KEY_PEM = process.env.ONESIGNAL_IDENTITY_VERIFICATION_PRIVATE_KEY;

/**
 * Get the private key string for ES256 signing.
 * If the key in .env uses literal \n for newlines, convert them to real newlines.
 */
function getPrivateKey() {
  if (!PRIVATE_KEY_PEM) return null;
  return PRIVATE_KEY_PEM.replace(/\\n/g, '\n');
}

/**
 * Build and sign a JWT for OneSignal Identity Verification.
 * Payload: iss (App ID), exp (expiration), identity.external_id
 * Algorithm: ES256 (required by OneSignal).
 */
function signOneSignalJwt(externalId) {
  const privateKey = getPrivateKey();
  if (!privateKey) {
    throw new Error('ONESIGNAL_IDENTITY_VERIFICATION_PRIVATE_KEY is not set in .env');
  }
  const now = Math.floor(Date.now() / 1000);
  const exp = now + 60 * 60; // 1 hour from now
  const payload = {
    iss: APP_ID,
    exp,
    identity: {
      external_id: externalId,
    },
  };
  return jwt.sign(payload, privateKey, { algorithm: 'ES256' });
}

// ----- POST /auth/token and POST /auth/login – issue JWT for a user -----
// Body: { "userId": "optional-demo-id" }. If missing, we generate a demo external ID.
function handleAuthToken(req, res) {
  try {
    const userId = req.body?.userId;
    const externalId = userId && String(userId).trim() ? String(userId).trim() : `demo-${Date.now()}`;

    if (!APP_ID) {
      return res.status(500).json({ error: 'ONESIGNAL_APP_ID is not set in .env' });
    }

    const token = signOneSignalJwt(externalId);
    res.json({ externalId, jwt: token });
  } catch (err) {
    console.error('/auth/token error:', err.message);
    res.status(500).json({ error: err.message || 'Failed to sign JWT' });
  }
}

app.post('/auth/token', handleAuthToken);
app.post('/auth/login', handleAuthToken);

// ----- POST /auth/refresh – issue a new JWT for the same external ID -----
// Body: { "externalId": "..." }. Used when OneSignal invalidates the previous JWT.
app.post('/auth/refresh', (req, res) => {
  try {
    const externalId = req.body?.externalId;
    if (!externalId || !String(externalId).trim()) {
      return res.status(400).json({ error: 'externalId is required in body' });
    }

    const token = signOneSignalJwt(String(externalId).trim());
    res.json({ jwt: token });
  } catch (err) {
    console.error('/auth/refresh error:', err.message);
    res.status(500).json({ error: err.message || 'Failed to sign JWT' });
  }
});

// ----- Health check (optional) -----
app.get('/health', (req, res) => {
  res.json({ ok: true, appId: APP_ID ? 'set' : 'missing', privateKey: PRIVATE_KEY_PEM ? 'set' : 'missing' });
});

// ----- Start server -----
app.listen(PORT, () => {
  if (!APP_ID || !getPrivateKey()) {
    console.warn('Warning: ONESIGNAL_APP_ID or ONESIGNAL_IDENTITY_VERIFICATION_PRIVATE_KEY missing in .env. Copy .env.example to .env and fill in values.');
  }
  console.log(`OneSignal JWT backend running at http://localhost:${PORT}`);
  console.log('  POST /auth/token  (body: { "userId": "optional-id" }) -> { externalId, jwt }');
  console.log('  POST /auth/refresh (body: { "externalId": "..." }) -> { jwt }');
});
