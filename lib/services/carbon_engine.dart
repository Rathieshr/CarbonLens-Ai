class UserProfile {
  String city;
  int householdSize;
  double monthlyElectricityBill;
  String vehicleType;
  double dailyCommuteKm;
  String foodPreference;
  int flightsPerYear;

  UserProfile({
    required this.city,
    required this.householdSize,
    required this.monthlyElectricityBill,
    required this.vehicleType,
    required this.dailyCommuteKm,
    required this.foodPreference,
    required this.flightsPerYear,
  });
}

class CarbonLeak {
  final String title;
  final String severity;
  final double impact;
  final String explanation;
  final String suggestedAction;

  CarbonLeak({
    required this.title,
    required this.severity,
    required this.impact,
    required this.explanation,
    required this.suggestedAction,
  });
}

class CarbonRecommendation {
  final String action;
  final double impact;
  final String cost;
  final String difficulty;
  final int priorityScore;

  CarbonRecommendation({
    required this.action,
    required this.impact,
    required this.cost,
    required this.difficulty,
    required this.priorityScore,
  });
}

class CarbonWallet {
  final int currentCredits;
  final int monthlyCredits;
  final int lifetimeCredits;
  final String currentGrade;
  final String nextGrade;
  final int creditsToNextGrade;
  final List<Map<String, dynamic>> creditSources;
  final List<Map<String, dynamic>> potentialCredits;
  final List<Map<String, dynamic>> milestones;
  final List<Map<String, dynamic>> forecast; 
  final Map<String, dynamic> impactEquivalents;

  CarbonWallet({
    required this.currentCredits,
    required this.monthlyCredits,
    required this.lifetimeCredits,
    required this.currentGrade,
    required this.nextGrade,
    required this.creditsToNextGrade,
    required this.creditSources,
    required this.potentialCredits,
    required this.milestones,
    required this.forecast,
    required this.impactEquivalents,
  });
}

class CarbonResult {
  final double totalFootprint;
  final Map<String, double> breakdown;
  final int healthScore;
  final List<CarbonLeak> leaks;
  final List<Map<String, num>> currentPath;
  final List<Map<String, num>> optimizedPath;
  final List<CarbonRecommendation> recommendations;
  final CarbonWallet wallet;

  CarbonResult({
    required this.totalFootprint,
    required this.breakdown,
    required this.healthScore,
    required this.leaks,
    required this.currentPath,
    required this.optimizedPath,
    required this.recommendations,
    required this.wallet,
  });
}

class CarbonEngine {
  static CarbonResult calculate(UserProfile profile) {
    // 1. Transport Footprint
    double annualCommuteKm = profile.dailyCommuteKm * 365;
    double emissionFactor = 0.19; // Default Petrol
    if (profile.vehicleType.toLowerCase().contains('diesel')) {
      emissionFactor = 0.17;
    } else if (profile.vehicleType.toLowerCase().contains('motorcycle')) {
      emissionFactor = 0.09;
    } else if (profile.vehicleType.toLowerCase().contains('ev') || profile.vehicleType.toLowerCase().contains('electric')) {
      emissionFactor = 0.05;
    } else if (profile.vehicleType.toLowerCase().contains('public')) {
      emissionFactor = 0.06;
    }
    double transportFootprintKg = annualCommuteKm * emissionFactor;

    // 2. Electricity Footprint
    // Rough estimate: ₹10 per kWh in India/general
    double estimatedKwh = profile.monthlyElectricityBill / 10.0;
    // 0.82 kg CO2 per kWh
    double electricityFootprintKg = estimatedKwh * 0.82 * 12; // Annualize

    // 3. Food Footprint
    double foodFootprintKg = 900; // Mixed
    if (profile.foodPreference.toLowerCase().contains('non-veg')) {
      foodFootprintKg = 1400;
    } else if (profile.foodPreference.toLowerCase().contains('veg') && !profile.foodPreference.toLowerCase().contains('non')) {
      foodFootprintKg = 400;
    }

    // 4. Flights Footprint
    double flightsFootprintKg = profile.flightsPerYear * 250.0;

    // Total Footprint in tonnes
    double totalFootprintKg = transportFootprintKg + electricityFootprintKg + foodFootprintKg + flightsFootprintKg;
    double totalFootprintTonnes = totalFootprintKg / 1000.0;

    // Breakdown percentages
    Map<String, double> breakdown = {
      'Transport': (transportFootprintKg / totalFootprintKg) * 100,
      'Electricity': (electricityFootprintKg / totalFootprintKg) * 100,
      'Food': (foodFootprintKg / totalFootprintKg) * 100,
      'Travel': (flightsFootprintKg / totalFootprintKg) * 100,
    };

    // Health Score
    int healthScore = 100;
    if (totalFootprintTonnes < 2) {
      healthScore = 95;
    } else if (totalFootprintTonnes < 4) {
      healthScore = 80;
    } else if (totalFootprintTonnes < 6) {
      healthScore = 60;
    } else {
      healthScore = 40;
    }

    // Leaks
    List<CarbonLeak> leaks = [];
    if (profile.vehicleType.toLowerCase().contains('petrol') || profile.vehicleType.toLowerCase().contains('diesel')) {
      leaks.add(CarbonLeak(
        title: '${profile.vehicleType} Usage',
        severity: 'High',
        impact: transportFootprintKg,
        explanation: 'Fossil fuel vehicles emit significant CO2 compared to alternatives.',
        suggestedAction: 'Consider switching to an EV or using public transport.',
      ));
    }
    if (profile.dailyCommuteKm > 15) {
      leaks.add(CarbonLeak(
        title: 'Long Commute',
        severity: 'High',
        impact: transportFootprintKg * 0.5,
        explanation: 'Commuting long distances daily heavily increases your footprint.',
        suggestedAction: 'Try working from home a few days a week if possible.',
      ));
    }
    if (electricityFootprintKg > 1500) {
      leaks.add(CarbonLeak(
        title: 'High Electricity Usage',
        severity: 'Medium',
        impact: electricityFootprintKg - 1000,
        explanation: 'Your monthly bill indicates high energy consumption, possibly from AC or heating.',
        suggestedAction: 'Optimize AC usage or switch to energy-efficient appliances.',
      ));
    }
    if (profile.foodPreference.toLowerCase().contains('non-veg')) {
      leaks.add(CarbonLeak(
        title: 'High-Impact Diet',
        severity: 'Medium',
        impact: foodFootprintKg - 900,
        explanation: 'Meat consumption has a higher carbon footprint than plant-based diets.',
        suggestedAction: 'Incorporate more plant-based meals into your weekly routine.',
      ));
    }
    if (profile.flightsPerYear > 2) {
      leaks.add(CarbonLeak(
        title: 'Frequent Flying',
        severity: 'Medium',
        impact: flightsFootprintKg,
        explanation: 'Air travel is one of the most carbon-intensive activities.',
        suggestedAction: 'Reduce non-essential flights or choose direct flights.',
      ));
    }

    // Recommendations
    List<CarbonRecommendation> recommendations = [];
    if (profile.dailyCommuteKm > 10) {
      recommendations.add(CarbonRecommendation(
        action: 'WFH 2 days/week',
        impact: transportFootprintKg * (2/7), // Approximate savings
        cost: 'No cost',
        difficulty: 'Medium',
        priorityScore: 90,
      ));
    }
    if (profile.vehicleType.toLowerCase().contains('petrol') || profile.vehicleType.toLowerCase().contains('diesel')) {
      recommendations.add(CarbonRecommendation(
        action: 'Switch to EV',
        impact: transportFootprintKg * 0.7, // Estimate 70% reduction
        cost: 'High cost',
        difficulty: 'High',
        priorityScore: 70,
      ));
      recommendations.add(CarbonRecommendation(
        action: 'Use public transport twice/week',
        impact: transportFootprintKg * 0.2, // Estimate
        cost: 'Low cost',
        difficulty: 'Easy',
        priorityScore: 85,
      ));
    }
    if (electricityFootprintKg > 1000) {
      recommendations.add(CarbonRecommendation(
        action: 'Reduce AC runtime / Optimize heating',
        impact: electricityFootprintKg * 0.15,
        cost: 'No cost',
        difficulty: 'Easy',
        priorityScore: 95,
      ));
      recommendations.add(CarbonRecommendation(
        action: 'Solar installation',
        impact: electricityFootprintKg * 0.8,
        cost: 'High cost',
        difficulty: 'Medium',
        priorityScore: 80,
      ));
    }

    // Sort recommendations by priority score (descending)
    recommendations.sort((a, b) => b.priorityScore.compareTo(a.priorityScore));

    // Time Machine Forecast
    List<Map<String, num>> currentPath = [];
    List<Map<String, num>> optimizedPath = [];
    
    double currentYearFootprint = totalFootprintTonnes;
    double optimizedYearFootprint = totalFootprintTonnes;
    
    // Total recommended reduction
    double totalReductionKg = recommendations.fold(0.0, (sum, item) => sum + item.impact);
    double totalReductionTonnes = totalReductionKg / 1000.0;
    
    int currentYear = 2026;
    for (int i = 0; i < 5; i++) {
      currentPath.add({'year': currentYear + i, 'value': currentYearFootprint});
      optimizedPath.add({'year': currentYear + i, 'value': optimizedYearFootprint});
      
      currentYearFootprint = currentYearFootprint * 1.03; // 3% increase
      
      // For optimized, apply reductions linearly over first 2 years, then maintain
      if (i < 2) {
        optimizedYearFootprint = optimizedYearFootprint - (totalReductionTonnes / 2);
        if (optimizedYearFootprint < 0) optimizedYearFootprint = 0;
      }
      // Apply a smaller increase (e.g. 1%) to optimized path
      optimizedYearFootprint = optimizedYearFootprint * 1.01;
    }

    // Wallet Calculation
    int currentCredits = healthScore * 10;
    int lifetimeCredits = currentCredits + 500;
    int monthlyCredits = (currentCredits * 0.15).round();

    String currentGrade = 'C';
    String nextGrade = 'B';
    int creditsToNextGrade = 0;
    if (currentCredits >= 900) { currentGrade = 'A+'; nextGrade = 'A+'; creditsToNextGrade = 0; }
    else if (currentCredits >= 800) { currentGrade = 'A'; nextGrade = 'A+'; creditsToNextGrade = 900 - currentCredits; }
    else if (currentCredits >= 700) { currentGrade = 'B+'; nextGrade = 'A'; creditsToNextGrade = 800 - currentCredits; }
    else if (currentCredits >= 600) { currentGrade = 'B'; nextGrade = 'B+'; creditsToNextGrade = 700 - currentCredits; }
    else { currentGrade = 'C'; nextGrade = 'B'; creditsToNextGrade = 600 - currentCredits; }

    List<Map<String, dynamic>> creditSources = [
      {'title': 'Work From Home', 'credits': (monthlyCredits * 0.4).round(), 'carbonSaved': 120},
      {'title': 'Reduced AC Usage', 'credits': (monthlyCredits * 0.3).round(), 'carbonSaved': 80},
      {'title': 'Public Transport', 'credits': (monthlyCredits * 0.2).round(), 'carbonSaved': 50},
      {'title': 'Energy Efficient Appliances', 'credits': (monthlyCredits * 0.1).round(), 'carbonSaved': 30},
    ];

    List<Map<String, dynamic>> potentialCredits = recommendations.map((rec) {
      return {
        'title': rec.action,
        'credits': (rec.impact / 5).round(),
      };
    }).toList();

    List<Map<String, dynamic>> milestones = [
      {'title': 'First 100 Credits', 'locked': false},
      {'title': '500 Credits Club', 'locked': lifetimeCredits < 500},
      {'title': '1000 Credits Club', 'locked': lifetimeCredits < 1000},
      {'title': 'Grade A Achiever', 'locked': currentCredits < 800},
      {'title': 'Carbon Champion', 'locked': lifetimeCredits < 5000},
    ];

    List<Map<String, dynamic>> forecast = [];
    int projCurrent = currentCredits;
    int projOpt = currentCredits;
    List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
    for (int i = 0; i < 6; i++) {
      forecast.add({
        'month': months[i],
        'current': projCurrent,
        'optimized': projOpt
      });
      projCurrent += monthlyCredits;
      projOpt += monthlyCredits + (potentialCredits.isNotEmpty ? potentialCredits.first['credits'] as int : 50);
    }

    Map<String, dynamic> impactEquivalents = {
      'trees': (lifetimeCredits / 10).round(),
      'km': lifetimeCredits * 5,
      'energy': lifetimeCredits * 2,
      'co2': lifetimeCredits * 3,
    };

    CarbonWallet wallet = CarbonWallet(
      currentCredits: currentCredits,
      monthlyCredits: monthlyCredits,
      lifetimeCredits: lifetimeCredits,
      currentGrade: currentGrade,
      nextGrade: nextGrade,
      creditsToNextGrade: creditsToNextGrade,
      creditSources: creditSources,
      potentialCredits: potentialCredits,
      milestones: milestones,
      forecast: forecast,
      impactEquivalents: impactEquivalents,
    );

    return CarbonResult(
      totalFootprint: totalFootprintTonnes,
      breakdown: breakdown,
      healthScore: healthScore,
      leaks: leaks,
      currentPath: currentPath,
      optimizedPath: optimizedPath,
      recommendations: recommendations,
      wallet: wallet,
    );
  }
}
