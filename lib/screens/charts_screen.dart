import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../services/database_service.dart';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({super.key});

  @override
  State<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  final DatabaseService databaseService = DatabaseService();

  List<Map<String, dynamic>> wasteByReason = [];
  List<Map<String, dynamic>> wasteByCategory = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadChartData();
  }

  Future<void> loadChartData() async {
    try {
      final reasons = await databaseService.getWasteByReason();
      final categories = await databaseService.getWasteByCategory();

      if (!mounted) return;

      setState(() {
        wasteByReason = reasons;
        wasteByCategory = categories;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to load chart data: $e'),
        ),
      );
    }
  }

  Widget buildBarChart(
    List<Map<String, dynamic>> data,
    String title,
  ) {
    if (data.isEmpty) {
      return const Center(
        child: Text(
          'No waste data available',
          style: TextStyle(fontSize: 15),
        ),
      );
    }

    final double maxValue = data
        .map(
          (item) => (item['total'] as num).toDouble(),
        )
        .reduce((a, b) => a > b ? a : b);

    return Column(
      children: [
        SizedBox(
          height: 280,
          child: BarChart(
            BarChartData(
              maxY: maxValue == 0 ? 1 : maxValue * 1.3,
              alignment: BarChartAlignment.spaceAround,
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: true),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 55,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();

                      if (index < 0 || index >= data.length) {
                        return const SizedBox.shrink();
                      }

                      final String label =
                          data[index].keys.first == 'reason'
                              ? data[index]['reason'].toString()
                              : data[index]['category'].toString();

                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          label,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barGroups: List.generate(
                data.length,
                (index) {
                  final double total =
                      (data[index]['total'] as num).toDouble();

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: total,
                        width: 25,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildChartCard({
    required String title,
    required IconData icon,
    required Widget chart,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 26,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            chart,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waste Charts'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: loadChartData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Waste Analysis',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Visual analysis of your food waste',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),

                  buildChartCard(
                    title: 'Waste by Reason',
                    icon: Icons.warning_amber_rounded,
                    chart: buildBarChart(
                      wasteByReason,
                      'Waste by Reason',
                    ),
                  ),

                  buildChartCard(
                    title: 'Waste by Category',
                    icon: Icons.category_outlined,
                    chart: buildBarChart(
                      wasteByCategory,
                      'Waste by Category',
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}