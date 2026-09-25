# 🛡 SmokeGuard — Smart Smoke Exposure Monitoring & Health Protection

A standalone, modern Flutter UI implementation for the **SmokeGuard** Major Project & PPT Presentation case study.

---

## 📱 Complete UI Architecture & Screen Flow

```text
                  Splash Screen (Brand Intro & Animated Shield)
                                ↓
                 Onboarding Carousel (3 Interactive Screens)
                                ↓
                   Login / Registration (Modern Card Design)
                                ↓
                       Main Dashboard Shell
 ┌─────────────────┬─────────────────┬─────────────────┬─────────────────┐
 ↓                 ↓                 ↓                 ↓                 ↓
🏠 Home        📊 Analytics       📜 History        🔔 Alerts       👤 Profile
 ↓                 ↓                 ↓                 ↓                 ↓
Live Status     AI Insights       Daily/Weekly     Alert Timeline   Settings &
& Metrics       & Donut Chart     Trend Curves     & Dismissal      Health Profile
```

---

## ✨ Implemented Screens Overview

1. **Splash Screen**
   - Brand Logo & Pulsating Ambient Aura
   - App Name: `SmokeGuard`
   - Tagline: `Smart Smoke Exposure & Health Protection`
   - Smooth progress loading transition
2. **Onboarding Screens (3 Slides)**
   - *Screen 1*: **Stay Aware of Smoke Exposure** (Vector air-quality radar)
   - *Screen 2*: **Get Instant Alerts** (Push & haptic notification preview)
   - *Screen 3*: **Track Your Exposure** (PSEI score & analytics graphs)
   - Skip / Interactive Dot Page Indicators / **Get Started** button
3. **Login / Registration Screen**
   - Welcome Header
   - Tab Switcher (Login ⟷ Sign Up)
   - Modern Form with Password Visibility Toggle
   - **Quick PPT Presentation Demo (Bypass)** button for immediate examiner walkthrough
4. **Home Dashboard**
   - Header: `Hello Amit 👋`, `Good Morning`
   - **Live Status Card**: Animated breathing wave radar (`SAFE` / `MODERATE` / `HIGH RISK`), real-time PSEI score indicator
   - **Interactive Smoke Spike Simulator**: Test safe mode vs high smoke spike live on stage!
   - **Environmental Metric Grid**:
     - `PM2.5` (Concentration in µg/m³)
     - `VOC` (Volatile Organics in ppm)
     - `PSEI Score` (Personal Smoke Exposure Index / 100)
     - `Exposure Time` (Daily minutes logged)
   - **Quick Actions**: Direct jumps to Analytics, History, and Alerts
5. **Alert Screen**
   - Top Prominent Alert Banner: `⚠ Smoke Exposure Detected (Risk Level: High)`
   - Interactive Buttons: `View Details`, `Dismiss`, `Mark Resolved`
   - Filter Tabs: `All`, `Active`, `High Risk`, `Resolved`
   - **Alert Timeline**: Today, Yesterday, and Last Week logs
6. **Risk Details Screen**
   - Large Radial PSEI Arc Gauge (`PSEI: 72 HIGH RISK`)
   - Sensor Data Breakdown (`PM2.5: 86.8 µg/m³`, `VOC: 1.95 ppm`, `CO: 8.6 ppm`)
   - **Exposure Summary**: Duration (42 min), Location (Central Metro Plaza), Time (6:45 PM)
   - **Smart Health Recommendation Cards**:
     - 🏃 *Move to Fresh Air* (Relocate to filtered indoor or park zone)
     - 😷 *Reduce Exposure* (Wear N95/FFP2 mask)
     - 🩺 *Monitor Health* (Check respiratory ease & hydrate)
7. **Exposure History Screen**
   - Timeframe Tabs: `Daily`, `Weekly`, `Monthly`
   - Metric Cards: `Total Exposure`, `Highest Risk Day`, `Average PSEI`
   - **Custom Bezier Trend Chart** with gradient underlay
   - Detailed Session Log History cards with location and peak PSEI
8. **Analytics Dashboard**
   - Metric Cards: `Total Alerts (14)`, `Avg Exposure (28m)`, `Top Hotspot (Metro Bus)`, `Clean Air Share (76%)`
   - **AI Insights Card**:
     - *Most Exposure*: Public Transport
     - *Peak Time*: 6:00 PM – 8:00 PM
     - *Neural Optimization*: Route diversion advice to avoid 42% smoke corridors
   - **Donut/Pie Chart**: Risk Distribution Breakdown (% Safe, % Moderate, % High)
   - **Bar Chart**: 7-Day Weekly Exposure Duration
   - **Line Chart**: 24-Hour Particulate Fluctuation
9. **Profile Screen**
   - User Avatar: `Amit Kumar Prasad` (Asthmatic Sensitivity Profile)
   - Metric Cards: `Total Exposure Hours (18.5h)`, `Average Risk Score (32 PSEI)`, `Total Alerts (12)`
   - Paired IoT Sensor Band status (`SG-902-BLE • Battery: 94%`)
   - **PPT Presentation Showcase Info Modal**
   - Export Health Report Action
10. **Settings Screen**
    - Instant **Dark Mode / Light Mode** theme switcher
    - Notification preferences (Push, Haptic Vibration)
    - Sensor Bluetooth connectivity simulation
    - Language switcher (English, Hindi, Spanish, French)
    - Project presentation credits and specs

---

## 🚀 How to Run the App

```bash
# 1. Navigate to project folder
cd "e:\major project\smokGard"

# 2. Get dependencies
flutter pub get

# 3. Run on your connected device / Chrome / Windows / Emulator
flutter run
```

---

## 🛠 Tech Stack

- **Flutter**: 3.41.6 / Dart 3.11.4
- **Styling**: Material 3 Design Tokens, Custom Themes, Custom Canvas Painters
- **Typography**: Google Fonts (`Plus Jakarta Sans`)
- **Architecture**: Clean decoupled separation of `theme/`, `models/`, `state/`, `widgets/`, and `screens/`
