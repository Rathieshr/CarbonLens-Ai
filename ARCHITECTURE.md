# CarbonLens AI Architecture

CarbonLens AI uses a decoupled, SOLID-compliant monorepo architecture designed for maximum resilience, performance, and maintainability.

## 1. Component Flow & Separation of Concerns

### Carbon Engine (`services/carbon_engine.dart`)
The core domain logic. It is strictly responsible for parsing the `UserProfile` and generating base emissions data (Transport, Food, Travel, Energy). It acts as the orchestrator, delegating complex sub-systems to dedicated engines.

### Forecast Engine (`services/forecast_engine.dart`)
Extracts the "Time Machine" projection algorithms. Responsible for calculating the 5-year trajectory based on current habits vs. optimized recommendations.

### Wallet Engine (`services/wallet_engine.dart`)
Handles the Gamification layer. Calculates the user's Green Credits, determines the Carbon Grade (A+ to C), sets dynamically unlocking Milestones, and maps carbon impact to real-world equivalents (e.g., Trees planted).

### Gemini Intelligence Layer (`core/gemini_service.dart`)
The asynchronous communication bridge. It strictly manages `http` interactions with the FastAPI backend, utilizing an Exponential Backoff Retry Strategy and local memory caching (memoization) to prevent redundant API calls.

## 2. Serverless FastAPI Proxy (`/backend`)
Handles secure communications with the LLM.
- **Input Validation**: Uses `Pydantic` `Field` validations to enforce strict payload length and type rules.
- **Security**: Injects the `GEMINI_API_KEY` from a secure environment variable. The frontend *never* holds the API key.

## 3. Global State
We use a lightweight, reactive singleton (`AppState`) wrapping Dart `ValueNotifier`. It implements an object hashing algorithm to enforce strict memoization, ensuring the CPU-heavy Engines only fire when the underlying profile data fundamentally changes.
