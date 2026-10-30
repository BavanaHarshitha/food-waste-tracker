
import 'package:flutter/material.dart';

import '../models/food_model.dart';
import '../services/database_service.dart';
import 'food_details_screen.dart';
import 'edit_food_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final TextEditingController searchController =
      TextEditingController();

  String selectedFilter = 'All';

  final DatabaseService databaseService =
      DatabaseService();

  List<FoodItem> foodItems = [];

  // -------------------------------------------------------
  // INITIALIZE
  // -------------------------------------------------------

  @override
  void initState() {
    super.initState();

    loadFoodItems();
  }

  // -------------------------------------------------------
  // LOAD FOOD FROM SQLITE
  // -------------------------------------------------------

  Future<void> loadFoodItems() async {
    try {
      final List<FoodItem> items =
          await databaseService.getFoodItems();

      if (!mounted) return;

      setState(() {
        foodItems = items;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error loading food items: $e',
          ),
        ),
      );
    }
  }

  // -------------------------------------------------------
  // FILTERED FOOD LIST
  // -------------------------------------------------------

  List<FoodItem> get filteredFoodItems {
    List<FoodItem> result =
        List<FoodItem>.from(foodItems);

    final String searchText =
        searchController.text.toLowerCase().trim();

    // Search
    if (searchText.isNotEmpty) {
      result = result.where((food) {
        return food.name
                .toLowerCase()
                .contains(searchText) ||
            food.category
                .toLowerCase()
                .contains(searchText);
      }).toList();
    }

    // Fresh
    if (selectedFilter == 'Fresh') {
      result = result.where((food) {
        return food.expiryStatus == 'Fresh';
      }).toList();
    }

    // Expiring
    if (selectedFilter == 'Expiring') {
      result = result.where((food) {
        return food.expiryStatus == 'Expiring Soon' ||
            food.expiryStatus == 'Expires Today';
      }).toList();
    }

    // Expired
    if (selectedFilter == 'Expired') {
      result = result.where((food) {
        return food.expiryStatus == 'Expired';
      }).toList();
    }

    return result;
  }

  // -------------------------------------------------------
  // EXPIRY COLOR
  // -------------------------------------------------------

  Color getExpiryColor(FoodItem food) {
    if (food.expiryStatus == 'Expired') {
      return Colors.red;
    }

    if (food.expiryStatus == 'Expires Today') {
      return Colors.red;
    }

    if (food.expiryStatus == 'Expiring Soon') {
      return Colors.orange;
    }

    return Colors.green;
  }

  // -------------------------------------------------------
  // EXPIRY TEXT
  // -------------------------------------------------------

  String getExpiryText(FoodItem food) {
    if (food.daysRemaining < 0) {
      return 'Expired';
    }

    if (food.daysRemaining == 0) {
      return 'Expires today';
    }

    if (food.daysRemaining == 1) {
      return 'Expires tomorrow';
    }

    return 'Expires in ${food.daysRemaining} days';
  }

  // -------------------------------------------------------
  // FOOD ICON
  // -------------------------------------------------------

  IconData getFoodIcon(String category) {
    switch (category) {
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
  // EDIT FOOD
  // -------------------------------------------------------

  Future<void> editFood(FoodItem food) async {
    final FoodItem? updatedFood =
        await Navigator.push<FoodItem>(
      context,
      MaterialPageRoute(
        builder: (_) => EditFoodScreen(
          food: food,
        ),
      ),
    );

    if (!mounted || updatedFood == null) {
      return;
    }

    try {
      await databaseService.updateFood(updatedFood);

      if (!mounted) return;

      await loadFoodItems();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${updatedFood.name} updated successfully!',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error updating food: $e',
          ),
        ),
      );
    }
  }

  // -------------------------------------------------------
  // DELETE CONFIRMATION
  // -------------------------------------------------------

  void showDeleteDialog(FoodItem food) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Food?'),
          content: Text(
            'Are you sure you want to delete ${food.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                deleteFood(food);
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // -------------------------------------------------------
  // DELETE FOOD FROM SQLITE
  // -------------------------------------------------------

  Future<void> deleteFood(FoodItem food) async {
    try {
      await databaseService.deleteFood(food.id);

      if (!mounted) return;

      await loadFoodItems();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${food.name} deleted successfully!',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error deleting food: $e',
          ),
        ),
      );
    }
  }

  // -------------------------------------------------------
  // BUILD
  // -------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        appBar: AppBar(
          title: const Text('Inventory'),
        ),

      body: Column(
        children: [
          // -------------------------------------------------
          // SEARCH BAR
          // -------------------------------------------------

          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Search food...',
                prefixIcon: const Icon(
                  Icons.search,
                ),
                suffixIcon:
                    searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              searchController.clear();

                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.clear,
                            ),
                          )
                        : null,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // -------------------------------------------------
          // FILTERS
          // -------------------------------------------------

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Row(
              children: [
                buildFilterButton('All'),
                buildFilterButton('Fresh'),
                buildFilterButton('Expiring'),
                buildFilterButton('Expired'),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // -------------------------------------------------
          // FOOD LIST
          // -------------------------------------------------

          Expanded(
            child: filteredFoodItems.isEmpty
                ? buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount:
                        filteredFoodItems.length,
                    itemBuilder:
                        (context, index) {
                      final FoodItem food =
                          filteredFoodItems[index];

                      return buildFoodCard(food);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------
  // FILTER BUTTON
  // -------------------------------------------------------

  Widget buildFilterButton(String filter) {
    final bool isSelected =
        selectedFilter == filter;

    return Padding(
      padding:
          const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(filter),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            selectedFilter = filter;
          });
        },
      ),
    );
  }

  // -------------------------------------------------------
  // FOOD CARD
  // -------------------------------------------------------

  Widget buildFoodCard(FoodItem food) {
  final Color expiryColor = getExpiryColor(food);

  return Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: ListTile(
      contentPadding: const EdgeInsets.all(12),

      // -------------------------------------------------
      // OPEN FOOD DETAILS
      // -------------------------------------------------

      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodDetailsScreen(
              food: food,
            ),
          ),
        );

        if (!mounted) return;

        await loadFoodItems();
      },

      // -------------------------------------------------
      // FOOD ICON
      // -------------------------------------------------

      leading: CircleAvatar(
        radius: 26,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Icon(
          getFoodIcon(food.category),
          color: Theme.of(context).colorScheme.primary,
          size: 28,
        ),
      ),

      // -------------------------------------------------
      // FOOD NAME
      // -------------------------------------------------

      title: Text(
        food.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),

      // -------------------------------------------------
      // FOOD DETAILS + EXPIRY INFORMATION
      // -------------------------------------------------

      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 4),

          Text(
            '${food.quantity} ${food.unit}',
          ),

          Text(
            food.category,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),

          Text(
            food.storageLocation,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 4),

          // Expiry status
          Text(
            food.expiryStatus,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: expiryColor,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),

          // Expiry days
          Text(
            getExpiryText(food),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: expiryColor,
              fontSize: 10,
            ),
          ),
        ],
      ),

      // -------------------------------------------------
      // EDIT + DELETE BUTTONS
      // -------------------------------------------------

      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Edit button
          IconButton(
            tooltip: 'Edit Food',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
            icon: Icon(
              Icons.edit_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 21,
            ),
            onPressed: () {
              editFood(food);
            },
          ),

          // Delete button
          IconButton(
            tooltip: 'Delete Food',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.red,
              size: 21,
            ),
            onPressed: () {
              showDeleteDialog(food);
            },
          ),
        ],
      ),
    ),
  );
}

// -------------------------------------------------------
// EMPTY STATE
// -------------------------------------------------------

Widget buildEmptyState() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.inventory_2_outlined,
          size: 70,
          color: Colors.grey.shade400,
        ),

        const SizedBox(height: 15),

        const Text(
          'No food items found',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Try another search or filter.',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    ),
  );
}

// -------------------------------------------------------
// DISPOSE
// -------------------------------------------------------

@override
void dispose() {
  searchController.dispose();

  super.dispose();
}
}