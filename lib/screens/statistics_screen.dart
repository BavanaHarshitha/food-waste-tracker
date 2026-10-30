import 'package:flutter/material.dart';

import '../services/database_service.dart';
import 'charts_screen.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final DatabaseService databaseService = DatabaseService();

  int totalFoodItems = 0;
  double totalFoodQuantity = 0;
  double totalFoodWasted = 0;
  double totalMoneyWasted = 0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStatistics();
  }

  Future<void> loadStatistics() async {
    try {
      final int foodItems =
          await databaseService.getTotalFoodItems();

      final double foodQuantity =
          await databaseService.getTotalFoodQuantity();

      final double foodWasted =
          await databaseService.getTotalFoodWasted();

      final double moneyWasted =
          await databaseService.getTotalMoneyWasted();

      if (!mounted) return;

      setState(() {
        totalFoodItems = foodItems;
        totalFoodQuantity = foodQuantity;
        totalFoodWasted = foodWasted;
        totalMoneyWasted = moneyWasted;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to load statistics: $e'),
        ),
      );
    }
  }

  Widget buildStatisticCard({
    required String title,
    required String value,
    required IconData icon,
    required String subtitle,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                size: 30,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: loadStatistics,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Food Statistics',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Your food inventory and waste summary',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 24),

                  buildStatisticCard(
                    title: 'Total Food Items',
                    value: totalFoodItems.toString(),
                    icon: Icons.inventory_2,
                    subtitle: 'Items currently in inventory',
                  ),

                  buildStatisticCard(
                    title: 'Food Quantity',
                    value: totalFoodQuantity.toStringAsFixed(2),
                    icon: Icons.restaurant,
                    subtitle: 'Total quantity in inventory',
                  ),

                  buildStatisticCard(
                    title: 'Food Wasted',
                    value: totalFoodWasted.toStringAsFixed(2),
                    icon: Icons.delete_outline,
                    subtitle: 'Total quantity wasted',
                  ),

                  buildStatisticCard(
                    title: 'Money Wasted',
                    value:
                        '₹${totalMoneyWasted.toStringAsFixed(2)}',
                    icon: Icons.currency_rupee,
                    subtitle: 'Money lost due to food waste',
                  ),

                  const SizedBox(height: 10),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.insights,
                            size: 45,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Waste Management',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Keep tracking your food waste to reduce '
                            'food loss and save money.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ChartsScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.bar_chart),
                      label: const Text(
                        'View Waste Charts',
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}