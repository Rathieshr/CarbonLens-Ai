import 'package:flutter/foundation.dart';
import '../services/carbon_engine.dart';

class AppState {
  static UserProfile? currentUserProfile;
  static CarbonResult? currentResult;
  static Map<String, dynamic>? aiInsights;
  static final ValueNotifier<Map<String, dynamic>?> aiInsightsNotifier = ValueNotifier(null);

  static int _lastProfileHash = 0;

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
    _recalculateIfNeeded();
  }

  static void _recalculateIfNeeded() {
    if (currentUserProfile == null) return;
    
    // Hash code check for memoization
    int currentHash = Object.hash(
      currentUserProfile!.city,
      currentUserProfile!.householdSize,
      currentUserProfile!.monthlyElectricityBill,
      currentUserProfile!.vehicleType,
      currentUserProfile!.dailyCommuteKm,
      currentUserProfile!.foodPreference,
      currentUserProfile!.flightsPerYear,
    );

    if (_lastProfileHash != currentHash || currentResult == null) {
      currentResult = CarbonEngine.calculate(currentUserProfile!);
      _lastProfileHash = currentHash;
      
      // Clear AI insights so they get re-fetched for the new profile
      aiInsights = null;
      aiInsightsNotifier.value = null;
    }
  }

  static void updateProfile(UserProfile newProfile) {
    currentUserProfile = newProfile;
    _recalculateIfNeeded();
  }
}
