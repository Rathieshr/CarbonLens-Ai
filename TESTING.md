# Testing Strategy

CarbonLens AI uses an aggressive testing strategy targeting maximum coverage of core business logic.

## 1. Carbon Engine Tests (`carbon_engine_test.dart`)
Validates that the fundamental math behind footprint generation, leak detection, and breakdown generation is mathematically sound. 
- *Includes boundary tests for green vs. highly polluting profiles.*

## 2. Wallet & Gamification Tests (`carbon_wallet_test.dart` / `carbon_grade_test.dart`)
Tests the extraction logic inside `WalletEngine` to ensure Green Credits scale linearly with footprint reductions, and that Milestones unlock correctly based on lifetime balances.
- *Includes transition testing for Grade A+ logic.*

## 3. Forecast Tests (`forecast_engine_test.dart`)
Validates the Time Machine forecasting algorithm inside `ForecastEngine`.
- *Ensures linear reductions in the optimized path don't dip below absolute zero.*

## 4. Input Validation & Security (`test_input_validation.py`)
Validates backend schema definitions using Pydantic.
- *Tests null values, extreme bounds, and missing dictionaries.*

## 5. Gemini Proxy Reliability (`test_gemini_fallback.py`)
Tests the backend's ability to gracefully catch network errors, missing API keys, or timeout events and return valid JSON structures.
