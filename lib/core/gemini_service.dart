import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'app_state.dart';

class GeminiService {
  static const String apiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');

  static Future<Map<String, dynamic>?> generateGlobalInsights() async {
    AppState.initDefaults();
    final result = AppState.currentResult!;

    if (apiKey.isEmpty) return null;

    try {
      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
      );

      final prompt = '''
You are the AI Intelligence Engine behind CarbonLens, a premium climate tech platform.
Based on the user's carbon profile, generate a JSON object with 7 specific insights.

User Profile:
Score: ${result.healthScore}/100
Footprint: ${result.totalFootprint.toStringAsFixed(1)} tCO2e
Breakdown: Transport ${result.breakdown['Transport']?.toStringAsFixed(1)}%, Electricity ${result.breakdown['Electricity']?.toStringAsFixed(1)}%, Food ${result.breakdown['Food']?.toStringAsFixed(1)}%, Travel ${result.breakdown['Travel']?.toStringAsFixed(1)}%

Top 3 Leaks: ${result.leaks.take(3).map((l) => l.title).join(', ')}
Top 3 Recommended Actions: ${result.recommendations.take(3).map((o) => o.action).join(', ')}

Provide your response ONLY as a valid JSON object with these EXACT keys:
{
  "health_analyst": "1-2 sentence high-level health assessment.",
  "diagnostic_specialist": "1-2 sentence narrative on the primary emission source.",
  "investigator": "1-2 sentence explanation of why the top leak matters.",
  "forecast_analyst": "1-2 sentence future outlook if they don't change vs if they optimize.",
  "strategist": "1-2 sentence explanation of why their top recommended action is the best choice.",
  "coach": "1-2 sentence adaptive coaching insight on what will bring their greatest success.",
  "wealth_advisor": "1-2 sentence insight forecasting their Green Credit potential if they follow the plan."
}
Do not include any markdown formatting or backticks, only the raw JSON.
''';

      final response = await model.generateContent([Content.text(prompt)]);
      String text = response.text ?? '';
      
      int startIdx = text.indexOf('{');
      int endIdx = text.lastIndexOf('}');
      if (startIdx != -1 && endIdx != -1 && endIdx > startIdx) {
        text = text.substring(startIdx, endIdx + 1);
        return jsonDecode(text) as Map<String, dynamic>;
      } else {
        print("Gemini API Error: No JSON found in response. Raw response: $text");
        return null;
      }
    } catch (e) {
      print("Gemini API Error in generateGlobalInsights: $e");
      return null;
    }
  }

  static Future<String?> askCarbonLens(String query) async {
    AppState.initDefaults();
    final result = AppState.currentResult!;

    if (apiKey.isEmpty) return "API Key not configured. Please add GEMINI_API_KEY to ask questions.";

    try {
      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
      );

      final contextPrompt = '''
You are "Ask CarbonLens", the personal sustainability advisor embedded in the CarbonLens platform.
Answer the user's question concisely based on their profile data:
Score: ${result.healthScore}/100
Footprint: ${result.totalFootprint.toStringAsFixed(1)} tCO2e
Top Action: ${result.recommendations.first.action}

User Question: "$query"

Keep it under 3 sentences. Be helpful, professional, and reference their specific data when relevant.
''';

      final response = await model.generateContent([Content.text(contextPrompt)]);
      return response.text;
    } catch (e) {
      print("Gemini API Error in askCarbonLens: $e");
      return "I'm having trouble analyzing your profile right now. Please try again later. (Error: $e)";
    }
  }
}
