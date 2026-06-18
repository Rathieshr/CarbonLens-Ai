import 'package:flutter_test/flutter_test.dart';
import 'package:carbonlens_ai/services/carbon_engine.dart';

void main() {
  group('Recommendation Ranking Tests', () {
    test('recommendations are sorted by priority score', () {
      final profile = UserProfile(
        city: 'Mumbai',
        householdSize: 4,
        monthlyElectricityBill: 5000,
        vehicleType: 'Petrol Car',
        dailyCommuteKm: 50,
        foodPreference: 'Non-Veg',
        flightsPerYear: 5,
      );

      final result = CarbonEngine.calculate(profile);
      
      expect(result.recommendations.isNotEmpty, true);
      
      // Ensure strictly descending order
      for (int i = 0; i < result.recommendations.length - 1; i++) {
        expect(
          result.recommendations[i].priorityScore >= result.recommendations[i+1].priorityScore, 
          true
        );
      }
    });
  });
}
