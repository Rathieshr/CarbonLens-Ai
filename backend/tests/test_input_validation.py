from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_missing_profile_data():
    # Sending empty payload to insights endpoint
    response = client.post("/api/insights", json={})
    assert response.status_code == 422 # Unprocessable Entity
    
    # Missing required 'profile_data' field
    data = response.json()
    assert data["detail"][0]["loc"] == ["body", "profile_data"]
    assert data["detail"][0]["msg"] == "Field required"

def test_chat_validation():
    # Sending missing prompt to chat endpoint
    response = client.post("/api/chat", json={"context": {}})
    assert response.status_code == 422
    data = response.json()
    assert data["detail"][0]["loc"] == ["body", "prompt"]

def test_chat_validation_missing_context():
    # Sending missing context to chat endpoint
    response = client.post("/api/chat", json={"prompt": "Hello"})
    assert response.status_code == 422
    data = response.json()
    assert data["detail"][0]["loc"] == ["body", "context"]

def test_chat_validation_extreme_prompt():
    # Sending massive payload to test boundary limits
    massive_string = "a" * 5000
    response = client.post("/api/chat", json={"prompt": massive_string, "context": {}})
    assert response.status_code == 422
    data = response.json()
    # Prompt is limited to 1000 characters by Pydantic Field
    assert data["detail"][0]["loc"] == ["body", "prompt"]
    assert "String should have at most 1000 characters" in data["detail"][0]["msg"]

