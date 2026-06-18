import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'glass_card.dart';

class ForecastChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> forecast;

  const ForecastChartWidget({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
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
}
