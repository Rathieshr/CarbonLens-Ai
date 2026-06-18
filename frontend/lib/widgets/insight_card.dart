import 'package:flutter/material.dart';
import 'glass_card.dart';

class CarbonLensInsightCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? insightText;
  final String? category;
  final bool isGenerating;

  const CarbonLensInsightCard({
    super.key,
    required this.title,
    required this.icon,
    this.insightText,
    this.category,
    this.isGenerating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.greenAccent.withValues(alpha: 0.15),
            blurRadius: 20,
            spreadRadius: -5,
          ),
        ],
      ),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.greenAccent, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.greenAccent),
                  ),
                ),
                if (category != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      category!.toUpperCase(),
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white70),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (isGenerating)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Generating personalized insight...', style: TextStyle(color: Colors.greenAccent, fontSize: 14)),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(backgroundColor: Colors.white.withValues(alpha: 0.1), color: Colors.greenAccent),
                ],
              )
            else if (insightText != null && insightText!.isNotEmpty)
              Text(
                insightText!,
                style: const TextStyle(color: Colors.white, height: 1.5, fontSize: 15),
              )
            else
              const Text(
                'Data analysis complete. No specific insight available.',
                style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic),
              ),
          ],
        ),
      ),
    );
  }
}
