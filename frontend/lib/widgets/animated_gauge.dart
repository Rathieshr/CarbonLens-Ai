import 'package:flutter/material.dart';

class AnimatedGauge extends StatelessWidget {
  final int score;
  final String grade;

  const AnimatedGauge({
    super.key,
    required this.score,
    required this.grade,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: score / 100.0),
      duration: const Duration(seconds: 2),
      curve: Curves.easeOutCubic,
      builder: (context, double value, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(
                value: value,
                strokeWidth: 16,
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(_getColor(score)),
                strokeCap: StrokeCap.round,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  grade,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: _getColor(score),
                    shadows: [
                      Shadow(
                        color: _getColor(score).withValues(alpha: 0.5),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                ),
                Text(
                  '$score/100',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Color _getColor(int score) {
    if (score >= 80) return const Color(0xFF10B981); // Emerald
    if (score >= 60) return const Color(0xFFF59E0B); // Amber
    return const Color(0xFFEF4444); // Red
  }
}
