import 'package:flutter/material.dart';

import '../models/food_model.dart';
import '../services/database_service.dart';
import 'edit_food_screen.dart';

class FoodDetailsScreen extends StatefulWidget {
  final FoodItem food;

  const FoodDetailsScreen({super.key, required this.food});

  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  late FoodItem currentFood;

  @override
  void initState() {
    super.initState();

    currentFood = widget.food;
  }

  // -------------------------------------------------------
  // EXPIRY TEXT
  // -------------------------------------------------------

  String getExpiryText() {
    if (currentFood.daysRemaining < 0) {
      return 'Expired';
    }

    if (currentFood.daysRemaining == 0) {
      return 'Expires today';
    }

    if (currentFood.daysRemaining == 1) {
      return 'Expires tomorrow';
    }

    return 'Expires in ${currentFood.daysRemaining} days';
  }

  // -------------------------------------------------------
  // EXPIRY COLOR
  // -------------------------------------------------------

  Color getExpiryColor() {
    if (currentFood.expiryStatus == 'Expired') {
      return Colors.red;
    }

    if (currentFood.expiryStatus == 'Expires Today') {
      return Colors.red;
    }

    if (currentFood.expiryStatus == 'Expiring Soon') {
      return Colors.orange;
    }

    return Colors.green;
  }

  // -------------------------------------------------------
  // FOOD ICON
  // -------------------------------------------------------

  IconData getFoodIcon() {
    switch (currentFood.category) {
      case 'Dairy':
        return Icons.local_drink;

      case 'Fruits':
        return Icons.apple;

      case 'Vegetables':
        return Icons.eco;

      case 'Bakery':
        return Icons.bakery_dining;

      case 'Grains':
        return Icons.rice_bowl;

      case 'Meat':
        return Icons.restaurant;

      case 'Beverages':
        return Icons.local_cafe;

      default:
        return Icons.fastfood;
    }
  }

  // -------------------------------------------------------
  // DATE FORMAT
  // -------------------------------------------------------

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // -------------------------------------------------------
  // BUILD
  // -------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final Color expiryColor = getExpiryColor();

    return PopScope<FoodItem>(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        // Inventory will reload the data from SQLite.
        // No extra action is required here.
      },

      child: Scaffold(
        appBar: AppBar(
          title: const Text('Food Details'),

          leading: IconButton(
            icon: const Icon(Icons.arrow_back),

            onPressed: () {
              Navigator.pop(context, currentFood);
            },
          ),
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              // ------------------------------------------------
              // FOOD ICON
              // ------------------------------------------------
              CircleAvatar(
                radius: 50,

                backgroundColor: Theme.of(context).colorScheme.primaryContainer,

                child: Icon(
                  getFoodIcon(),
                  size: 55,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              const SizedBox(height: 15),

              // ------------------------------------------------
              // FOOD NAME
              // ------------------------------------------------
              Text(
                currentFood.name,

                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              // ------------------------------------------------
              // CATEGORY
              // ------------------------------------------------
              Text(
                currentFood.category,

                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 25),

              // ------------------------------------------------
              // EXPIRY STATUS CARD
              // ------------------------------------------------
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: expiryColor.withAlpha(25),

                  borderRadius: BorderRadius.circular(15),

                  border: Border.all(color: expiryColor.withAlpha(100)),
                ),

                child: Row(
                  children: [
                    Icon(Icons.event, color: expiryColor),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const Text(
                            'Expiry Status',

                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            currentFood.expiryStatus,

                            style: TextStyle(
                              color: expiryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            getExpiryText(),

                            style: TextStyle(color: expiryColor, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ------------------------------------------------
              // FOOD INFORMATION
              // ------------------------------------------------
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),

                  child: Column(
                    children: [
                      buildInfoRow(
                        Icons.inventory_2_outlined,
                        'Quantity',
                        '${currentFood.quantity} '
                            '${currentFood.unit}',
                      ),

                      const Divider(),

                      buildInfoRow(
                        Icons.shopping_cart_outlined,
                        'Purchase Date',
                        formatDate(currentFood.purchaseDate),
                      ),

                      const Divider(),

                      buildInfoRow(
                        Icons.event_busy_outlined,
                        'Expiry Date',
                        formatDate(currentFood.expiryDate),
                      ),

                      const Divider(),

                      buildInfoRow(
                        Icons.currency_rupee,
                        'Price',
                        '₹${currentFood.price.toStringAsFixed(2)}',
                      ),

                      const Divider(),

                      buildInfoRow(
                        Icons.kitchen_outlined,
                        'Storage Location',
                        currentFood.storageLocation,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ------------------------------------------------
              // EDIT BUTTON
              // ------------------------------------------------
              SizedBox(
                width: double.infinity,
                height: 52,

                child: ElevatedButton.icon(
                  onPressed: editFood,

                  icon: const Icon(Icons.edit),

                  label: const Text(
                    'Edit Food',

                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ------------------------------------------------
              // DELETE BUTTON
              // ------------------------------------------------
              SizedBox(
                width: double.infinity,
                height: 52,

                child: OutlinedButton.icon(
                  onPressed: () {
                    showDeleteDialog(context);
                  },

                  icon: const Icon(Icons.delete_outline, color: Colors.red),

                  label: const Text(
                    'Delete Food',

                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // EDIT FOOD
  // -------------------------------------------------------

  Future<void> editFood() async {
    final FoodItem? updatedFood = await Navigator.push<FoodItem>(
      context,

      MaterialPageRoute(
        builder: (context) => EditFoodScreen(food: currentFood),
      ),
    );

    if (updatedFood == null) {
      return;
    }

    // Save updated food to SQLite
    await DatabaseService().updateFood(updatedFood);

    // Important: widget may have been removed
    // while SQLite update was running.
    if (!mounted) {
      return;
    }

    // Update the current screen
    setState(() {
      currentFood = updatedFood;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Food updated successfully!')));
  }

  // -------------------------------------------------------
  // INFORMATION ROW
  // -------------------------------------------------------

  Widget buildInfoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 25),

        const SizedBox(width: 15),

        Expanded(
          child: Text(title, style: const TextStyle(color: Colors.grey)),
        ),

        Flexible(
          child: Text(
            value,

            textAlign: TextAlign.right,

            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------
  // DELETE CONFIRMATION
  // -------------------------------------------------------

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Food?'),

          content: Text(
            'Are you sure you want to delete '
            '${currentFood.name}?',
          ),

          actions: [
            // Cancel
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },

              child: const Text('Cancel'),
            ),

            // Delete
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Delete from Inventory to remove this food.'),
                  ),
                );
              },

              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
