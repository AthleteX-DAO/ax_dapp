const { onRequest } = require("firebase-functions/v2/https");

const COINGECKO_BASE = "https://api.coingecko.com/api/v3";

exports.coingeckoProxy = onRequest({ region: "asia-east1" }, async (req, res) => {
  res.set("Access-Control-Allow-Origin", "*");
  res.set("Access-Control-Allow-Methods", "GET,OPTIONS");
  res.set("Access-Control-Allow-Headers", "Content-Type");
  res.set("Cache-Control", "public, max-age=30");

  console.log(`[coingeckoProxy] ${req.method} ${req.path} - Query:`, req.query);

  if (req.method === "OPTIONS") {
    res.status(204).send("");
    return;
  }

  try {
    // Firebase Hosting rewrites /api/** to this function, so path is /api/markets or /api/market_chart
    // We need to strip /api prefix first
    let path = (req.path || "/").replace(/^\/api\/?/, "").replace(/^\/+/, "");
    const [endpoint] = path.split("/");
    
    console.log(`[coingeckoProxy] Parsed endpoint: "${endpoint}" from path: "${req.path}"`);

    if (endpoint === "markets") {
      const ids = req.query.ids || "";
      const vsCurrency = req.query.vs_currency || "usd";
      const priceChange = req.query.price_change_percentage || "1h,24h";

      const url = new URL(`${COINGECKO_BASE}/coins/markets`);
      url.searchParams.set("vs_currency", vsCurrency);
      url.searchParams.set("ids", ids);
      url.searchParams.set("price_change_percentage", priceChange);

      const response = await fetch(url.toString(), {
        headers: { "accept": "application/json" },
      });

      const body = await response.text();
      const contentType = response.headers.get("content-type") || "application/json";
      res.set("Content-Type", contentType);
      res.status(response.status).send(body);
      return;
    }

    if (endpoint === "market_chart") {
      const id = req.query.id;
      if (!id) {
        res.status(400).json({ error: "Missing id" });
        return;
      }

      const vsCurrency = req.query.vs_currency || "usd";
      const days = req.query.days || "1";

      const url = new URL(`${COINGECKO_BASE}/coins/${id}/market_chart`);
      url.searchParams.set("vs_currency", vsCurrency);
      url.searchParams.set("days", days);

      const response = await fetch(url.toString(), {
        headers: { "accept": "application/json" },
      });

      const body = await response.text();
      const contentType = response.headers.get("content-type") || "application/json";
      res.set("Content-Type", contentType);
      res.status(response.status).send(body);
      return;
    }

    res.status(404).json({ error: "Unknown endpoint" });
  } catch (error) {
    res.status(500).json({ error: "Proxy error", details: String(error) });
  }
});
