import 'package:flutter/foundation.dart';
import '../services/carbon_engine.dart';

class AppState {
  static UserProfile? currentUserProfile;
  static CarbonResult? currentResult;
  static Map<String, dynamic>? aiInsights;
  static final ValueNotifier<Map<String, dynamic>?> aiInsightsNotifier = ValueNotifier(null);

  // Initialize with some default values to prevent null errors if skipped
  static void initDefaults() {
    currentUserProfile ??= UserProfile(
      city: 'Chennai',
      householdSize: 4,
      monthlyElectricityBill: 2500,
      vehicleType: 'Petrol Car',
      dailyCommuteKm: 18,
      foodPreference: 'Mixed',
      flightsPerYear: 1,
    );
    currentResult ??= CarbonEngine.calculate(currentUserProfile!);
  }
}
