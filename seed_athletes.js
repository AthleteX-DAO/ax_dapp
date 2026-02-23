/**
 * Seed script: populates athlete_elo_rankings in Firestore
 * Run: node seed_athletes.js
 */
const admin = require('./functions/node_modules/firebase-admin');

admin.initializeApp({
  credential: admin.credential.applicationDefault(),
  projectId: 'athletex-prod',
});

const db = admin.firestore();

const athletes = [
  // NBA
  { athleteId: 201939, athleteName: 'LeBron James',           sport: 'NBA', team: 'Lakers',    elo: 1400, wins: 0, losses: 0, totalBattles: 0 },
  { athleteId: 2544,   athleteName: 'Kevin Durant',           sport: 'NBA', team: 'Suns',      elo: 1380, wins: 0, losses: 0, totalBattles: 0 },
  { athleteId: 201950, athleteName: 'Giannis Antetokounmpo',  sport: 'NBA', team: 'Bucks',     elo: 1420, wins: 0, losses: 0, totalBattles: 0 },
  { athleteId: 2591,   athleteName: 'Stephen Curry',          sport: 'NBA', team: 'Warriors',  elo: 1410, wins: 0, losses: 0, totalBattles: 0 },
  { athleteId: 203999, athleteName: 'Luka Doncic',            sport: 'NBA', team: 'Mavericks', elo: 1390, wins: 0, losses: 0, totalBattles: 0 },
  { athleteId: 203954, athleteName: 'Joel Embiid',            sport: 'NBA', team: '76ers',     elo: 1370, wins: 0, losses: 0, totalBattles: 0 },
  { athleteId: 1629029, athleteName: 'Ja Morant',             sport: 'NBA', team: 'Grizzlies', elo: 1340, wins: 0, losses: 0, totalBattles: 0 },
  { athleteId: 1629630, athleteName: 'Zion Williamson',       sport: 'NBA', team: 'Pelicans',  elo: 1320, wins: 0, losses: 0, totalBattles: 0 },
  // NFL
  { athleteId: 14876,  athleteName: 'Patrick Mahomes',        sport: 'NFL', team: 'Chiefs',    elo: 1430, wins: 0, losses: 0, totalBattles: 0 },
  { athleteId: 14879,  athleteName: 'Josh Allen',             sport: 'NFL', team: 'Bills',     elo: 1400, wins: 0, losses: 0, totalBattles: 0 },
  { athleteId: 14880,  athleteName: 'Jalen Hurts',            sport: 'NFL', team: 'Eagles',    elo: 1370, wins: 0, losses: 0, totalBattles: 0 },
  { athleteId: 14881,  athleteName: 'Lamar Jackson',          sport: 'NFL', team: 'Ravens',    elo: 1360, wins: 0, losses: 0, totalBattles: 0 },
  // MLB
  { athleteId: 543037, athleteName: 'Mike Trout',             sport: 'MLB', team: 'Angels',    elo: 1350, wins: 0, losses: 0, totalBattles: 0 },
  { athleteId: 592450, athleteName: 'Mookie Betts',           sport: 'MLB', team: 'Dodgers',   elo: 1360, wins: 0, losses: 0, totalBattles: 0 },
  { athleteId: 660670, athleteName: 'Shohei Ohtani',          sport: 'MLB', team: 'Dodgers',   elo: 1450, wins: 0, losses: 0, totalBattles: 0 },
  // Meme Athletes
  { athleteId: 9001,   athleteName: 'Giga Chad',              sport: 'Meme', team: 'The Gym',           elo: 1600, wins: 0, losses: 0, totalBattles: 0 },
  { athleteId: 9002,   athleteName: 'Sigma Male Grindset',    sport: 'Meme', team: 'Mindset',         elo: 1550, wins: 0, losses: 0, totalBattles: 0 },
  { athleteId: 9003,   athleteName: 'Andrew Tate',            sport: 'Meme', team: 'Top G Mansion',   elo: 1320, wins: 0, losses: 0, totalBattles: 0 },
  { athleteId: 9004,   athleteName: 'Jake Paul',              sport: 'Meme', team: 'YouTube Boxing',  elo: 850, wins: 0, losses: 0, totalBattles: 0 },
  { athleteId: 9005,   athleteName: 'Logan Paul',             sport: 'Meme', team: 'Prime Hydration', elo: 880, wins: 0, losses: 0, totalBattles: 0 },
];

async function seed() {
  console.log(`Seeding ${athletes.length} athletes to athletex-prod...\n`);
  for (const athlete of athletes) {
    const id = String(athlete.athleteId);
    await db.collection('athlete_elo_rankings').doc(id).set(athlete, { merge: true });
    console.log(`✓  ${athlete.athleteName} (${athlete.sport})`);
  }
  console.log('\n✅ Done! Seeded', athletes.length, 'athletes.');
  process.exit(0);
}

seed().catch(err => { console.error('❌ Error:', err); process.exit(1); });
