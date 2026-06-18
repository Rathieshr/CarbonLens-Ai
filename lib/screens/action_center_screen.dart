import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';
import '../widgets/insight_card.dart';
import '../core/app_state.dart';

class ActionCenterScreen extends StatelessWidget {
  const ActionCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppState.initDefaults();
    final result = AppState.currentResult!;

    return Scaffold(
      appBar: AppBar(title: const Text('Action Center'), centerTitle: true, elevation: 0, backgroundColor: Colors.transparent),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              const Text('Top Recommendations', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ...result.recommendations.map((rec) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.greenAccent.withValues(alpha: 0.1), shape: BoxShape.circle),
                        child: const Icon(Icons.check_circle_outline, color: Colors.greenAccent),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(rec.action, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text('${rec.impact.toStringAsFixed(0)} kg CO₂e reduction potential', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                            const SizedBox(height: 8),
                            Text('+${(rec.impact * 2).toStringAsFixed(0)} Credits Earned Per Action', style: const TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 16),
                    ],
                  ),
                ),
              )).toList(),

              const SizedBox(height: 16),
              ValueListenableBuilder<Map<String, dynamic>?>(
                valueListenable: AppState.aiInsightsNotifier,
                builder: (context, insights, child) {
                  return CarbonLensInsightCard(
                    title: 'Carbon Strategist',
                    icon: Icons.lightbulb,
                    insightText: insights?['strategist'],
                    isGenerating: insights == null,
                  );
                },
              ),
              const SizedBox(height: 48),

              const Text('30-Day Execution Roadmap', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildFallbackTimeline(),

              const SizedBox(height: 16),
              ValueListenableBuilder<Map<String, dynamic>?>(
                valueListenable: AppState.aiInsightsNotifier,
                builder: (context, insights, child) {
                  return CarbonLensInsightCard(
                    title: 'Personal Sustainability Coach',
                    icon: Icons.sports_score,
                    insightText: insights?['coach'],
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

  Widget _buildFallbackTimeline() {
    AppState.initDefaults();
    final recs = AppState.currentResult!.recommendations.take(3).toList();
    double totalSavings = recs.fold(0, (sum, item) => sum + item.impact);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlassCard(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryStat('Current Footprint', '${AppState.currentResult!.totalFootprint.toStringAsFixed(1)} tCO₂e', Colors.white),
              _buildSummaryStat('Goal', '-${totalSavings.toStringAsFixed(0)} kg', Colors.greenAccent),
              _buildSummaryStat('Future Footprint', '${(AppState.currentResult!.totalFootprint - (totalSavings/1000)).toStringAsFixed(1)} tCO₂e', Colors.lightBlue),
            ],
          ),
        ),
        const SizedBox(height: 32),
        
        _buildTimelineNode(
          title: 'Phase 1: Baseline',
          description: 'Track your current habits for 7 days without changing anything. Identify specific times and places where these top actions can be applied.',
          isFirst: true,
          isLast: false,
        ),
        _buildTimelineNode(
          title: 'Phase 2: First Change',
          description: "Implement the top recommended action: ${recs.isNotEmpty ? recs.first.action : 'Start small'}. Commit to this single change for the entire week to build momentum.",
          isFirst: false,
          isLast: false,
        ),
        _buildTimelineNode(
          title: 'Phase 3: Optimization',
          description: "Add the remaining actions (${recs.length > 1 ? recs.skip(1).map((r) => r.action).join(' and ') : 'Continue optimization'}). Adjust your routine based on what felt difficult in Phase 2.",
          isFirst: false,
          isLast: false,
        ),
        _buildTimelineNode(
          title: 'Phase 4: Habit Lock',
          description: 'Reflect on the past 3 weeks. If any action is too difficult, scale it back by 20% but do not quit. Set a permanent goal to maintain these changes monthly.',
          isFirst: false,
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildSummaryStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildTimelineNode({required String title, required String description, required bool isFirst, required bool isLast}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 2,
                  height: 20,
                  color: isFirst ? Colors.transparent : Colors.greenAccent.withValues(alpha: 0.3),
                ),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.greenAccent.withValues(alpha: 0.5), blurRadius: 8)],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast ? Colors.transparent : Colors.greenAccent.withValues(alpha: 0.3),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.greenAccent)),
                    const SizedBox(height: 8),
                    Text(description, style: const TextStyle(color: Colors.white70, height: 1.5)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
