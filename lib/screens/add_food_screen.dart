import 'package:flutter/material.dart';

import '../models/food_model.dart';
import '../services/database_service.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  // -------------------------------------------------------
  // CONTROLLERS
  // -------------------------------------------------------

  final TextEditingController foodNameController =
      TextEditingController();

  final TextEditingController quantityController =
      TextEditingController();

  final TextEditingController priceController =
      TextEditingController();

  // -------------------------------------------------------
  // DEFAULT VALUES
  // -------------------------------------------------------

  String selectedCategory = 'Dairy';
  String selectedUnit = 'Pieces';
  String selectedStorage = 'Refrigerator';

  DateTime? purchaseDate;
  DateTime? expiryDate;

  // -------------------------------------------------------
  // DROPDOWN DATA
  // -------------------------------------------------------

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

  // -------------------------------------------------------
  // PURCHASE DATE
  // -------------------------------------------------------

  Future<void> selectPurchaseDate() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: purchaseDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (selectedDate == null) {
      return;
    }

    setState(() {
      purchaseDate = selectedDate;

      // Clear expiry date if it becomes invalid.
      if (expiryDate != null &&
          expiryDate!.isBefore(selectedDate)) {
        expiryDate = null;
      }
    });
  }

  // -------------------------------------------------------
  // EXPIRY DATE
  // -------------------------------------------------------

  Future<void> selectExpiryDate() async {
    final DateTime minimumDate =
        purchaseDate ?? DateTime.now();

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: expiryDate ?? minimumDate,
      firstDate: minimumDate,
      lastDate: DateTime(2100),
    );

    if (selectedDate == null) {
      return;
    }

    setState(() {
      expiryDate = selectedDate;
    });
  }

  // -------------------------------------------------------
  // FORMAT DATE
  // -------------------------------------------------------

  String formatDate(DateTime? date) {
    if (date == null) {
      return 'Select date';
    }

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // -------------------------------------------------------
  // SHOW MESSAGE
  // -------------------------------------------------------

  void showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // -------------------------------------------------------
  // ADD FOOD
  // -------------------------------------------------------

  Future<void> addFood() async {
    final String foodName =
        foodNameController.text.trim();

    final String quantityText =
        quantityController.text.trim();

    final String priceText =
        priceController.text.trim();

    // -----------------------------------------------------
    // VALIDATION
    // -----------------------------------------------------

    if (foodName.isEmpty) {
      showMessage('Please enter food name');
      return;
    }

    if (quantityText.isEmpty) {
      showMessage('Please enter quantity');
      return;
    }

    final double? quantity =
        double.tryParse(quantityText);

    if (quantity == null || quantity <= 0) {
      showMessage('Please enter a valid quantity');
      return;
    }

    if (purchaseDate == null) {
      showMessage('Please select purchase date');
      return;
    }

    if (expiryDate == null) {
      showMessage('Please select expiry date');
      return;
    }

    if (expiryDate!.isBefore(purchaseDate!)) {
      showMessage(
        'Expiry date cannot be before purchase date',
      );
      return;
    }

    if (priceText.isEmpty) {
      showMessage('Please enter price');
      return;
    }

    final double? price =
        double.tryParse(priceText);

    if (price == null || price < 0) {
      showMessage('Please enter a valid price');
      return;
    }

    // -----------------------------------------------------
    // CREATE FOOD OBJECT
    // -----------------------------------------------------

    final FoodItem food = FoodItem(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      name: foodName,
      category: selectedCategory,
      quantity: quantity,
      unit: selectedUnit,
      purchaseDate: purchaseDate!,
      expiryDate: expiryDate!,
      price: price,
      storageLocation: selectedStorage,
    );

    // -----------------------------------------------------
    // SAVE FOOD
    // -----------------------------------------------------

    await DatabaseService().insertFood(food);

    // -----------------------------------------------------
    // RETURN TO INVENTORY
    // -----------------------------------------------------

    if (!mounted) {
      return;
    }

    Navigator.pop(context, food);
  }

  // -------------------------------------------------------
  // BUILD
  // -------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Food'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            // ------------------------------------------------
            // TITLE
            // ------------------------------------------------

            const Text(
              'Add Food Item',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Enter the details of your food item.',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            // ------------------------------------------------
            // FOOD NAME
            // ------------------------------------------------

            TextField(
              controller: foodNameController,

              textCapitalization:
                  TextCapitalization.words,

              decoration:
                  const InputDecoration(
                labelText: 'Food Name',
                hintText: 'Example: Milk',

                prefixIcon: Icon(
                  Icons.restaurant_outlined,
                ),

                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 18),

            // ------------------------------------------------
            // CATEGORY
            // ------------------------------------------------

            DropdownButtonFormField<String>(
              initialValue: selectedCategory,

              decoration:
                  const InputDecoration(
                labelText: 'Category',

                prefixIcon: Icon(
                  Icons.category_outlined,
                ),

                border: OutlineInputBorder(),
              ),

              items: categories.map(
                (category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                },
              ).toList(),

              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  selectedCategory = value;
                });
              },
            ),

            const SizedBox(height: 18),

            // ------------------------------------------------
            // QUANTITY + UNIT
            // ------------------------------------------------

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
                      hintText: 'Example: 2',

                      prefixIcon: Icon(
                        Icons.numbers,
                      ),

                      border:
                          OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child:
                      DropdownButtonFormField<String>(
                    initialValue:
                        selectedUnit,

                    decoration:
                        const InputDecoration(
                      labelText: 'Unit',

                      border:
                          OutlineInputBorder(),
                    ),

                    items: units.map(
                      (unit) {
                        return DropdownMenuItem<
                            String>(
                          value: unit,
                          child: Text(unit),
                        );
                      },
                    ).toList(),

                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }

                      setState(() {
                        selectedUnit = value;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // ------------------------------------------------
            // PURCHASE DATE
            // ------------------------------------------------

            InkWell(
              onTap: selectPurchaseDate,

              child: InputDecorator(
                decoration:
                    const InputDecoration(
                  labelText: 'Purchase Date',

                  prefixIcon: Icon(
                    Icons.calendar_today_outlined,
                  ),

                  border:
                      OutlineInputBorder(),
                ),

                child: Text(
                  formatDate(purchaseDate),

                  style: TextStyle(
                    color: purchaseDate == null
                        ? Colors.grey
                        : Colors.black,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ------------------------------------------------
            // EXPIRY DATE
            // ------------------------------------------------

            InkWell(
              onTap: selectExpiryDate,

              child: InputDecorator(
                decoration:
                    const InputDecoration(
                  labelText: 'Expiry Date',

                  prefixIcon: Icon(
                    Icons.event_busy_outlined,
                  ),

                  border:
                      OutlineInputBorder(),
                ),

                child: Text(
                  formatDate(expiryDate),

                  style: TextStyle(
                    color: expiryDate == null
                        ? Colors.grey
                        : Colors.black,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ------------------------------------------------
            // PRICE
            // ------------------------------------------------

            TextField(
              controller: priceController,

              keyboardType:
                  const TextInputType
                      .numberWithOptions(
                decimal: true,
              ),

              decoration:
                  const InputDecoration(
                labelText: 'Price',
                hintText: 'Example: 60',

                prefixIcon: Icon(
                  Icons.currency_rupee,
                ),

                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 18),

            // ------------------------------------------------
            // STORAGE LOCATION
            // ------------------------------------------------

            DropdownButtonFormField<String>(
              initialValue: selectedStorage,

              decoration:
                  const InputDecoration(
                labelText: 'Storage Location',

                prefixIcon: Icon(
                  Icons.kitchen_outlined,
                ),

                border:
                    OutlineInputBorder(),
              ),

              items: storageLocations.map(
                (storage) {
                  return DropdownMenuItem<String>(
                    value: storage,
                    child: Text(storage),
                  );
                },
              ).toList(),

              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  selectedStorage = value;
                });
              },
            ),

            const SizedBox(height: 30),

            // ------------------------------------------------
            // SAVE BUTTON
            // ------------------------------------------------

            SizedBox(
              width: double.infinity,
              height: 52,

              child: ElevatedButton.icon(
                onPressed: addFood,

                icon: const Icon(
                  Icons.save_outlined,
                ),

                label: const Text(
                  'Save Food',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // DISPOSE
  // -------------------------------------------------------

  @override
  void dispose() {
    foodNameController.dispose();
    quantityController.dispose();
    priceController.dispose();

    super.dispose();
  }
}