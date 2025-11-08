import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '/utils/localization.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(localizations!.statisticsPageTitle),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    localizations.statisticsSummaryCompleted,
                    '12',
                    Colors.green,
                    Icons.check_circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    localizations.statisticsSummaryInProgress,
                    '5',
                    Colors.orange,
                    Icons.access_time,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    localizations.statisticsSummaryOverdue,
                    '2',
                    Colors.red,
                    Icons.error,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Weekly Progress
            _buildSectionCard(
              title: localizations.statisticsWeeklyProgress,
              child: Container(
                height: 200,
                padding: const EdgeInsets.all(16),
                child: BarChart(
                  BarChartData(
                    barTouchData: BarTouchData(
                      enabled: false,
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final days = [
                              localizations.statisticsDaysMon,
                              localizations.statisticsDaysTue,
                              localizations.statisticsDaysWed,
                              localizations.statisticsDaysThu,
                              localizations.statisticsDaysFri,
                              localizations.statisticsDaysSat,
                              localizations.statisticsDaysSun,
                            ];
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                days[value.toInt()],
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: 5,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: 8,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(
                            toY: 12,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 3,
                        barRods: [
                          BarChartRodData(
                            toY: 6,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 4,
                        barRods: [
                          BarChartRodData(
                            toY: 15,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 5,
                        barRods: [
                          BarChartRodData(
                            toY: 10,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 6,
                        barRods: [
                          BarChartRodData(
                            toY: 4,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Task Distribution
            _buildSectionCard(
              title: localizations.statisticsTaskDistribution,
              child: Container(
                height: 200,
                padding: const EdgeInsets.all(16),
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: 35,
                        color: Colors.blue,
                        title: '35%',
                        radius: 50,
                      ),
                      PieChartSectionData(
                        value: 25,
                        color: Colors.green,
                        title: '25%',
                        radius: 50,
                      ),
                      PieChartSectionData(
                        value: 20,
                        color: Colors.orange,
                        title: '20%',
                        radius: 50,
                      ),
                      PieChartSectionData(
                        value: 20,
                        color: Colors.purple,
                        title: '20%',
                        radius: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Productivity Trends
            _buildSectionCard(
              title: localizations.statisticsProductivityTrends,
              child: Container(
                height: 200,
                padding: const EdgeInsets.all(16),
                child: LineChart(
                  LineChartData(
                    lineTouchData: LineTouchData(
                      enabled: false,
                    ),
                    gridData: FlGridData(
                      show: false,
                    ),
                    titlesData: FlTitlesData(
                      show: false,
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          FlSpot(0, 12),
                          FlSpot(1, 18),
                          FlSpot(2, 15),
                          FlSpot(3, 22),
                        ],
                        isCurved: true,
                        color: Colors.green,
                        barWidth: 4,
                        belowBarData: BarAreaData(
                          show: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}