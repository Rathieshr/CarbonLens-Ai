import 'package:flutter_test/flutter_test.dart';
import 'package:carbonlens_ai/services/carbon_engine.dart';

void main() {
  group('CarbonEngine Calculation Tests', () {
    test('calculate footprint for standard profile', () {
      final profile = UserProfile(
        city: 'Mumbai',
        householdSize: 2,
        monthlyElectricityBill: 2000,
        vehicleType: 'Petrol Car',
        dailyCommuteKm: 20,
        foodPreference: 'Mixed Diet',
        flightsPerYear: 2,
      );

      final result = CarbonEngine.calculate(profile);

      // Verify total footprint is positive
      expect(result.totalFootprint, greaterThan(0));

      // Verify breakdown percentages sum to 100%
      double sum = 0;
      result.breakdown.values.forEach((v) => sum += v);
      expect(sum, closeTo(100.0, 0.1));

      // Verify leaks are detected
      expect(result.leaks.isNotEmpty, true);
    });

    test('health score calculation bounds', () {
      // Extremely green profile
      final greenProfile = UserProfile(
        city: 'Mumbai',
        householdSize: 2,
        monthlyElectricityBill: 500,
        vehicleType: 'EV',
        dailyCommuteKm: 5,
        foodPreference: 'Vegan',
        flightsPerYear: 0,
      );

      final greenResult = CarbonEngine.calculate(greenProfile);
      expect(greenResult.healthScore, greaterThanOrEqualTo(80));

      // Extremely bad profile
      final badProfile = UserProfile(
        city: 'Mumbai',
        householdSize: 1,
        monthlyElectricityBill: 15000,
        vehicleType: 'Diesel SUV',
        dailyCommuteKm: 100,
        foodPreference: 'Non-Veg Heavy',
        flightsPerYear: 10,
      );

      final badResult = CarbonEngine.calculate(badProfile);
      expect(badResult.healthScore, lessThanOrEqualTo(60));
    });
  });
}
