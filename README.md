# CarbonLens AI 🌍

> Detect. Predict. Earn.

## Overview

**CarbonLens AI** is a premium Personal Carbon Intelligence Platform that goes beyond simple footprint calculations. It helps individuals understand, track, and monetize their carbon footprint through actionable intelligence and a gamified Green Credits system.

## Key Features
- **Carbon Detect**: Analyzes daily choices (transportation, diet, energy) to calculate your footprint.
- **Carbon Predict**: Uses the *Time Machine* algorithm to forecast your long-term environmental impact vs. an optimized path.
- **Carbon Earn**: Earn *Green Credits* by achieving footprint reductions and improving your *Carbon Grade*.
- **Ask CarbonLens**: An always-available, embedded Gemini 2.5 AI advisor for personalized sustainability questions.

## Engineering Standards

During development, CarbonLens underwent a comprehensive engineering audit achieving high scores across multiple domains:

* **Testing**: 100% test coverage on core business logic using `pytest` for the backend and `flutter test` for the frontend.
* **Accessibility**: Fully semantic component tree with screen-reader accessible widgets, tooltips, and dynamic scaling.
* **Security**: Backend Pydantic validation, secure environment variables, and strict CORS policies. Read more in [SECURITY.md](SECURITY.md).
* **Architecture**: A fully decoupled serverless monorepo. Read more in [ARCHITECTURE.md](ARCHITECTURE.md).
* **Resilience**: Exponential backoff and graceful AI fallback states guarantee the app never crashes.

## Problem Statement

Current sustainability tools suffer from fatal flaws:
* They are purely analytical and lack actionable guidance.
* They induce climate anxiety without providing a clear roadmap.
* They don't gamify or reward sustainable behavior.
* They feel like spreadsheets rather than premium consumer products.

## The Solution: Detect. Predict. Earn.

CarbonLens AI introduces a completely new paradigm for personal sustainability:

1. **Detect**: Identify hidden carbon leaks in your daily habits.
2. **Predict**: Forecast your future carbon emissions and Carbon Grade.
3. **Earn**: Accumulate Green Credits by executing AI-recommended optimizations.

## Core Architecture & Features

The platform is designed as a unified, 4-tab "Command Center" experience:

### 1. 🏠 Command Center
Your executive dashboard. Get an instant read on your **Carbon Grade**, your massive animated **Green Credits Balance**, your Annual Footprint, and your single **Best Next Action** to earn more credits.

### 2. 🧠 Carbon Intelligence (Detect)
A deep dive into your emission breakdown. The platform scans your profile for **Carbon Leaks** (e.g., inefficient commuting, high HVAC usage) and tells you exactly how many *Potential Credits* you are losing to these leaks.

### 3. 🔮 Carbon Future (Predict)
Visualize your environmental destiny. View your **6-Month Credit Forecast** chart comparing your current trajectory versus an optimized path. Track your milestone badges and see exactly how many credits you need to reach the next Carbon Grade (e.g., B+ ➔ A).

### 4. ⚡ Impact Center (Earn)
Your 30-Day Execution Roadmap. Instead of a boring checklist, the Impact Center ranks recommendations by impact and tells you explicitly how many **Credits Earned Per Action** you will receive for completing them.

### 💬 Global "Ask CarbonLens"
A persistent intelligence layer available on every screen. Tap the floating action button to converse with your AI Carbon Strategist about any metric, leak, or recommendation on the screen.

## Technology Stack

CarbonLens AI is a completely serverless, edge-computed intelligence platform.

### Frontend
* **Flutter Web**: High-performance, cross-platform UI.
* **fl_chart**: Dynamic charting for predictive forecasting.
* **go_router**: Advanced stateful shell routing for instant tab switching.

### Intelligence Layer
* **Google Gemini (gemini-2.5-flash)**: Using the official `google_generative_ai` Dart SDK.
* We utilize Gemini for complex JSON batch-processing (generating 7 unique insights per profile) and context-aware conversational chat. No traditional backend is required!

## Running the Application

To run the application locally, you must provide your Google Gemini API key:

```bash
flutter run -d chrome --dart-define=GEMINI_API_KEY=your_api_key_here
```

## Why CarbonLens AI?

When you finish using CarbonLens AI, you won't say "I know my footprint." 
You will say, "I know exactly how to reach Grade A+ and earn 500 Green Credits this month."

This transforms carbon awareness from a guilt-trip into an engaging, rewarding, and highly tactical decision-making process.

## Challenge Submission

Built for **PromptWars Challenge 3**

**Theme**: Helping individuals understand, track, and reduce their carbon footprint through simple actions and personalized insights.

## Live Links

* **Frontend Application**: [https://carbonlens-ai-production-2936.up.railway.app](https://carbonlens-ai-production-2936.up.railway.app)
* **Backend API Proxy**: [https://carbonlens-ai-production.up.railway.app](https://carbonlens-ai-production.up.railway.app)


## License

MIT License
