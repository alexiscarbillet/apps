# BodyCare: Preventative Health & Longevity Dashboard

A medical-grade Flutter application built for proactive preventative health tracking, personal genetic risk mitigation, environmental UV protection, and long-term vitality management.

---

## Key Modules & Features

### 1. Your Personal Risk Dashboard & "Why" Tracker
- **The Baseline Profile**: Track personal metrics (Age, Sex, BMI, Blood Pressure, Resting Heart Rate, Blood Type).
- **The "Why" Tracker**: Constant visual reminder of your deeper preventative motivation (e.g. mitigating familial early cardiovascular disease and melanoma predisposition) with interactive editing and direct linkage to mitigated risks.
- **Family History & Genetic Predisposition Registry**: Categorized risks (Cardiovascular, Metabolic, Oncology, Musculoskeletal) with lineage relations, clinical notes, and actionable lifestyle mitigation protocols.
- **Baseline Biomarker Vault**: Tracks critical longevity lab markers including **ApoB**, **hs-CRP**, **HbA1c**, **Fasting Glucose**, **Vitamin D (25-OH)**, and **eGFR** with reference ranges and clinical interpretations.

### 2. Custom Habit & Preventative Focus
- **Dietary Quality Over Calorie Counting**:
  - Servings of **Leafy Greens & Cruciferous Vegetables** (3+ servings/day for Nrf2 activation & sulforaphane).
  - **Zero Ultra-Processed Foods (UPF-Free)** meals tracking for gut barrier protection and low systemic inflammation.
  - **Alcohol Moderation & Alcohol-Free Streak Tracker** (0 units target).
  - **Cellular Hydration** (8 glasses / 2.0L mineralized water).
  - **Resistance & Zone 2 Training** for metabolic muscle reserve.
- **7-Day Adherence Visualization**: Interactive weekly bar chart with streak tracking and dynamic Longevity Score calculations.

### 3. The UV & Environmental Log
- **Live UV Index & Solar Radiation**: Real-time UV Index fetched via the Open-Meteo Weather API with graceful offline caching and city presets (Montreal, Paris, New York, Tokyo, Sydney, London).
- **Risk Grading & Protection Rules**: Color-coded risk meter (0-2 Low, 3-5 Moderate, 6-7 High, 8-10 Very High, 11+ Extreme).
- **Sunscreen Reapplication Timer**: 2-hour active countdown timer reminding you when to reapply SPF 50+ broad-spectrum protection.
- **Dermatologist Sun Defense Protocol**: Guidance on zinc oxide mineral filters, UV400 sunglasses, and peak hours avoidance.

### 4. Movement & Ergonomics (Sedentary Reduction)
- **Prolonged Sitting Interval Timer**: Configurable 30, 45, or 60-minute countdown dial.
- **Guided 5-Minute Break Coach**: Interactive step-by-step stretch routines with illustrations and physiological benefits:
  1. *Spinal Decompression & Posture Reset*
  2. *Micro-Walking & Soleus Muscle Glucose Clearance*
  3. *Hip Flexor & Glute Activation*
  4. *20-20-20 Eye & Suboccipital Relief*
- **Daily Standing Breaks Counter**: Track daily interruption of sedentary sitting.

### 5. The Medical & Screening Vault
- **Personal Preventative Calendar**: Age & risk-tailored timeline for screenings:
  - *Full-Body Dermatological Skin Check*
  - *Comprehensive Biomarker & Lipid Panel*
  - *Periodontal Hygiene & Oral Cancer Screening*
  - *Coronary Calcium Score (CAC) / Echo Baseline*
  - *Dilated Eye & Retinal Microvasculature Imaging*
- **Timeline & Due Date Counter**: Real-time countdowns (e.g. "Due in 65 days", "Scheduled", "Overdue").
- **Prep Guidelines**: Medical preparation checklists (e.g. 12-hour fasting, sunglasses for dilation).

### 6. The Mole & Skin Map (Dermatology Tracker)
- **Interactive Anatomical Body Map**: Vector-rendered human silhouette with Anterior (Front) and Posterior (Back) views.
- **Pinpoint Mole Registry**: Drop pins directly by tapping the body canvas to record anatomical location.
- **Melanoma ABCDE Criteria Analysis**:
  - **A**symmetry
  - **B**order Irregularity
  - **C**olor Variegation
  - **D**iameter > 6mm
  - **E**volving over time
- **Photo & Inspection Log History**: Log periodic self-checks, millimeter diameter evolution, color swatches, and clinical notes over the years.

---

## Architecture

Built with Flutter following clean MVVM and layered architecture principles:
```
lib/
├── core/
│   ├── theme/
│   │   ├── app_colors.dart       # Vibrant Emerald, Teal, Sage, Dark Slate tokens
│   │   └── app_theme.dart        # Typography (GoogleFonts Outfit & Inter), dark/light themes
├── data/
│   ├── models/
│   │   ├── user_profile_model.dart
│   │   ├── habit_log_model.dart
│   │   ├── uv_data_model.dart
│   │   ├── screening_model.dart
│   │   └── mole_record_model.dart
│   ├── services/
│   │   ├── local_storage_service.dart # SharedPreferences caching & seed data
│   │   └── uv_api_service.dart        # Open-Meteo live API client
│   └── repositories/
│       └── health_repository.dart
├── logic/
│   ├── health_dashboard_controller.dart
│   └── movement_timer_controller.dart
└── presentation/
    ├── screens/
    │   ├── home_dashboard_screen.dart
    │   ├── risk_profile_screen.dart
    │   ├── habits_screen.dart
    │   ├── environment_screen.dart
    │   ├── movement_timer_screen.dart
    │   ├── screening_vault_screen.dart
    │   ├── skin_map_screen.dart
    │   └── settings_screen.dart
    └── widgets/
        ├── longevity_score_card.dart
        ├── why_tracker_banner.dart
        ├── habit_item_tile.dart
        ├── uv_meter_gauge.dart
        ├── body_silhouette_widget.dart
        ├── screening_timeline_tile.dart
        ├── mole_detail_sheet.dart
        └── stretch_guide_dialog.dart
```

---

## How to Run

### Run Locally on Windows Desktop:
```bash
flutter run -d windows
```

### Run on Android Device / Emulator:
```bash
flutter run -d android
```

### Run on Chrome / Web:
```bash
flutter run -d chrome
```

### Run Test Suite:
```bash
flutter test
```