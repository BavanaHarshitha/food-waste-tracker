import 'package:flutter/material.dart';

import '../models/food_model.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';

import 'add_food_screen.dart';
import 'inventory_screen.dart';
import 'waste_screen.dart';
import 'record_waste_screen.dart';
import 'statistics_screen.dart';
import 'notifications_screen.dart';
import 'tips_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
final DatabaseService databaseService = DatabaseService();

int totalFoodItems = 0;
int expiringSoonCount = 0;
double foodWasted = 0;
double foodSaved = 0;

List<FoodItem> expiringSoonFoods = [];
  final List<String> pageTitles = [
    'Food Wastage Tracker',
    'Inventory',
    'Waste',
    'Statistics',
  ];
  @override
void initState() {
  super.initState();
  loadHomeStatistics();
}

Future<void> loadHomeStatistics() async {
  final int items = await databaseService.getTotalFoodItems();
  final int expiring = await databaseService.getExpiringSoonCount();
  final double wasted = await databaseService.getTotalFoodWasted();
  final double saved = await databaseService.getCurrentFoodQuantity();

  final List<FoodItem> expiringFoods =
      await databaseService.getExpiringSoonFoods();

await NotificationService.checkExpiryNotifications(
  expiringFoods,
);

  if (!mounted) return;

  setState(() {
    totalFoodItems = items;
    expiringSoonCount = expiring;
    foodWasted = wasted;
    foodSaved = saved;
    expiringSoonFoods = expiringFoods;
  });
}

  // -------------------------------------------------------
  // OPEN ADD FOOD SCREEN
  // -------------------------------------------------------

  Future<void> openAddFoodScreen() async {
    await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const AddFoodScreen(),
  ),
);

setState(() {});
    // Refresh Home after returning from Add Food.
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData pageTheme =
        AppTheme.tabTheme(Theme.of(context), selectedIndex);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: pageTheme.colorScheme.primary,
        foregroundColor: pageTheme.colorScheme.onPrimary,
        title: Text(pageTitles[selectedIndex]),
        actions: [
  IconButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const NotificationsScreen(),
        ),
      );
    },
    icon: const Icon(
      Icons.notifications_outlined,
    ),
  ),

  IconButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
         builder: (context) => SettingsScreen(
  themeMode: widget.themeMode,
  onThemeChanged: widget.onThemeChanged,
),
        ),
      );
    },
    icon: const Icon(
      Icons.settings_outlined,
    ),
  ),
],
      ),

      
          
      body: Theme(
        data: pageTheme,
        child: selectedIndex == 0
            ? buildHomePage()
            : selectedIndex == 1
                ? const InventoryScreen()
                : selectedIndex == 2
                    ? const WasteScreen()
                    : const StatisticsScreen(),
      ),

      // ---------------------------------------------------
      // ADD FOOD BUTTON
      // ---------------------------------------------------

      floatingActionButton: selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: openAddFoodScreen,
              icon: const Icon(Icons.add),
              label: const Text('Add Food'),
              backgroundColor: pageTheme.colorScheme.primary,
              foregroundColor: pageTheme.colorScheme.onPrimary,
            )
          : null,

      // ---------------------------------------------------
      // BOTTOM NAVIGATION
      // ---------------------------------------------------

      bottomNavigationBar: Theme(
        data: pageTheme,
        child: NavigationBar(
        selectedIndex: selectedIndex,

        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),

          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Inventory',
          ),

          NavigationDestination(
            icon: Icon(Icons.delete_outline),
            selectedIcon: Icon(Icons.delete),
            label: 'Waste',
          ),

          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
        ],
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // HOME PAGE
  // -------------------------------------------------------

  Widget buildHomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hello! 👋',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Let\'s reduce food waste today.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 24),

        const Text(
  'Food Summary',
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 12),

Row(
  children: [
    Expanded(
      child: buildStatisticCard(
        icon: Icons.restaurant,
        title: 'Food Items',
        value: totalFoodItems.toString(),
      ),
    ),

    const SizedBox(width: 12),

    Expanded(
      child: buildStatisticCard(
        icon: Icons.warning_amber,
        title: 'Expiring Soon',
        value: expiringSoonCount.toString(),
      ),
    ),
  ],
),

const SizedBox(height: 12),

Row(
  children: [
    Expanded(
      child: buildStatisticCard(
        icon: Icons.delete_outline,
        title: 'Food Wasted',
        value: '${foodWasted.toStringAsFixed(2)} kg',
      ),
    ),

    const SizedBox(width: 12),

    Expanded(
      child: buildStatisticCard(
        icon: Icons.eco,
        title: 'Food Saved',
        value: '${foodSaved.toStringAsFixed(2)} kg',
      ),
    ),
  ],
),

          const SizedBox(height: 28),

          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: buildActionCard(
                  icon: Icons.add_circle_outline,
                  title: 'Add Food',
                  onTap: openAddFoodScreen,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: buildActionCard(
                  icon: Icons.delete_sweep_outlined,
                  title: 'Record Waste',
                 onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const RecordWasteScreen(),
    ),
  );
},
                ),
              ),
            ],
          ),
const SizedBox(height: 12),

buildActionCard(
  icon: Icons.eco_outlined,
  title: 'Food Waste Tips',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TipsScreen(),
      ),
    );
  },
),
          const SizedBox(height: 28),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Expiring Soon',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              TextButton(
                onPressed: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                },
                child: const Text('View All'),
              ),
            ],
          ),

          const SizedBox(height: 8),

         if (expiringSoonFoods.isEmpty)
  const Padding(
    padding: EdgeInsets.all(16),
    child: Text(
      'No food items are expiring soon.',
      textAlign: TextAlign.center,
    ),
  )
else
  ...expiringSoonFoods.map(
    (food) => buildExpiringFoodCard(
      name: food.name,
      quantity: '${food.quantity} ${food.unit}',
      expiry: food.daysRemaining == 0
          ? 'Expires today'
          : food.daysRemaining == 1
              ? 'Expires tomorrow'
              : 'Expires in ${food.daysRemaining} days',
      icon: Icons.fastfood,
    ),
  ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // -------------------------------------------------------
  // STATISTIC CARD
  // -------------------------------------------------------

  Widget buildStatisticCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            Icon(
              icon,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),

            const SizedBox(height: 10),

            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // ACTION CARD
  // -------------------------------------------------------

  Widget buildActionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,

        borderRadius:
            BorderRadius.circular(12),

        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 10,
          ),

          child: Column(
            children: [
              Icon(
                icon,
                size: 35,
                color: Theme.of(context).colorScheme.primary,
              ),

              const SizedBox(height: 8),

              Text(
                title,
                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // EXPIRING FOOD CARD
  // -------------------------------------------------------

  Widget buildExpiringFoodCard({
    required IconData icon,
    required String name,
    required String quantity,
    required String expiry,
  }) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              Theme.of(context).colorScheme.primaryContainer,

          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),

        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Text(quantity),

        trailing: Text(
          expiry,
          style: const TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // PLACEHOLDER
  // -------------------------------------------------------

  Widget buildPlaceholderPage() {
    return Center(
      child: Text(
        '${pageTitles[selectedIndex]} screen coming soon',
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}