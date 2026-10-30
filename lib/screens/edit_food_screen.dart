
import 'package:flutter/material.dart';
import '../models/food_model.dart';
import '../services/food_store.dart';



class EditFoodScreen extends StatefulWidget {
  final FoodItem food;

  const EditFoodScreen({
    super.key,
    required this.food,
  });

  @override
  State<EditFoodScreen> createState() => _EditFoodScreenState();
}

class _EditFoodScreenState extends State<EditFoodScreen> {
  late TextEditingController foodNameController;
  late TextEditingController quantityController;
  late TextEditingController priceController;

  late String selectedCategory;
  late String selectedUnit;
  late String selectedStorage;

  late DateTime purchaseDate;
  late DateTime expiryDate;

  final List<String> categories = [
    'Dairy',
    'Fruits',
    'Vegetables',
    'Grains',
    'Bakery',
    'Meat',
    'Beverages',
    'Other',
  ];

  final List<String> units = [
    'Pieces',
    'Kg',
    'Grams',
    'Litres',
    'Millilitres',
    'Packets',
  ];

  final List<String> storageLocations = [
    'Refrigerator',
    'Freezer',
    'Kitchen Shelf',
    'Pantry',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    foodNameController =
        TextEditingController(text: widget.food.name);

    quantityController =
        TextEditingController(
      text: widget.food.quantity.toString(),
    );

    priceController =
        TextEditingController(
      text: widget.food.price.toString(),
    );

    selectedCategory = widget.food.category;
    selectedUnit = widget.food.unit;
    selectedStorage = widget.food.storageLocation;

    purchaseDate = widget.food.purchaseDate;
    expiryDate = widget.food.expiryDate;
  }

  Future<void> selectPurchaseDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: purchaseDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        purchaseDate = selectedDate;

        if (expiryDate.isBefore(purchaseDate)) {
          expiryDate = purchaseDate;
        }
      });
    }
  }

  Future<void> selectExpiryDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: expiryDate,
      firstDate: purchaseDate,
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        expiryDate = selectedDate;
      });
    }
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

void saveChanges() {
  final String name = foodNameController.text.trim();
  final String quantityText = quantityController.text.trim();
  final String priceText = priceController.text.trim();

  if (name.isEmpty) {
    showMessage('Please enter food name');
    return;
  }

  if (quantityText.isEmpty) {
    showMessage('Please enter quantity');
    return;
  }

  if (priceText.isEmpty) {
    showMessage('Please enter price');
    return;
  }

  final double? quantity = double.tryParse(quantityText);
  final double? price = double.tryParse(priceText);

  if (quantity == null || quantity <= 0) {
    showMessage('Please enter a valid quantity');
    return;
  }

  if (price == null || price < 0) {
    showMessage('Please enter a valid price');
    return;
  }

  // Create the updated food item
  final FoodItem updatedFood = FoodItem(
    id: widget.food.id,
    name: name,
    category: selectedCategory,
    quantity: quantity,
    unit: selectedUnit,
    purchaseDate: purchaseDate,
    expiryDate: expiryDate,
    price: price,
    storageLocation: selectedStorage,
  );

  // IMPORTANT:
  // Update the actual common FoodStore
  final FoodStore foodStore = FoodStore();
  foodStore.updateFood(updatedFood);

  // Return the updated item to InventoryScreen
  Navigator.pop(
    context,
    updatedFood,
  );
}


  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Food'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            const Text(
              'Edit Food Item',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Update the food information below.',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            // Food Name
            TextField(
              controller: foodNameController,

              textCapitalization:
                  TextCapitalization.words,

              decoration: const InputDecoration(
                labelText: 'Food Name',
                prefixIcon: Icon(
                  Icons.restaurant_outlined,
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Category
            DropdownButtonFormField<String>(
              initialValue: selectedCategory,

              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(
                  Icons.category_outlined,
                ),
              ),

              items: categories.map(
                (category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                },
              ).toList(),

              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedCategory = value;
                  });
                }
              },
            ),

            const SizedBox(height: 18),

            // Quantity + Unit
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller:
                        quantityController,

                    keyboardType:
                        const TextInputType
                            .numberWithOptions(
                      decimal: true,
                    ),

                    decoration:
                        const InputDecoration(
                      labelText: 'Quantity',
                      prefixIcon: Icon(
                        Icons.numbers,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child:
                      DropdownButtonFormField<String>(
                    initialValue: selectedUnit,

                    decoration:
                        const InputDecoration(
                      labelText: 'Unit',
                    ),

                    items: units.map(
                      (unit) {
                        return DropdownMenuItem(
                          value: unit,
                          child: Text(unit),
                        );
                      },
                    ).toList(),

                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedUnit = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Purchase Date
            InkWell(
              onTap: selectPurchaseDate,

              child: InputDecorator(
                decoration:
                    const InputDecoration(
                  labelText: 'Purchase Date',
                  prefixIcon: Icon(
                    Icons.calendar_today_outlined,
                  ),
                ),

                child: Text(
                  formatDate(purchaseDate),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Expiry Date
            InkWell(
              onTap: selectExpiryDate,

              child: InputDecorator(
                decoration:
                    const InputDecoration(
                  labelText: 'Expiry Date',
                  prefixIcon: Icon(
                    Icons.event_busy_outlined,
                  ),
                ),

                child: Text(
                  formatDate(expiryDate),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Price
            TextField(
              controller: priceController,

              keyboardType:
                  const TextInputType
                      .numberWithOptions(
                decimal: true,
              ),

              decoration: const InputDecoration(
                labelText: 'Price',
                prefixIcon: Icon(
                  Icons.currency_rupee,
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Storage
            DropdownButtonFormField<String>(
              initialValue: selectedStorage,

              decoration: const InputDecoration(
                labelText: 'Storage Location',
                prefixIcon: Icon(
                  Icons.kitchen_outlined,
                ),
              ),

              items: storageLocations.map(
                (storage) {
                  return DropdownMenuItem(
                    value: storage,
                    child: Text(storage),
                  );
                },
              ).toList(),

              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedStorage = value;
                  });
                }
              },
            ),

            const SizedBox(height: 30),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 52,

              child: ElevatedButton.icon(
                onPressed: saveChanges,

                icon: const Icon(
                  Icons.save_outlined,
                ),

                label: const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    foodNameController.dispose();
    quantityController.dispose();
    priceController.dispose();

    super.dispose();
  }
}