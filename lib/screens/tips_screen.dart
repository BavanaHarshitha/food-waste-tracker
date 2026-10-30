import 'package:flutter/material.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  final List<Map<String, dynamic>> tips = const [
    {
      'title': 'Buy Only What You Need',
      'description':
          'Plan your meals and purchase only the amount of food you are likely to use.',
      'icon': Icons.shopping_cart_outlined,
    },
    {
      'title': 'Check Expiry Dates',
      'description':
          'Regularly check expiry dates and use food that is going to expire first.',
      'icon': Icons.calendar_month_outlined,
    },
    {
      'title': 'Store Food Properly',
      'description':
          'Keep food in the correct storage location such as the refrigerator, freezer, or kitchen shelf.',
      'icon': Icons.kitchen_outlined,
    },
    {
      'title': 'Use Older Food First',
      'description':
          'Follow the first-in, first-out method so older food is consumed before newer food.',
      'icon': Icons.sync_alt,
    },
    {
      'title': 'Store Leftovers Safely',
      'description':
          'Keep leftover food in clean, covered containers and refrigerate it when required.',
      'icon': Icons.inventory_2_outlined,
    },
    {
      'title': 'Maintain Your Inventory',
      'description':
          'Keep your food inventory updated so you know what food you already have at home.',
      'icon': Icons.list_alt_outlined,
    },
    {
      'title': 'Reuse Safe Leftovers',
      'description':
          'Use safe leftover food creatively in another meal instead of throwing it away.',
      'icon': Icons.restaurant_outlined,
    },
    {
      'title': 'Save Money by Reducing Waste',
      'description':
          'Reducing food waste also helps reduce unnecessary spending on food.',
      'icon': Icons.savings_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Waste Tips'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    Icons.eco_outlined,
                    size: 60,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Reduce Food Waste',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Small changes in the way we buy, store, and use food '
                    'can help reduce food waste and save money.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Useful Tips',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          ...tips.map(
            (tip) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.12),
                  child: Icon(
                    tip['icon'] as IconData,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                title: Text(
                  tip['title'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    tip['description'] as String,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(
                    Icons.favorite_outline,
                    size: 40,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Every Meal Matters',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Use your Food Wastage Tracker regularly to '
                    'build better food management habits.',
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
        ],
      ),
    );
  }
}