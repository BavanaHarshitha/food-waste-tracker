import 'package:flutter/material.dart';

import '../models/food_model.dart';
import '../services/database_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends State<NotificationsScreen> {
  final DatabaseService databaseService = DatabaseService();

  List<FoodItem> notificationFoods = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      final List<FoodItem> foods =
          await databaseService.getExpiringSoonFoods();

      if (!mounted) return;

      setState(() {
        notificationFoods = foods;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to load notifications: $e',
          ),
        ),
      );
    }
  }

  String getExpiryMessage(FoodItem food) {
    if (food.daysRemaining == 0) {
      return 'Expires today. Please use it soon.';
    }

    if (food.daysRemaining == 1) {
      return 'Expires tomorrow. Please use it soon.';
    }

    return 'Expires in ${food.daysRemaining} days. Please use it soon.';
  }

  Color getExpiryColor(FoodItem food) {
    if (food.daysRemaining == 0) {
      return Colors.red;
    }

    if (food.daysRemaining <= 2) {
      return Colors.orange;
    }

    return Colors.amber;
  }

  IconData getExpiryIcon(FoodItem food) {
    if (food.daysRemaining == 0) {
      return Icons.warning_rounded;
    }

    return Icons.notifications_active;
  }

  Widget buildNotificationCard(FoodItem food) {
    final Color color = getExpiryColor(food);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(
            getExpiryIcon(food),
            color: color,
          ),
        ),
        title: Text(
          food.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            getExpiryMessage(food),
          ),
        ),
        trailing: Text(
          '${food.quantity} ${food.unit}',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: loadNotifications,
              child: notificationFoods.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 180),
                        Icon(
                          Icons.notifications_none,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            'No new notifications',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Center(
                          child: Text(
                            'No food items are expiring soon.',
                          ),
                        ),
                      ],
                    )
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        const Text(
                          'Food Expiry Notifications',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Food items that are expiring within 3 days',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 20),

                        ...notificationFoods.map(
                          buildNotificationCard,
                        ),
                      ],
                    ),
            ),
    );
  }
}