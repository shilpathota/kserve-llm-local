// ui/server.js
const express = require('express');
const path = require('path');
const { createProxyMiddleware } = require('http-proxy-middleware');
const morgan = require('morgan');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;
const KSERVE_URL = process.env.KSERVE_URL || 'http://localhost:8085';

// --- middleware
app.use(morgan('dev'));
app.use(cors());                          // dev only
app.use(express.json({ limit: '2mb' }));

// --- static UI (index.html is in the /ui folder)
app.use(express.static(path.join(__dirname)));

// --- proxy OpenAI-style endpoints exactly as-is
app.use(
  '/openai',
  createProxyMiddleware({
    target: KSERVE_URL,
    changeOrigin: true,
    // keep path as-is (/openai/v1/..)
    pathRewrite: (p) => p,
    onProxyReq: (proxyReq) => proxyReq.setHeader('Connection', 'close'),
  })
);

// --- proxy KServe v1 endpoints exactly as-is
app.use(
  '/v1',
  createProxyMiddleware({
    target: KSERVE_URL,
    changeOrigin: true,
    pathRewrite: (p) => p,
    onProxyReq: (proxyReq) => proxyReq.setHeader('Connection', 'close'),
  })
);

// --- health
app.get('/healthz', (_req, res) => res.json({ ok: true }));

// --- root only (NO '*' or '/*' catch-alls)
app.get('/', (_req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

app.listen(PORT, () => {
  console.log(`UI on http://localhost:${PORT} (proxy -> ${KSERVE_URL})`);
});
