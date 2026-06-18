import 'carbon_engine.dart'; // To get CarbonRecommendation and CarbonWallet definitions

class WalletEngine {
  static CarbonWallet calculateWallet(int healthScore, List<CarbonRecommendation> recommendations) {
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

    return CarbonWallet(
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
  }
}
