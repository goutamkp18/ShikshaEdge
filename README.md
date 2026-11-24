# ShikshaEdge (ಶಿಕ್ಷಾಎಡ್ಜ್)
> **Tagline**: *Internet may stop. Education shouldn't.*  
> **Team**: TEAMAPEX  
> **Hackathon**: wHACKiest 2026 — Track 4: UnlockED  
> **Problem Statement**: Low-Bandwidth Adaptive Learning for Rural Schools  

---

## 1. Problem Statement & Mission

In rural schools across Karnataka and India, students face severe educational bottlenecks:
1. **Unreliable or Absent Internet**: Digital education apps that depend on continuous cloud streaming or cloud LLMs crash or freeze when connectivity drops.
2. **High Student-to-Teacher Ratios**: Teachers cannot individually assess every student's learning gaps.
3. **Affordable Low-End Smartphones**: Rural households often share single low-end Android devices with limited storage and processing power.
4. **Linguistic Barriers**: Educational content is frequently only in English, leaving Kannada-medium students struggling.

**ShikshaEdge** addresses these challenges through a genuine **Offline-First, Multilingual, AI-Powered Android Application**. Its primary technical breakthrough is an **Offline Bayesian Knowledge Tracing (BKT) Engine** that tracks student mastery and intelligently adapts quiz difficulty in real-time right on the device—without requiring cloud LLMs or any internet connection.

---

## 2. Technical Innovations

### 2.1 Pure Dart Bayesian Knowledge Tracing (BKT) Engine
Instead of simulated or fake difficulty adjustments, ShikshaEdge runs a mathematically sound, offline BKT algorithm implemented entirely in pure Dart:
- **Prior Knowledge ($L_0 = 0.30$)**: Default assumption of student mastery before practice.
- **Learning Transition ($T = 0.10$)**: Probability that student learns concept after practicing a question.
- **Guess Factor ($G = 0.20$)**: Probability of guessing a multiple-choice question correctly.
- **Slip Factor ($S = 0.10$)**: Probability that a student knowing the concept makes an accidental mistake.

#### Update Equations:
- **When Answer is Correct**:
  $$P(L \mid \text{Correct}) = \frac{L \times (1 - S)}{(L \times (1 - S)) + ((1 - L) \times G)}$$
- **When Answer is Incorrect**:
  $$P(L \mid \text{Incorrect}) = \frac{L \times S}{(L \times S) + ((1 - L) \times (1 - G))}$$
- **Post-Observation Transition**:
  $$P(L_{\text{next}}) = \text{posterior} + ((1 - \text{posterior}) \times T)$$

#### Adaptive Difficulty Adjustment Policy:
- **Mastery $< 40\%$**: Easy foundational questions + visual diagrams + hints.
- **Mastery $40\% - 75\%$**: Medium multi-step questions.
- **Mastery $> 75\%$**: Hard conceptual and word problems.

### 2.2 Explainable AI (XAI)
Every difficulty adjustment provides a clear, encouraging bilingual explanation (in English and Kannada) showing why a particular question was selected. A built-in **Developer Demonstration View** shows live BKT math parameters ($L, S, G, T$) for verification.

### 2.3 Offline-First SQLite Architecture
- Full relational schema (16 tables) with foreign key enforcement and indexes.
- Idempotent `sync_queue` table buffering attempts for cloud synchronization when internet returns.
- Multiple student profiles on a single shared household device with isolated learning trajectories.

### 2.4 Offline Audio Infrastructure
- Pre-bundled MP3 voice lessons for Kannada and English.
- Ready integration with ElevenLabs generated audio assets under `assets/audio/{lang}/{subject}/`.

---

## 3. Technology Stack

- **Framework**: Flutter 3.50.1 (Channel stable), Dart 3.14.0
- **UI Design**: Google Material Design 3, responsive for low-end Android smartphones
- **State Management**: Flutter Riverpod (`flutter_riverpod`)
- **Offline Database**: SQLite with `sqflite`
- **Navigation**: `go_router`
- **Audio Playback**: `just_audio`
- **Analytics & Charts**: `fl_chart`
- **Network & Sync**: `connectivity_plus`, `supabase_flutter` (provisional teammate interface)
- **Localization**: Native Flutter `flutter_localizations` & `intl` (English, Kannada, Hindi)

---

## 4. Application Architecture

```
ShikshaEdge/
  ├── android-app/
  │   ├── android/
  │   ├── lib/
  │   │   ├── app/                 # MaterialApp & App Router
  │   │   ├── core/
  │   │   │   ├── config/          # SharedPreferences & Supabase config
  │   │   │   ├── database/        # SQLite DatabaseHelper (16 tables)
  │   │   │   ├── localization/    # English, Kannada, Hindi localization
  │   │   │   ├── theme/           # AppColors & AppTheme (Light & Dark)
  │   │   │   └── routing/         # go_router declarative routes
  │   │   ├── models/              # Student, Subject, Topic, Question, Attempt, Mastery
  │   │   ├── repositories/        # StudentRepo, ContentRepo, ProgressRepo
  │   │   ├── services/
  │   │   │   ├── adaptive_learning/ # BktEngine & AdaptiveQuizService
  │   │   │   ├── audio/           # JustAudio offline playback service
  │   │   │   ├── connectivity/    # Online/offline network watcher
  │   │   │   └── synchronization/ # Idempotent sync service for Supabase
  │   │   ├── features/
  │   │   │   ├── onboarding/      # Splash & 3-step onboarding flow
  │   │   │   ├── student_profile/ # Offline student registration
  │   │   │   ├── dashboard/       # Main navigation shell & Home dashboard
  │   │   │   ├── subjects/        # Subject and Topic selection
  │   │   │   ├── lessons/         # Interactive lesson reader with diagrams
  │   │   │   ├── quiz/            # Adaptive quiz & results screen
  │   │   │   ├── progress/        # Student progress analytics with fl_chart
  │   │   │   ├── content_packs/   # Offline content packs manager
  │   │   │   └── settings/        # Profiles, theme, language, cloud sync
  │   │   └── shared/              # Riverpod providers & UI widgets
  │   ├── assets/
  │   │   ├── content/             # class_6_default_pack.json (Math, Science, English)
  │   │   └── audio/               # en/ and kn/ regional audio assets
  │   ├── test/                    # Unit tests for BKT math & models
  │   └── docs/
  │       └── INTEGRATION.md       # Teammate cloud integration contract
  └── README.md
```

---

## 5. Educational Content Included in MVP

- **Mathematics (Class 6)**:
  - *Multiplication*: Equal groups, multiplication tables, two-digit multiplication, word problems (16 verified questions).
  - *Division*: Equal sharing, quotients, remainders.
  - *Fractions*: Numerators, denominators, parts of a whole.
- **Science (Class 6)**:
  - *Photosynthesis*: Raw materials ($CO_2$, water, sunlight), chlorophyll, stomata, products (glucose, oxygen), iodine starch test (16 verified questions).
  - *Parts of Plants*: Root and shoot systems, flowers, ovaries, fruits.
  - *Solar System*: 8 planets, Mars, Sun.
- **English (Class 6)**:
  - *Nouns*: Common, proper, collective, abstract, countable/uncountable, irregular plurals (16 verified questions).
  - *Verbs*: Action words.
  - *Sentence Formation*: Subject + Verb + Object structure.

---

## 6. How to Run & Build

### 6.1 Prerequisites
- Flutter SDK 3.50+
- Java JDK 17
- Android SDK 36 (build-tools 36.0.0, API 26+)

### 6.2 Commands
```bash
# Navigate to android-app
cd android-app

# Fetch dependencies
flutter pub get

# Run static analysis
flutter analyze

# Execute BKT unit tests
flutter test

# Compile release APK
flutter build apk --release
```

**Output APK Location**:
`android-app/build/app/outputs/flutter-apk/app-release.apk`

---

## 7. Hackathon Live Demonstration Steps

1. **Launch App**: Open ShikshaEdge. Database initializes automatically.
2. **Create Profile**: Enter student name (e.g., "Kavita"), choose Class 6, preferred language (Kannada), and an avatar.
3. **Turn on Airplane Mode**: Cut off Wi-Fi and mobile data.
4. **Open Lesson**: Navigate to *Science* ➡️ *Photosynthesis*. Read step-by-step slides and play the offline voice guide.
5. **Start Adaptive Quiz**:
   - Answer incorrectly: Observe estimated mastery dropping according to the BKT update formula, difficulty adjusting down to *Easy*, and an encouraging hint being provided.
   - Answer correctly: Observe estimated mastery increasing, difficulty transitioning to *Medium* and *Hard*.
   - Toggle language button: View the question and explanation in Kannada or English instantaneously.
6. **Inspect Explainable AI**: Expand the BKT Math inspector to see the live posterior probability and parameter calculations.
7. **Progress Analytics**: Open the *Progress* tab to view the live `fl_chart` mastery curve, accuracy, and streak.
8. **App Restart**: Force close and reopen app while still offline. Verify all records, bookmarks, and mastery values remain preserved in SQLite.
9. **Cloud Sync**: Disable airplane mode. Open *Settings* and tap *Sync Now* to demonstrate the sync queue flushing to the cloud backend.

---

## 8. License & Team Credits

Built with ❤️ by **TEAMAPEX** for **wHACKiest 2026**.
- Member 1: Android Application Engineer & AI Architect
- Member 2: Supabase Backend & Teacher Portal Engineer
