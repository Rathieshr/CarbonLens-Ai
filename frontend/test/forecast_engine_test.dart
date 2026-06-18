import 'package:flutter_test/flutter_test.dart';
import 'package:carbonlens_ai/services/carbon_engine.dart';
import 'package:carbonlens_ai/services/forecast_engine.dart';

void main() {
  group('Forecast Engine Tests', () {
    test('verify future projections maintain growth constraint', () {
      final totalFootprintTonnes = 5.0;
      final recommendations = [
        CarbonRecommendation(action: 'Test', impact: 1000, cost: 'Low', difficulty: 'Easy', priorityScore: 100)
      ];

      final result = ForecastEngine.calculateForecast(totalFootprintTonnes, recommendations);
      
      // Ensure paths are 5 years long
      expect(result.currentPath.length, 5);
      expect(result.optimizedPath.length, 5);
      
      // Current path should increase by 3% every year
      final currentY1 = result.currentPath[0]['value'] as double;
      final currentY2 = result.currentPath[1]['value'] as double;
      expect(currentY2, closeTo(currentY1 * 1.03, 0.001));

      // Optimized path should be lower than current path by year 2
      final optY2 = result.optimizedPath[1]['value'] as double;
      expect(optY2, lessThan(currentY2));
    });

    test('optimized projection does not drop below zero', () {
      final totalFootprintTonnes = 0.5; // Very low
      final recommendations = [
        CarbonRecommendation(action: 'Massive reduction', impact: 5000, cost: 'Low', difficulty: 'Easy', priorityScore: 100)
      ]; // Massive impact

      final result = ForecastEngine.calculateForecast(totalFootprintTonnes, recommendations);
      
      // Values should never be negative
      for (var point in result.optimizedPath) {
        expect(point['value'] as double, greaterThanOrEqualTo(0));
      }
    });
  });
}
