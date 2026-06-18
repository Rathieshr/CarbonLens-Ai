import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/primary_button.dart';
import '../widgets/glass_card.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 64.0),
            children: [
              // Hero Section
              const Icon(Icons.lens_blur, size: 64, color: Colors.greenAccent),
              const SizedBox(height: 24),
              const Text(
                'CarbonLens AI',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Personal Carbon Intelligence Platform',
                style: TextStyle(fontSize: 18, color: Colors.greenAccent, letterSpacing: 1.2),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Tri-value proposition
              const Text(
                'Detect. Predict. Earn.',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(child: _buildValueCard(Icons.radar, 'Detect', 'Identify hidden carbon leaks.', Colors.redAccent)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildValueCard(Icons.timeline, 'Predict', 'Forecast your future carbon impact.', Colors.blueAccent)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildValueCard(Icons.workspace_premium, 'Earn', 'Accumulate Carbon Credits.', Colors.amber)),
                ],
              ),
              const SizedBox(height: 64),

              // Journey
              const Text('The Journey', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              _buildJourneyFlow(),
              
              const SizedBox(height: 64),
              PrimaryButton(
                text: 'Start Assessment',
                icon: Icons.rocket_launch,
                onPressed: () => context.go('/profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValueCard(IconData icon, String title, String subtitle, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(icon, color: color, size: 36),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildJourneyFlow() {
    return Column(
      children: [
        _buildJourneyStep('Carbon Intelligence'),
        const Icon(Icons.arrow_downward, color: Colors.white24, size: 20),
        _buildJourneyStep('Future Forecast'),
        const Icon(Icons.arrow_downward, color: Colors.white24, size: 20),
        _buildJourneyStep('Carbon Credits'),
        const Icon(Icons.arrow_downward, color: Colors.white24, size: 20),
        _buildJourneyStep('Impact Center'),
        const Icon(Icons.arrow_downward, color: Colors.white24, size: 20),
        _buildJourneyStep('Ask CarbonLens'),
      ],
    );
  }

  Widget _buildJourneyStep(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(text, style: const TextStyle(color: Colors.greenAccent, fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}
