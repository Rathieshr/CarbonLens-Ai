# Security Policy

## Supported Versions

Only the latest `main` branch is actively supported with security updates.

## Threat Model & Architecture
CarbonLens AI employs a split frontend/backend architecture primarily to secure the **Google Gemini API Key**.

- **Frontend (Flutter Web)**: Handles all presentation logic and local client state. No sensitive credentials are ever compiled into the frontend web bundle.
- **Backend (FastAPI)**: Acts as a secure proxy. The frontend sends user profile parameters to the backend, which constructs the prompt, injects the `GEMINI_API_KEY` (stored securely as a server-side environment variable), and requests insights from the LLM.

## Input Validation & Sanitization
The FastAPI backend strictly enforces payload validation using Pydantic:
- `ChatRequest.prompt` is strictly limited to 1000 characters to prevent denial-of-service (DoS) via excessively large context windows.
- Payloads missing required schema fields are rejected with a `422 Unprocessable Entity` error before any processing occurs.

## CORS Configuration
Cross-Origin Resource Sharing (CORS) is strictly limited to:
- Local development domains (`localhost:8000`, `localhost:8080`, `localhost:3000`)
- The verified production Railway frontend URL

Requests originating from untrusted domains will be rejected by the browser and the FastAPI middleware.

## Reporting a Vulnerability

Please report security vulnerabilities by creating a Private GitHub Issue in this repository. Do not open public issues for sensitive exploits.
