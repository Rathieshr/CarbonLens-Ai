# CarbonLens AI Architecture

CarbonLens AI uses a modern, serverless-capable frontend coupled with a lightweight intelligence proxy.

## Monorepo Structure
- `/frontend`: A Flutter Web application handling all UI, routing, and local state.
- `/backend`: A Python FastAPI server handling secure communications with the LLM.

## Component Flow
1. **Client Interface**: User enters profile details.
2. **Local Processing Engine**: `CarbonEngine` (Dart) runs deterministic calculations to determine Footprint (in tonnes), Breakdown percentages, Carbon Grades, and Potential Credits.
3. **Intelligence Proxy**: `GeminiService` (Dart) sends the aggregated, calculated data payload to the FastAPI Backend via HTTP POST.
4. **Secure LLM Generation**: The Backend constructs a structured prompt, injects the `GEMINI_API_KEY` from the secure environment, and requests generation from `gemini-2.5-flash`.
5. **State Hydration**: The Backend responds with a strictly structured JSON payload, which the Frontend uses to hydrate the UI via `ValueNotifier` reactive listeners.

## State Management
We use a centralized `AppState` singleton wrapping Dart's native `ValueNotifier`. This allows deeply nested components (like `CarbonLensInsightCard`) to instantly react to asynchronous network completions without relying on heavy state-management libraries like Provider or Riverpod for this specific scoped data flow.

## Error Handling
The application implements exponential backoff for network requests and graceful string fallbacks if the API rate-limits or fails, ensuring the user experience never crashes.
