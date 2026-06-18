import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'app_state.dart';

class GeminiService {
  static Future<http.Response> _postWithRetry(Uri url, String body, {int maxRetries = 3}) async {
    int attempts = 0;
    while (attempts < maxRetries) {
      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: body,
        );
        if (response.statusCode == 200 || response.statusCode == 422) {
          return response;
        }
      } catch (e) {
        print("Network Error on attempt $attempts: $e");
      }
      attempts++;
      if (attempts < maxRetries) {
        await Future.delayed(Duration(seconds: 1 * attempts)); // Exponential backoff
      }
    }
    // Return a dummy 500 response if all retries fail
    return http.Response('{"detail": "Network timeout"}', 500);
  }

  static Future<Map<String, dynamic>?> generateGlobalInsights() async {
    AppState.initDefaults();
    final result = AppState.currentResult!;

    try {
      final url = Uri.parse('${AppConfig.backendUrl}/api/insights');
      final body = jsonEncode({
        'profile_data': {
          'healthScore': result.healthScore,
          'totalFootprint': result.totalFootprint,
          'breakdown': result.breakdown,
          'leaks': result.leaks.map((l) => {'title': l.title, 'severity': l.severity}).toList(),
          'recommendations': result.recommendations.map((r) => {'action': r.action, 'impact': r.impact}).toList(),
        }
      });
      
      final response = await _postWithRetry(url, body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['insights'] as Map<String, dynamic>;
      } else {
        print("Backend Error in generateGlobalInsights: ${response.statusCode}");
        // Fallback insights
        return {
          "health_analyst": "Your footprint is being analyzed. Check back soon for detailed insights.",
          "diagnostic_specialist": "We are processing your category breakdown.",
          "investigator": "Scanning for structural leaks...",
          "wealth_advisor": "Calculate your potential credits by checking the Impact Center.",
          "forecast_analyst": "Projecting your lifestyle trends.",
          "strategist": "Review the impact optimizer for structural advice.",
          "coach": "Keep up the great work on your sustainability journey!"
        };
      }
    } catch (e) {
      print("Network Error in generateGlobalInsights: $e");
      return null;
    }
  }

  static Future<String?> askCarbonLens(String query) async {
    AppState.initDefaults();
    final result = AppState.currentResult!;

    try {
      final url = Uri.parse('${AppConfig.backendUrl}/api/chat');
      final body = jsonEncode({
        'prompt': query,
        'context': {
          'healthScore': result.healthScore,
          'totalFootprint': result.totalFootprint,
          'topAction': result.recommendations.isNotEmpty ? result.recommendations.first.action : 'None',
        }
      });
      
      final response = await _postWithRetry(url, body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] as String;
      } else {
        print("Backend Error in askCarbonLens: ${response.statusCode}");
        return "I'm having trouble connecting to my intelligence core right now. Please check your network connection and try again.";
      }
    } catch (e) {
      print("Network Error in askCarbonLens: $e");
      return "I'm having trouble analyzing your profile right now. Please try again later.";
    }
  }
}
