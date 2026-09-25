# ♟️ Chess Tactics Pro (Android & Cross-Platform Flutter App)

A modern, offline-first Flutter application designed for training chess tactics and solving puzzles with interactive animations, sound feedback, and streak tracking.

---

## ✨ Implemented Features

### 📅 1. Daily 5 Puzzle Challenge
- **Daily Rotation**: 5 fresh puzzles generated and seeded dynamically every day (`YYYY-MM-DD`).
- **Progress Stepper**: Visual stepper tracking completion (1/5 to 5/5) with instant feedback.
- **Streak & Rewards**: Daily streak counter with flame badge 🔥, longest streak tracking, and celebratory completion dialog.

### 📚 2. Curated Puzzle Library (Campaign)
- **Categorized Themes**:
  - 👑 **Mate in 1** (One-move knockout blows)
  - ⚔️ **Mate in 2 & 3** (Calculated mating nets)
  - 🍴 **Forks & Double Attacks** (Simultaneous threats)
  - 📌 **Pins & Skewers** (Exploiting piece alignment)
  - ⚡ **Discovered Attacks** (Unmasking tactical ambushes)
  - 🏰 **Endgame Mastery** (Pawn races, Lucena bridge, king opposition)
  - 🌟 **Grandmaster Classics** (Historic brilliancies from Morphy, Tal, Fischer, Kasparov)
- **Progress Tracking**: Progress bars per category, star ratings, and solved checkmarks.

### ⚡ 3. Random Tactical Trainer & Puzzle Rush
- **Infinite Random Puzzles**: Instant random puzzle solver filtered by motif and rating.
- **Puzzle Rush**:
  - **3-Strikes Survival**: Fast-paced tactical sprint with 3 lives (❤️❤️❤️) and difficulty escalation.
  - High score tracking and persistent leaderboards.

### 🎨 4. Fluid Interactive Chess Board & Engine
- **Self-Contained Pure Dart Engine**: Complete legal move generator, check/checkmate detection, castling, en passant, promotion, and FEN/UCI parser.
- **Visuals & Animations**:
  - Custom vector chess piece renderer.
  - Drag-and-drop + Tap-to-move piece interaction.
  - Legal move destination dots & capture rings.
  - King check danger aura & wrong-move shake animation.
  - Pawn promotion dialog (Queen, Rook, Bishop, Knight).
  - 2-Tier Hint System (Piece highlight & Target square guide).
  - Solution Auto-Play solver.
- **Board Themes**: Classic Walnut, Emerald Forest, Midnight Slate, Cyberpunk Neon, and Royal Sapphire.

---

## 📋 What is Left To Do / Roadmap

### 🌐 1. Online Puzzle Sync & Expanded Database
- [ ] **Lichess API Integration**: Fetch real-time rated puzzles directly from the open-source Lichess Puzzle Database via REST API.
- [ ] **Expanded Offline Database**: Expand the local SQLite/JSON puzzle database to 1,000+ categorized puzzles.
- [ ] **Offline Cache & Background Sync**: Automatically download the next week's daily puzzles when online.

### 🤖 2. Stockfish & Engine Analysis Mode
- [ ] **Stockfish Integration**: Connect an embedded Stockfish WASM / native engine binary to calculate dynamic engine evaluations.
- [ ] **Interactive Evaluation Bar**: Visual balance bar showing +/- advantage during post-puzzle analysis.
- [ ] **Move Alternate Lines**: Allow exploring alternative candidate moves after solving a puzzle.

### 🎵 3. Custom Audio & Haptic Assets
- [ ] **Bundled Audio Files**: Add dedicated audio sound packs (`move.mp3`, `capture.mp3`, `check.mp3`, `victory.mp3`, `error.mp3`).
- [ ] **Custom Piece Style Packs**: Add optional piece sets (e.g., Neo, Staunton, Alpha, Woodcut).

### ☁️ 4. Cloud Sync & Social Features
- [ ] **Cloud Backup / Firebase Auth**: Synchronize daily streaks, solved puzzles, and Puzzle Rush high scores across devices.
- [ ] **Global Leaderboards**: Competitive daily and monthly Puzzle Rush leaderboards.
- [ ] **Friend Challenge**: Share daily puzzle performance cards to social media / messaging apps.

### 🛠️ 5. Android Production & Store Release
- [ ] **App Icon & Splash Screen**: Generate adaptive Android launcher icons and themed splash screens using `flutter_launcher_icons`.
- [ ] **Keystore & Signing Config**: Configure `key.properties` and Gradle release signing for Google Play Store APK/AAB builds.
- [ ] **Google Play Games Services**: Integrate Play Games achievements and leaderboards.

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev) (v3.13+ or higher)
- Android Studio / Android SDK (for Android builds) or Chrome/Edge (for Web/Desktop testing)

### Running the App
```bash
# Get dependencies
flutter pub get

# Run on connected Android device or emulator
flutter run

# Run on Web / Windows for testing
flutter run -d chrome
flutter run -d windows
```

### Running Tests
```bash
# Run all unit and widget tests
flutter test
```
