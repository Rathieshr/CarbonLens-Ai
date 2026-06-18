import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';
import '../widgets/insight_card.dart';
import '../core/app_state.dart';

class IntelligenceScreen extends StatelessWidget {
  const IntelligenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppState.initDefaults();
    final result = AppState.currentResult!;

    return Scaffold(
      appBar: AppBar(title: const Text('Intelligence'), centerTitle: true, elevation: 0, backgroundColor: Colors.transparent),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              const Text('Emission Breakdown', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ...result.breakdown.entries.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildImpactBar(context, e.key, e.value, result.totalFootprint * (e.value / 100.0)),
                );
              }),

              const SizedBox(height: 16),
              ValueListenableBuilder<Map<String, dynamic>?>(
                valueListenable: AppState.aiInsightsNotifier,
                builder: (context, insights, child) {
                  return CarbonLensInsightCard(
                    title: 'Diagnostic Specialist',
                    icon: Icons.analytics,
                    insightText: insights?['diagnostic_specialist'],
                    isGenerating: insights == null,
                  );
                },
              ),
              const SizedBox(height: 48),

              const Text('Detected Carbon Leaks', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              if (result.leaks.isEmpty)
                const GlassCard(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: Text('No major leaks detected! Great job.', style: TextStyle(color: Colors.greenAccent)),
                  ),
                )
              else
                ...result.leaks.map((leak) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildLeakCard(leak),
                )),

              const SizedBox(height: 16),
              ValueListenableBuilder<Map<String, dynamic>?>(
                valueListenable: AppState.aiInsightsNotifier,
                builder: (context, insights, child) {
                  return CarbonLensInsightCard(
                    title: 'Carbon Investigator',
                    icon: Icons.radar,
                    insightText: insights?['investigator'],
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

  Widget _buildImpactBar(BuildContext context, String category, double percentage, double tonnes) {
    Color barColor = Colors.greenAccent;
    String risk = 'Low Risk';
    if (percentage > 40) {
      barColor = Colors.redAccent;
      risk = 'High Risk';
    } else if (percentage > 20) {
      barColor = Colors.amber;
      risk = 'Moderate';
    }

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('${percentage.toStringAsFixed(1)}%', style: TextStyle(color: barColor, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
              ),
              FractionallySizedBox(
                widthFactor: percentage / 100.0,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [BoxShadow(color: barColor.withValues(alpha: 0.5), blurRadius: 4)],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${tonnes.toStringAsFixed(2)} tCO₂e/yr', style: const TextStyle(color: Colors.white54, fontSize: 12)),
              Text(risk, style: TextStyle(color: barColor, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeakCard(dynamic leak) { 
    Color severityColor = Colors.greenAccent;
    if (leak.severity == 'High') {
      severityColor = Colors.redAccent;
    } else if (leak.severity == 'Medium') {
      severityColor = Colors.amber;
    }

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: severityColor, size: 20),
                  const SizedBox(width: 8),
                  Text(leak.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: severityColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: severityColor.withValues(alpha: 0.5)),
                ),
                child: Text(leak.severity, style: TextStyle(color: severityColor, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(leak.explanation, style: const TextStyle(color: Colors.white70, height: 1.5)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text(leak.suggestedAction, style: const TextStyle(color: Colors.amber, fontSize: 12))),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '+${leak.severity == 'High' ? 150 : leak.severity == 'Medium' ? 75 : 30} Potential Credits Recoverable',
            style: const TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
