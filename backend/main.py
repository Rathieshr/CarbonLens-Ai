import os
import json
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import google.generativeai as genai
from dotenv import load_dotenv

load_dotenv()

app = FastAPI()

# Railway domain + Localhost
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:8000",
        "http://localhost:8080",
        "http://localhost:3000",
        "http://127.0.0.1:8000",
        "http://127.0.0.1:8080",
        "https://carbonlens-frontend.up.railway.app", # Adjust if domain changes
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
if GEMINI_API_KEY:
    genai.configure(api_key=GEMINI_API_KEY)

# We use the same model defined in the Dart app
model = genai.GenerativeModel('gemini-2.5-flash')

class ProfileRequest(BaseModel):
    profile_data: dict

class ChatRequest(BaseModel):
    prompt: str
    context: dict

@app.get("/health")
def health_check():
    return {"status": "ok"}

@app.post("/api/insights")
def generate_insights(request: ProfileRequest):
    if not GEMINI_API_KEY:
        raise HTTPException(status_code=500, detail="Gemini API Key is not configured on the server.")
    
    try:
        prompt = f"""
        You are the CarbonLens AI core intelligence engine. 
        Analyze the following user profile and emission data. 
        Provide 5 distinct, highly specific, and actionable insights for each of these system components:
        
        Data: {json.dumps(request.profile_data)}
        
        Respond ONLY with a raw JSON object containing these exact keys, where each value is a 2-3 sentence string insight:
        - health_analyst (Overall health assessment)
        - diagnostic_specialist (Deep dive into their biggest emission category)
        - investigator (Root cause of a carbon leak)
        - wealth_advisor (How to earn more carbon credits)
        - forecast_analyst (Future projection insight)
        - strategist (Highest impact structural change to make)
        - coach (Encouraging 30-day plan summary)
        
        Do not include markdown blocks like ```json.
        """
        
        response = model.generate_content(prompt)
        text = response.text.replace("```json", "").replace("```", "").strip()
        data = json.loads(text)
        return {"insights": data}
    except Exception as e:
        print(f"Error generating insights: {e}")
        return {
            "insights": {
                "health_analyst": "Your footprint is being analyzed. Check back soon for detailed insights.",
                "diagnostic_specialist": "We are processing your category breakdown.",
                "investigator": "Scanning for structural leaks...",
                "wealth_advisor": "Calculate your potential credits by checking the Impact Center.",
                "forecast_analyst": "Projecting your lifestyle trends.",
                "strategist": "Review the impact optimizer for structural advice.",
                "coach": "Keep up the great work on your sustainability journey!"
            }
        }

@app.post("/api/chat")
def ask_carbonlens(request: ChatRequest):
    if not GEMINI_API_KEY:
        raise HTTPException(status_code=500, detail="Gemini API Key is not configured on the server.")
        
    try:
        prompt = f"""
        You are CarbonLens AI, an expert personal sustainability advisor.
        Answer the user's question concisely based on their data.
        If they ask about credits or grades, prioritize actionable advice.
        
        User Context: {json.dumps(request.context)}
        
        User Question: {request.prompt}
        """
        
        response = model.generate_content(prompt)
        return {"response": response.text}
    except Exception as e:
        print(f"Error chatting: {e}")
        raise HTTPException(status_code=500, detail="Failed to process chat request.")
