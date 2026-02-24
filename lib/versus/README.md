# Battle for the Top Rank - Versus Voting Feature

## Overview

The Versus voting feature enables users to battle athletes head-to-head with dynamic ELO ratings, live chat, and a global leaderboard. Features include:

- **Premium swipeable cards** with gold borders and stat overlays
- **Off-chain voting** using Firebase (fast, free)
- **ELO-based matchmaking** (±200 point range)
- **Live chat** with position badges and trash-talking
- **Responsive design** (desktop tabs, mobile PageView)
- **ESPN athlete images** with fallback avatars

## Architecture

### 4-Layer Clean Architecture

```
Presentation Layer (VersusPage, Widgets)
    ↓ depends on
Business Logic Layer (VersusBloc, VersusChatBloc)
    ↓ depends on
Domain Layer (VersusRepository, VersusChatRepository)
    ↓ depends on
Data Layer (Firebase Firestore)
```

### Key Files

```
lib/versus/
├── bloc/
│   ├── versus_bloc.dart          # Matchup & ELO state
│   ├── versus_chat_bloc.dart     # Real-time messaging
│   ├── versus_event.dart
│   ├── versus_state.dart
│   └── versus_chat_event/state.dart
├── models/
│   ├── athlete_elo.dart          # ELO ratings & W/L records
│   ├── versus_match_model.dart   # Head-to-head matchups
│   └── chat_message.dart         # Live chat messages
├── repository/
│   ├── versus_repository.dart    # Matchmaking & voting
│   └── versus_chat_repository.dart # Chat management
├── services/
│   └── athlete_image_service.dart # ESPN API integration
├── view/
│   └── versus_page.dart          # Main page
├── widgets/
│   ├── athlete_battle_card.dart  # Premium card design
│   ├── versus_battle_layout.dart # Swipe layout
│   ├── versus_chat_panel.dart    # Chat UI
│   ├── chat_message_card.dart    # Message styling
│   ├── chat_input_field.dart     # Input validation
│   ├── leaderboard_widget.dart   # Rankings
│   └── widgets.dart              # Barrel file
└── versus.dart                    # Main export
```

## Setup & Initialization

### 1. Deploy Firestore Security Rules

```bash
firebase deploy --only firestore:rules
```

Rules file: [`firestore.rules`](../../firestore.rules)

**Collections:**
- `battle_votes` - Vote records
- `athlete_elo_rankings` - Athlete rankings
- `versus_chat/{matchId}/messages` - Live chat

### 2. Initialize Athlete Data

The feature requires athletes in Firestore. You have two options:

**Option A: Manual Firestore Seeding**

Add documents to `athlete_elo_rankings` collection:

```json
{
  "athleteId": 201939,
  "athleteName": "LeBron James",
  "sport": "NBA",
  "team": "Lakers",
  "elo": 1400,
  "wins": 0,
  "losses": 0,
  "totalBattles": 0
}
```

**Option B: Programmatic (Recommended)**

Use the initialization helper:

```dart
import 'package:ax_dapp/versus/INITIALIZATION_GUIDE.dart';

// In your test/setup code:
await initializeSampleAthletes(context.read<VersusRepository>());
```

### 3. Connect to Router

Already configured in:
- Route: `/versus`
- Navigation: "Battle" tab in top/bottom nav
- DI: `app_router.dart` (repositories injected)

## Features

### Versus Battles

**Desktop Layout:**
- Left panel (60%): Battle cards with swipe detection
- Right panel (40%): Chat & Leaderboard tabs

**Mobile Layout:**
- `PageView` with athlete cards
- Swipeable between athletes
- Chat panel below

**Swipe Gestures:**
- Right swipe (500px/s): Vote for left athlete
- Left swipe: Vote for right athlete
- Haptic feedback on vote submission

### ELO Ratings

**Calculation:**
- K-factor: 32 points per battle
- Starting ELO: 1200
- Matchmaking: ±200 ELO range

**Formula:**
```
Expected(A vs B) = 1 / (1 + 10^((B - A) / 400))
New Rating = Old Rating + K * (Actual - Expected)
```

### Live Chat

**Features:**
- Real-time Firestore streams
- 280-character limit (Twitter-style)
- Position badges (Athlete A/B)
- Rate limiting: 1 message per 3 seconds
- Like/delete functionality

**Position Badges:**
- Gold border = Voted for Athlete 1
- Blue border = Voted for Athlete 2
- No border = No vote

### Leaderboard

**Display:**
- Top 50 athletes by ELO
- Gold/Silver/Bronze medals (top 3)
- W-L record & win percentage
- Real-time updates via Firestore streams

## Troubleshooting

### "Missing or insufficient permissions" Errors

**Issue:** Firestore rules prevent chat/voting

**Solution:**
1. Verify `firestore.rules` is deployed: `firebase deploy --only firestore:rules`
2. Check rule syntax: `firebase emulator:firestore`
3. Ensure authenticated users: Login required for writes

### "No matchup available"

**Issue:** No athletes in Firestore

**Solution:**
1. Check `athlete_elo_rankings` collection exists
2. Seed athletes: Use initialization helper or add manually
3. Verify `getLeaderboard()` stream has data

### Chat not showing

**Issue:** `versus_chat` document creation fails

**Solution:**
1. Ensure user is authenticated (wallet connected)
2. Check Firestore rules allow read on `versus_chat`
3. Verify app has internet connection

### Images not loading

**Issue:** ESPN API fails or athlete ID is invalid

**Solution:**
1. Fallback avatars use team colors + initials
2. Check athlete `id` matches ESPN database
3. ESPN headshot URL: `https://a.espncdn.com/combiner/i?img=/i/headshots/{sport}/players/full/{id}.png`

## Extending the Feature

### Add New Markets

Update `versus_page.dart` market selector:

```dart
// Add to _buildMarketSelector():
DropdownButton(
  items: [
    'Battle for the Top Rank',
    'Best Rookie',
    'Team vs Team',
  ]
)
```

### Customize ELO

Modify `EloCalculator` in `athlete_elo.dart`:

```dart
static const double kFactor = 32.0;  // Change volatility
```

### Add Moderation

Update `VersusChatRepository.sendMessage()`:

```dart
// Add profanity filter
if (message.containsProfanity()) {
  throw Exception('Message contains inappropriate content');
}
```

## Data Flow

### Voting Flow

```
User swipes athlete card
    ↓
VersusBloc receives VoteSubmitted event
    ↓
Haptic feedback + animation
    ↓
VersusRepository calculates new ELO
    ↓
Firestore batch: vote + athlete ratings updated
    ↓
Auto-load next matchup
    ↓
VersusChatPanel initializes for new match
```

### Chat Flow

```
User types message in ChatInputField
    ↓
VersusChatBloc validates (280 chars, rate limit)
    ↓
VersusChatRepository ensures matchup doc exists
    ↓
Message added to Firestore
    ↓
Firestore stream updates ChatMessageCard list (reversed)
    ↓
Real-time display
```

## Performance Optimization

- **Lazy loading:** Leaderboard streams only on demand
- **Message limit:** 100 messages per matchup
- **Caching:** Athlete ELO cached in BLoC state
- **Pagination:** Future enhancement for chat

## Testing

**Unit Tests:**
```bash
flutter test test/versus_bloc_test.dart
```

**Widget Tests:**
```bash
flutter test test/versus_page_test.dart
```

**Integration Tests:**
```bash
flutter drive --target=test_driver/app.dart
```

## Future Enhancements

1. **Leaderboard filters:** By sport, timeframe (weekly/monthly)
2. **Achievement badges:** Streak counter, rare victories
3. **Prediction markets:** Bet on versus outcomes
4. **Social sharing:** "Beat LeBron!" screenshots
5. **Mobile notifications:** New matchups, chat replies
6. **Multi-language:** i18n support
7. **AI matchmaking:** Skill-weighted pairings

## Support

For issues:
1. Check [firestore.rules](../../firestore.rules) syntax
2. Verify athlete data in Firestore Console
3. Check browser console for chat errors
4. Run `flutter clean && flutter pub get`

