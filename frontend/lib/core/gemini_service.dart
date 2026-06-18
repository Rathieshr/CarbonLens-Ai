import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'app_state.dart';

class GeminiService {
  static Future<Map<String, dynamic>?> generateGlobalInsights() async {
    AppState.initDefaults();
    final result = AppState.currentResult!;

    try {
      final url = Uri.parse('${AppConfig.backendUrl}/api/insights');
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'profile_data': {
            'healthScore': result.healthScore,
            'totalFootprint': result.totalFootprint,
            'breakdown': result.breakdown,
            'leaks': result.leaks.map((l) => {'title': l.title, 'severity': l.severity}).toList(),
            'recommendations': result.recommendations.map((r) => {'action': r.action, 'impact': r.impact}).toList(),
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['insights'] as Map<String, dynamic>;
      } else {
        print("Backend Error in generateGlobalInsights: ${response.statusCode}");
        return null;
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
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'prompt': query,
          'context': {
            'healthScore': result.healthScore,
            'totalFootprint': result.totalFootprint,
            'topAction': result.recommendations.isNotEmpty ? result.recommendations.first.action : 'None',
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] as String;
      } else {
        print("Backend Error in askCarbonLens: ${response.statusCode}");
        return "I'm having trouble connecting to my intelligence core. Please try again later.";
      }
    } catch (e) {
      print("Network Error in askCarbonLens: $e");
      return "I'm having trouble analyzing your profile right now. Please try again later. (Error: $e)";
    }
  }
}
