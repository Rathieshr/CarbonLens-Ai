import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/glass_card.dart';
import '../widgets/insight_card.dart';
import '../core/app_state.dart';
import '../core/extensions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppState.initDefaults();
    final result = AppState.currentResult!;
    final wallet = result.wallet;

    return Scaffold(
      appBar: AppBar(title: const Text('Command Center'), centerTitle: true, elevation: 0, backgroundColor: Colors.transparent),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              // Top Row
              Row(
                children: [
                  Expanded(
                    child: GlassCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text('Carbon Grade', style: TextStyle(color: Colors.white70)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(wallet.currentGrade, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, color: Colors.white38, size: 16),
                              const SizedBox(width: 8),
                              Text(wallet.nextGrade, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white38)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GlassCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text('Health Score', style: TextStyle(color: Colors.white70)),
                          const SizedBox(height: 8),
                          Text('${result.healthScore}/100', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Hero Wallet Card
              GlassCard(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    const Text('Green Credits Balance', style: TextStyle(color: Colors.white70, fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(
                      '${wallet.currentCredits.withCommas} Credits',
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.bolt, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${wallet.potentialCredits.fold(0, (sum, item) => sum + (item['credits'] as int))} Potential Credits',
                          style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Footprint
              GlassCard(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Annual Footprint', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('${result.totalFootprint.toStringAsFixed(1)} tCO₂e', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Best Next Action
              if (result.recommendations.isNotEmpty)
                GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Best Next Action', style: TextStyle(fontSize: 14, color: Colors.amber, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.bolt, color: Colors.amber, size: 24),
                          const SizedBox(width: 12),
                          Expanded(child: Text(result.recommendations.first.action, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text('+${(result.recommendations.first.impact * 2).toStringAsFixed(0)} Potential Credits', style: const TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              const SizedBox(height: 24),

              ValueListenableBuilder<Map<String, dynamic>?>(
                valueListenable: AppState.aiInsightsNotifier,
                builder: (context, insights, child) {
                  return CarbonLensInsightCard(
                    title: 'Carbon Health Analyst',
                    icon: Icons.health_and_safety,
                    insightText: insights?['health_analyst'],
                    isGenerating: insights == null,
                  );
                },
              ),
              const SizedBox(height: 32),

              const Text('Quick Actions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              
              _buildActionCard(context, 'View Intelligence', 'Analyze your emissions & leaks', Icons.analytics, 1),
              const SizedBox(height: 12),
              _buildActionCard(context, 'View Future', 'Forecast & Wallet details', Icons.timeline, 2),
              const SizedBox(height: 12),
              _buildActionCard(context, 'View Action Center', 'Optimize your lifestyle', Icons.bolt, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, String subtitle, IconData icon, int tabIndex) {
    return InkWell(
      onTap: () {
        final shell = StatefulNavigationShell.maybeOf(context);
        if (shell != null) {
          shell.goBranch(tabIndex, initialLocation: true);
        }
      },
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(icon, color: Colors.greenAccent),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 16),
          ],
        ),
      ),
    );
  }
}
