from fastapi.testclient import TestClient
from main import app
import os

client = TestClient(app)

def test_api_missing_key_fallback(monkeypatch):
    # Ensure GEMINI_API_KEY is not set
    monkeypatch.delenv("GEMINI_API_KEY", raising=False)
    
    # We must patch the app's GEMINI_API_KEY variable which was loaded at module level
    import main
    main.GEMINI_API_KEY = None
    
    payload = {
        "profile_data": {
            "healthScore": 50,
            "totalFootprint": 4.5,
            "breakdown": {},
            "leaks": [],
            "recommendations": []
        }
    }
    
    response = client.post("/api/insights", json=payload)
    assert response.status_code == 500
    assert "Gemini API Key is not configured" in response.json()["detail"]

def test_chat_missing_key_fallback(monkeypatch):
    import main
    main.GEMINI_API_KEY = None
    
    payload = {
        "prompt": "How do I reduce carbon?",
        "context": {}
    }
    
    response = client.post("/api/chat", json=payload)
    assert response.status_code == 500
    assert "Gemini API Key is not configured" in response.json()["detail"]
