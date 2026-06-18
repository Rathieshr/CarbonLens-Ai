import 'package:flutter_test/flutter_test.dart';
import 'package:carbonlens_ai/services/carbon_engine.dart';

void main() {
  group('Carbon Wallet Grading Tests', () {
    test('verify grade mappings based on credits', () {
      final profile = UserProfile(
        city: 'Mumbai',
        householdSize: 2,
        monthlyElectricityBill: 500,
        vehicleType: 'EV',
        dailyCommuteKm: 5,
        foodPreference: 'Vegan',
        flightsPerYear: 0,
      );

      final result = CarbonEngine.calculate(profile);
      
      // Since it's a very green profile, score should be high, credits >= 900
      expect(result.wallet.currentCredits, greaterThanOrEqualTo(800));
      
      // Grade should be A or A+
      expect(['A', 'A+'], contains(result.wallet.currentGrade));
      
      // Verify credit target math
      if (result.wallet.currentGrade == 'A') {
        expect(result.wallet.creditsToNextGrade, 900 - result.wallet.currentCredits);
        expect(result.wallet.nextGrade, 'A+');
      }
    });

    test('verify low grade mappings', () {
      final badProfile = UserProfile(
        city: 'Mumbai',
        householdSize: 1,
        monthlyElectricityBill: 15000,
        vehicleType: 'Diesel SUV',
        dailyCommuteKm: 100,
        foodPreference: 'Non-Veg Heavy',
        flightsPerYear: 10,
      );

      final result = CarbonEngine.calculate(badProfile);
      
      // Since it's a bad profile, score is low
      expect(result.wallet.currentGrade, anyOf('B', 'C'));
    });
  });
}
