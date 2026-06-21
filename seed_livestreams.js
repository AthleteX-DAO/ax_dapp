const https = require('https');

const PROJECT_ID = 'athletex-prod';
const BASE_URL = `https://firestore.googleapis.com/v1/projects/${PROJECT_ID}/databases/(default)/documents/livestreams`;

const streams = [
  {
    title: 'Celtics vs Pacers — Eastern Conference Finals Game 6',
    url: 'https://www.youtube.com/watch?v=M7lc1UVf-VE',
    source: 'youtube',
    sport: 'Basketball',
    thumbnailUrl: 'https://img.youtube.com/vi/M7lc1UVf-VE/maxresdefault.jpg',
    isLive: true,
    isFeatured: true,
    marketId: null,
    metadata: { homeTeam: 'Celtics', awayTeam: 'Pacers', league: 'NBA' },
  },
  {
    title: 'Yankees vs Dodgers — MLB Highlights',
    url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    source: 'youtube',
    sport: 'Baseball',
    thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
    isLive: true,
    isFeatured: false,
    marketId: null,
    metadata: { homeTeam: 'Yankees', awayTeam: 'Dodgers', league: 'MLB' },
  },
  {
    title: 'Arsenal vs Liverpool — Premier League Matchday 38',
    url: 'https://www.youtube.com/watch?v=jNQXAC9IVRw',
    source: 'youtube',
    sport: 'Soccer',
    thumbnailUrl: 'https://img.youtube.com/vi/jNQXAC9IVRw/maxresdefault.jpg',
    isLive: true,
    isFeatured: false,
    marketId: null,
    metadata: { homeTeam: 'Arsenal', awayTeam: 'Liverpool', league: 'Premier League' },
  },
  {
    title: 'Chiefs vs Eagles — NFL Preseason Week 1',
    url: 'https://www.youtube.com/watch?v=9bZkp7q19f0',
    source: 'youtube',
    sport: 'Football',
    thumbnailUrl: 'https://img.youtube.com/vi/9bZkp7q19f0/maxresdefault.jpg',
    isLive: true,
    isFeatured: false,
    marketId: null,
    metadata: { homeTeam: 'Chiefs', awayTeam: 'Eagles', league: 'NFL' },
  },
  {
    title: 'Panthers vs Oilers — Stanley Cup Finals Game 4',
    url: 'https://www.youtube.com/watch?v=kJQP7kiw5Fk',
    source: 'youtube',
    sport: 'Hockey',
    thumbnailUrl: 'https://img.youtube.com/vi/kJQP7kiw5Fk/maxresdefault.jpg',
    isLive: true,
    isFeatured: false,
    marketId: null,
    metadata: { homeTeam: 'Panthers', awayTeam: 'Oilers', league: 'NHL' },
  },
  {
    title: 'UFC 310 — Main Card Live',
    url: 'https://www.youtube.com/watch?v=DLzxrzFCyOs',
    source: 'youtube',
    sport: 'Exotic',
    thumbnailUrl: 'https://img.youtube.com/vi/DLzxrzFCyOs/maxresdefault.jpg',
    isLive: true,
    isFeatured: false,
    marketId: null,
    metadata: { league: 'UFC' },
  },
];

function toFirestoreValue(val) {
  if (val === null || val === undefined) return { nullValue: null };
  if (typeof val === 'boolean') return { booleanValue: val };
  if (typeof val === 'string') return { stringValue: val };
  if (typeof val === 'number') return { doubleValue: val };
  if (typeof val === 'object' && !Array.isArray(val)) {
    const fields = {};
    for (const [k, v] of Object.entries(val)) {
      fields[k] = toFirestoreValue(v);
    }
    return { mapValue: { fields } };
  }
  return { stringValue: String(val) };
}

function toFirestoreDoc(obj) {
  const fields = {};
  for (const [k, v] of Object.entries(obj)) {
    fields[k] = toFirestoreValue(v);
  }
  return { fields };
}

function postDoc(doc) {
  return new Promise((resolve, reject) => {
    const body = JSON.stringify(toFirestoreDoc(doc));
    const url = new URL(BASE_URL);
    const options = {
      hostname: url.hostname,
      path: url.pathname,
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(body) },
    };
    const req = https.request(options, (res) => {
      let data = '';
      res.on('data', (c) => (data += c));
      res.on('end', () => {
        if (res.statusCode >= 200 && res.statusCode < 300) {
          resolve(data);
        } else {
          reject(new Error(`HTTP ${res.statusCode}: ${data}`));
        }
      });
    });
    req.on('error', reject);
    req.write(body);
    req.end();
  });
}

async function main() {
  console.log(`Seeding ${streams.length} livestreams to ${PROJECT_ID}...`);
  for (const s of streams) {
    try {
      await postDoc(s);
      console.log(`  ✅ ${s.title}`);
    } catch (e) {
      console.error(`  ❌ ${s.title}: ${e.message}`);
    }
  }
  console.log('Done!');
}

main();
