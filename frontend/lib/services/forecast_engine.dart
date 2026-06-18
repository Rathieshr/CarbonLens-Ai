import 'carbon_engine.dart';

class ForecastResult {
  final List<Map<String, num>> currentPath;
  final List<Map<String, num>> optimizedPath;

  ForecastResult({required this.currentPath, required this.optimizedPath});
}

class ForecastEngine {
  static ForecastResult calculateForecast(double totalFootprintTonnes, List<CarbonRecommendation> recommendations) {
    List<Map<String, num>> currentPath = [];
    List<Map<String, num>> optimizedPath = [];
    
    double currentYearFootprint = totalFootprintTonnes;
    double optimizedYearFootprint = totalFootprintTonnes;
    
    // Total recommended reduction
    double totalReductionKg = recommendations.fold(0.0, (sum, item) => sum + item.impact);
    double totalReductionTonnes = totalReductionKg / 1000.0;
    
    int currentYear = DateTime.now().year; // dynamic year
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

    return ForecastResult(currentPath: currentPath, optimizedPath: optimizedPath);
  }
}
