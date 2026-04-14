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

// ----- OneSignal REST API helpers -----
const REST_API_KEY = process.env.ONESIGNAL_REST_API_KEY;
const OS_API_BASE = 'https://api.onesignal.com';

/**
 * POST /notify-me
 * Called when user taps "Notify Me When Available" in the app.
 * Sets OneSignal tags: availability=notify_me_requested, product_name=<sku>
 * Body: { externalId, sku, productName }
 */
app.post('/notify-me', async (req, res) => {
  try {
    const { externalId, sku, productName } = req.body || {};
    if (!externalId || !sku) {
      return res.status(400).json({ error: 'externalId and sku are required' });
    }
    if (!REST_API_KEY) {
      return res.status(500).json({ error: 'ONESIGNAL_REST_API_KEY not set in .env' });
    }

    // Set tags on the user via OneSignal REST API
    const tagRes = await fetch(`${OS_API_BASE}/apps/${APP_ID}/users/by/external_id/${encodeURIComponent(externalId)}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Key ${REST_API_KEY}`,
      },
      body: JSON.stringify({
        properties: {
          tags: {
            availability: 'notify_me_requested',
            [`product_name`]: sku,
          },
        },
      }),
    });

    if (!tagRes.ok) {
      const errBody = await tagRes.text();
      console.error('OneSignal tag error:', errBody);
      return res.status(502).json({ error: 'Failed to set OneSignal tags', detail: errBody });
    }

    console.log(`✅ [notify-me] Tagged ${externalId} for SKU: ${sku}`);
    res.json({ success: true, externalId, sku });
  } catch (err) {
    console.error('/notify-me error:', err.message);
    res.status(500).json({ error: err.message });
  }
});

/**
 * POST /simulate-restock
 * Simulates a restock event — sends "Buy Now" push to all users tagged
 * with availability=notify_me_requested AND product_name=<sku>.
 * Body: { sku, productName, price, imageUrl }
 */
app.post('/simulate-restock', async (req, res) => {
  try {
    const { sku, productName, price, imageUrl } = req.body || {};
    if (!sku || !productName) {
      return res.status(400).json({ error: 'sku and productName are required' });
    }
    if (!REST_API_KEY) {
      return res.status(500).json({ error: 'ONESIGNAL_REST_API_KEY not set in .env' });
    }

    const notifRes = await fetch(`${OS_API_BASE}/notifications`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Key ${REST_API_KEY}`,
      },
      body: JSON.stringify({
        app_id: APP_ID,
        filters: [
          { field: 'tag', key: 'availability', relation: '=', value: 'notify_me_requested' },
          { operator: 'AND' },
          { field: 'tag', key: 'product_name', relation: '=', value: sku },
        ],
        target_channel: 'push',
        headings: { en: `${productName} is back in stock! 🎉` },
        contents: { en: `Tap to buy now before it sells out again.` },
        big_picture: imageUrl || '',
        url: 'crocs://product/' + sku,
        custom_data: {
          saved: [{ product_name: productName, price: price || '', image_url: imageUrl || '' }],
          sku,
          type: 'restock',
        },
      }),
    });

    const notifBody = await notifRes.json();
    if (!notifRes.ok) {
      console.error('OneSignal push error:', notifBody);
      return res.status(502).json({ error: 'Failed to send push', detail: notifBody });
    }

    console.log(`🚀 [simulate-restock] Push sent for SKU: ${sku}`, notifBody);
    res.json({ success: true, sku, notificationId: notifBody.id });
  } catch (err) {
    console.error('/simulate-restock error:', err.message);
    res.status(500).json({ error: err.message });
  }
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
