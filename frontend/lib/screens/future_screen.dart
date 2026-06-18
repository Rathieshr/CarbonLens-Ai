import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/glass_card.dart';
import '../widgets/insight_card.dart';
import '../core/app_state.dart';

class FutureScreen extends StatelessWidget {
  const FutureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppState.initDefaults();
    final result = AppState.currentResult!;
    final wallet = result.wallet;

    double projectedSavings = 0;
    if (result.currentPath.isNotEmpty && result.optimizedPath.isNotEmpty) {
      projectedSavings = (result.currentPath.last['value'] as double) - (result.optimizedPath.last['value'] as double);
    }
    int treesEquivalent = (projectedSavings * 1000 / 20).round();

    return Scaffold(
      appBar: AppBar(title: const Text('Future Trajectory'), centerTitle: true, elevation: 0, backgroundColor: Colors.transparent),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              _buildGradeSection(wallet.currentGrade, wallet.nextGrade, wallet.creditsToNextGrade),
              const SizedBox(height: 32),
              
              ValueListenableBuilder<Map<String, dynamic>?>(
                valueListenable: AppState.aiInsightsNotifier,
                builder: (context, insights, child) {
                  return CarbonLensInsightCard(
                    title: 'Carbon Wealth Advisor',
                    icon: Icons.account_balance,
                    insightText: insights?['wealth_advisor'],
                    isGenerating: insights == null,
                  );
                },
              ),
              const SizedBox(height: 32),

              _buildForecastChart(context, wallet.forecast),
              const SizedBox(height: 32),

              _buildMilestones(context, wallet.milestones),
              const SizedBox(height: 32),

              const Text('Environmental Impact Projection', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(Icons.eco, color: Colors.greenAccent, size: 32),
                          const SizedBox(height: 8),
                          Text('${projectedSavings.toStringAsFixed(1)} tCO₂e', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                          const Text('Projected Savings', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(Icons.forest, color: Colors.green, size: 32),
                          const SizedBox(height: 8),
                          Text('$treesEquivalent', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                          const Text('Trees Equivalent', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ValueListenableBuilder<Map<String, dynamic>?>(
                valueListenable: AppState.aiInsightsNotifier,
                builder: (context, insights, child) {
                  return CarbonLensInsightCard(
                    title: 'Future Forecast Analyst',
                    icon: Icons.timeline,
                    insightText: insights?['forecast_analyst'],
                    isGenerating: insights == null,
                  );
                },
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradeSection(String current, String next, int needed) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Current Grade', style: TextStyle(color: Colors.white70)),
                  Text(current, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Next Grade', style: TextStyle(color: Colors.white70)),
                  Text(next, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white38)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Stack(
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
              ),
              if (needed > 0)
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 0.6),
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeOut,
                  builder: (context, double value, child) {
                    return FractionallySizedBox(
                      widthFactor: value,
                      child: Container(
                        height: 12,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Colors.green, Colors.greenAccent]),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [BoxShadow(color: Colors.greenAccent.withValues(alpha: 0.5), blurRadius: 8)],
                        ),
                      ),
                    );
                  },
                ),
              if (needed == 0)
                Container(
                  height: 12,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Colors.green, Colors.greenAccent]),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [BoxShadow(color: Colors.greenAccent.withValues(alpha: 0.5), blurRadius: 8)],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (needed > 0)
            Center(child: Text('$needed Credits needed for Grade $next', style: const TextStyle(color: Colors.greenAccent, fontSize: 14))),
          if (needed == 0)
            const Center(child: Text('Maximum Grade Achieved!', style: TextStyle(color: Colors.greenAccent, fontSize: 14, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildForecastChart(BuildContext context, List<Map<String, dynamic>> forecast) {
    if (forecast.isEmpty) return const SizedBox();

    List<FlSpot> currentSpots = [];
    List<FlSpot> optimizedSpots = [];
    double maxY = 0;
    
    for (int i = 0; i < forecast.length; i++) {
      double current = (forecast[i]['current'] as num).toDouble();
      double optimized = (forecast[i]['optimized'] as num).toDouble();
      currentSpots.add(FlSpot(i.toDouble(), current));
      optimizedSpots.add(FlSpot(i.toDouble(), optimized));
      if (optimized > maxY) maxY = optimized;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('6-Month Credit Forecast', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        GlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem('Current Trajectory', Colors.white54),
                  const SizedBox(width: 24),
                  _buildLegendItem('Optimized Trajectory', Colors.greenAccent),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (value) => FlLine(color: Colors.white10, strokeWidth: 1)),
                    titlesData: FlTitlesData(
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            if (index >= 0 && index < forecast.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(forecast[index]['month'], style: const TextStyle(color: Colors.white54, fontSize: 12)),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: (forecast.length - 1).toDouble(),
                    minY: 0,
                    maxY: maxY * 1.2,
                    lineBarsData: [
                      LineChartBarData(
                        spots: currentSpots,
                        isCurved: true,
                        color: Colors.white54,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                      LineChartBarData(
                        spots: optimizedSpots,
                        isCurved: true,
                        color: Colors.greenAccent,
                        barWidth: 4,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.greenAccent.withValues(alpha: 0.1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildMilestones(BuildContext context, List<Map<String, dynamic>> milestones) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Milestones', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: milestones.length,
            itemBuilder: (context, index) {
              final m = milestones[index];
              bool locked = m['locked'] as bool;
              return Container(
                width: 100,
                margin: const EdgeInsets.only(right: 16),
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: locked ? Colors.white.withValues(alpha: 0.05) : Colors.greenAccent.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: locked ? Colors.white10 : Colors.greenAccent.withValues(alpha: 0.5), width: 2),
                      ),
                      child: Icon(
                        locked ? Icons.lock : Icons.workspace_premium,
                        color: locked ? Colors.white38 : Colors.greenAccent,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      m['title'],
                      style: TextStyle(color: locked ? Colors.white38 : Colors.white70, fontSize: 12),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
