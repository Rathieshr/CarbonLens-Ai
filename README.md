# CarbonLens AI 🌍

> Detect. Predict. Reduce.

## Overview

CarbonLens AI is an AI-powered Carbon Observability Platform that helps individuals understand, track, and reduce their carbon footprint through actionable insights rather than generic carbon calculations.

Unlike traditional carbon footprint calculators that only measure emissions, CarbonLens AI identifies hidden carbon leaks, predicts future environmental impact, and recommends the highest-impact actions users can take to reduce their footprint.

## Problem Statement

Most people are aware that their daily activities contribute to carbon emissions, but they struggle to answer critical questions:

* Where are my largest carbon emissions coming from?
* Which habits are causing the most environmental impact?
* What will happen if I continue my current lifestyle?
* Which changes will create the biggest reduction in emissions?
* How can I make informed sustainability decisions?

Current solutions often provide static carbon calculations without meaningful guidance or future planning.

## Solution

CarbonLens AI introduces the concept of Carbon Observability.

Instead of simply calculating emissions, CarbonLens AI:

* Detects hidden carbon leaks
* Forecasts future carbon emissions
* Simulates the impact of lifestyle changes
* Prioritizes actions based on impact, cost, and difficulty
* Generates personalized sustainability plans

## Key Features

### 1. Carbon MRI

Generate a comprehensive carbon health assessment based on:

* Household information
* Electricity consumption
* Transportation habits
* Food preferences
* Travel patterns

Output includes:

* Carbon Health Score
* Annual Carbon Footprint
* Emission Breakdown by Category

---

### 2. Carbon Leak Detection

Identify hidden emission sources and inefficient lifestyle patterns.

Examples:

* Frequent solo commuting
* Excessive cooling usage
* High delivery dependency
* Energy-intensive habits

Each carbon leak is ranked by:

* Severity
* Annual Impact
* Improvement Potential

---

### 3. Carbon Time Machine

Visualize future emissions based on current lifestyle trends.

Users can compare:

#### Current Path

2026 → 4.1 tCO₂e

2027 → 4.3 tCO₂e

2028 → 4.5 tCO₂e

2029 → 4.7 tCO₂e

2030 → 5.0 tCO₂e

#### Optimized Path

2026 → 4.1 tCO₂e

2027 → 3.7 tCO₂e

2028 → 3.3 tCO₂e

2029 → 3.0 tCO₂e

2030 → 2.8 tCO₂e

---

### 4. Impact Optimizer

Rank carbon reduction opportunities by:

* Environmental Impact
* Financial Cost
* Difficulty Level
* Expected Savings

Examples:

| Action             | Carbon Impact | Cost      | Difficulty |
| ------------------ | ------------- | --------- | ---------- |
| Work From Home     | High          | Low       | Easy       |
| Public Transport   | Medium        | Low       | Easy       |
| Solar Installation | Very High     | High      | Medium     |
| Electric Vehicle   | High          | Very High | Medium     |

---

### 5. Carbon Budget

Translate carbon emissions into an understandable budget system.

Users can track:

* Annual Carbon Allowance
* Carbon Consumed
* Remaining Carbon Budget

This helps users make informed sustainability decisions before taking actions.

---

### 6. AI-Powered Recommendations

Using Google Gemini, CarbonLens AI generates:

* Personalized carbon reduction plans
* Sustainability recommendations
* Carbon leak explanations
* Future scenario analysis
* Impact summaries

## Architecture

```text
Flutter Web Frontend
          |
          v
      FastAPI Backend
          |
          v
      Gemini AI
```

## Technology Stack

### Frontend

* Flutter Web
* Material Design
* fl_chart

### Backend

* FastAPI
* Python

### AI

* Google Gemini

### Deployment

* Frontend: GitHub Pages / Firebase Hosting
* Backend: Railway / Render

## User Flow

```text
Profile Setup
      |
      v
Carbon MRI
      |
      v
Carbon Leak Detection
      |
      v
Carbon Time Machine
      |
      v
Impact Optimizer
      |
      v
AI Action Plan
```

## Why CarbonLens AI?

Most carbon footprint applications stop at measurement.

CarbonLens AI focuses on:

### Detect

Identify hidden carbon leaks.

### Predict

Forecast future environmental impact.

### Reduce

Recommend the highest-impact actions.

This transforms carbon awareness into practical decision-making.

## Future Enhancements

### Smart Meter Integration

Real-time energy monitoring through smart meters.

### IoT Device Integration

* Smart plugs
* Home energy systems
* EV chargers

### Community Carbon Benchmarking

Compare carbon performance across communities and neighborhoods.

### Automated Carbon Tracking

Passive data collection and continuous carbon monitoring.

## AI Usage

Google Gemini is used for:

* Carbon leak analysis
* Personalized recommendations
* Emission forecasting explanations
* Scenario evaluation
* Sustainability action plans

## Screenshots

Add screenshots here.

### Carbon MRI

[Insert Screenshot]

### Carbon Leak Detection

[Insert Screenshot]

### Carbon Time Machine

[Insert Screenshot]

### Impact Optimizer

[Insert Screenshot]

## Live Demo

[Deployment URL]

## Repository

[GitHub Repository URL]

## Challenge Submission

Built for PromptWars Challenge 3

Theme:

Helping individuals understand, track, and reduce their carbon footprint through simple actions and personalized insights.

## License

MIT License
