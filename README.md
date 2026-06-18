# CarbonLens AI 🌍

> Detect. Predict. Earn.

## Overview

**CarbonLens AI** is a premium Personal Carbon Intelligence Platform that goes beyond simple footprint calculations. It helps individuals understand, track, and monetize their carbon footprint through actionable intelligence and a gamified Green Credits system.

Unlike traditional calculators that leave you feeling guilty and confused, CarbonLens AI identifies hidden carbon leaks, forecasts your future environmental trajectory, and rewards you with **Carbon Credits** for making high-impact lifestyle changes.

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

---

## Production Deployment (Railway)

CarbonLens AI is architected as a monorepo containing a Flutter Web frontend and a FastAPI Python backend. The backend securely proxies all requests to Google Gemini, ensuring your API key is never exposed to the client.

We recommend [Railway.app](https://railway.app) for zero-config, production-ready deployments.

### 1. Backend Setup

The backend handles all AI generation securely.

1. Create a new **Empty Project** in Railway.
2. Select **Add Service** > **GitHub Repo** and choose your CarbonLens repository.
3. Once the service is created, go to **Settings** > **Root Directory** and set it to `/backend`.
4. Go to **Variables** and add your Gemini API Key:
   * `GEMINI_API_KEY`: `your_actual_gemini_api_key_here`
5. Railway will automatically detect the `railway.json` and `requirements.txt` to build the Python environment.
6. Go to **Settings** > **Public Networking** and click **Generate Domain** (e.g., `carbonlens-api.up.railway.app`).

### 2. Frontend Setup

The frontend is a Flutter Web app served via a lightweight Node container.

1. Open your code editor and update `frontend/lib/config/app_config.dart`:
   * Change `productionBackendUrl` to the domain Railway just generated for your backend.
   * Commit and push this change to GitHub.
2. In your Railway Project, select **Add Service** > **GitHub Repo** and choose your repository again.
3. Go to **Settings** > **Root Directory** and set it to `/frontend`.
4. Railway will automatically detect the `Dockerfile` and `railway.json` and build the Flutter Web app.
5. Go to **Settings** > **Public Networking** and click **Generate Domain**.

### 3. Verification Steps

1. Visit your frontend URL in the browser.
2. The UI should load perfectly.
3. Submit a carbon profile. If the insights populate successfully, your backend is correctly talking to Gemini and your CORS rules are active!

## License

MIT License
