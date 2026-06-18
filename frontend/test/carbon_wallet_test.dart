import 'package:flutter_test/flutter_test.dart';
import 'package:carbonlens_ai/services/carbon_engine.dart';

void main() {
  group('Carbon Wallet Tests', () {
    test('verify milestone logic', () {
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
      
      // Ensure milestones are generated
      expect(result.wallet.milestones.length, 5);
      
      // First milestone should be unlocked for standard profile since base credits > 100
      expect(result.wallet.milestones[0]['locked'], false);
    });

    test('verify potential credits calculation', () {
      final profile = UserProfile(
        city: 'Mumbai',
        householdSize: 2,
        monthlyElectricityBill: 5000,
        vehicleType: 'Petrol Car',
        dailyCommuteKm: 50,
        foodPreference: 'Non-Veg',
        flightsPerYear: 5,
      );

      final result = CarbonEngine.calculate(profile);
      
      // Should have recommendations and thus potential credits
      expect(result.recommendations.isNotEmpty, true);
      expect(result.wallet.potentialCredits.length, result.recommendations.length);
      
      // Potential credits should be correctly calculated from impact
      final firstRec = result.recommendations.first;
      final firstCredit = result.wallet.potentialCredits.first;
      
      expect(firstCredit['credits'], (firstRec.impact / 5).round());
    });
  });
}
