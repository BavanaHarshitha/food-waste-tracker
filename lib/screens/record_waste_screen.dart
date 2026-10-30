import 'package:flutter/material.dart';

import '../models/food_model.dart';
import '../models/waste_model.dart';
import '../services/database_service.dart';

class RecordWasteScreen extends StatefulWidget {
  const RecordWasteScreen({super.key});

  @override
  State<RecordWasteScreen> createState() =>
      _RecordWasteScreenState();
}

class _RecordWasteScreenState extends State<RecordWasteScreen> {
  final DatabaseService databaseService = DatabaseService();

  final TextEditingController quantityController =
      TextEditingController();

  final TextEditingController moneyController =
      TextEditingController();

  final TextEditingController notesController =
      TextEditingController();

  List<FoodItem> foodItems = [];


  FoodItem? selectedFood;

  String selectedUnit = 'Kg';
  String selectedReason = 'Expired';

  DateTime selectedDate = DateTime.now();

  bool isLoading = true;
  bool isSaving = false;

  final List<String> units = [
    'Kg',
    'Grams',
    'Litres',
    'Millilitres',
    'Pieces',
    'Packets',
  ];

  final List<String> reasons = [
    'Expired',
    'Spoiled',
    'Overcooked',
    'Leftover',
    'Damaged',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    loadFoodItems();
  }

  @override
  void dispose() {
    quantityController.dispose();
    moneyController.dispose();
    notesController.dispose();
    super.dispose();
  }

  // -------------------------------------------------------
  // LOAD FOOD ITEMS
  // -------------------------------------------------------

  Future<void> loadFoodItems() async {
    try {
      final List<FoodItem> items =
          await databaseService.getFoodItems();

      if (!mounted) return;

      setState(() {
        foodItems = items;
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
            'Failed to load food items: $e',
          ),
        ),
      );
    }
  }

  // -------------------------------------------------------
  // SELECT DATE
  // -------------------------------------------------------

  Future<void> selectDate() async {
    final DateTime? pickedDate =
        await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // -------------------------------------------------------
  // RECORD WASTE
  // -------------------------------------------------------

  Future<void> recordWaste() async {
    if (selectedFood == null) {
      showMessage(
        'Please select a food item.',
      );
      return;
    }

    final double? quantity =
        double.tryParse(
      quantityController.text.trim(),
    );

    if (quantity == null || quantity <= 0) {
      showMessage(
        'Please enter a valid waste quantity.',
      );
      return;
    }

    final double? moneyWasted =
        double.tryParse(
      moneyController.text.trim(),
    );

    if (moneyWasted == null || moneyWasted < 0) {
      showMessage(
        'Please enter a valid money amount.',
      );
      return;
    }

    if (quantity > selectedFood!.quantity) {
      showMessage(
        'Waste quantity cannot be greater than available quantity.',
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final WasteRecord waste = WasteRecord(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .toString(),
        foodName: selectedFood!.name,
        quantity: quantity,
        unit: selectedUnit,
        reason: selectedReason,
        wasteDate: selectedDate,
        moneyWasted: moneyWasted,
        notes: notesController.text.trim(),
      );

      await databaseService.insertWaste(waste);
final FoodItem updatedFood = FoodItem(
  id: selectedFood!.id,
  name: selectedFood!.name,
  category: selectedFood!.category,
  quantity: selectedFood!.quantity - quantity,
  unit: selectedFood!.unit,
  purchaseDate: selectedFood!.purchaseDate,
  expiryDate: selectedFood!.expiryDate,
  price: selectedFood!.price,
  storageLocation: selectedFood!.storageLocation,
);

await databaseService.updateFood(updatedFood);
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Waste recorded successfully!',
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      showMessage(
        'Failed to record waste: $e',
      );
    }
  }

  // -------------------------------------------------------
  // MESSAGE
  // -------------------------------------------------------

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Record Food Waste',
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : foodItems.isEmpty
              ? buildEmptyState()
              : buildForm(),
    );
  }

  // -------------------------------------------------------
  // EMPTY STATE
  // -------------------------------------------------------

  Widget buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 80,
              color: Colors.grey.shade500,
            ),

            const SizedBox(height: 20),

            const Text(
              'No food items found',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Please add food to your inventory before recording waste.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
              label: const Text(
                'Back to Inventory',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // FORM
  // -------------------------------------------------------

  Widget buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Food Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // FOOD
          DropdownButtonFormField<FoodItem>(
           initialValue: selectedFood,
            decoration: const InputDecoration(
              labelText: 'Food Name',
              prefixIcon: Icon(
                Icons.fastfood_outlined,
              ),
              border: OutlineInputBorder(),
            ),
            items: foodItems.map(
              (FoodItem food) {
                return DropdownMenuItem<FoodItem>(
                  value: food,
                  child: Text(
                    '${food.name} (${food.quantity} ${food.unit})',
                  ),
                );
              },
            ).toList(),
            onChanged: (FoodItem? value) {
              setState(() {
                selectedFood = value;

                if (value != null) {
                  selectedUnit = value.unit;
                }
              });
            },
          ),

          const SizedBox(height: 20),

          // QUANTITY
          TextField(
            controller: quantityController,
            keyboardType:
                const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: const InputDecoration(
              labelText: 'Waste Quantity',
              hintText: 'Enter quantity wasted',
              prefixIcon: Icon(
                Icons.scale_outlined,
              ),
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          // UNIT
          DropdownButtonFormField<String>(
            initialValue: units.contains(selectedUnit)
    ? selectedUnit
    : 'Kg',
            decoration: const InputDecoration(
              labelText: 'Unit',
              prefixIcon: Icon(
                Icons.straighten_outlined,
              ),
              border: OutlineInputBorder(),
            ),
            items: units.map(
              (String unit) {
                return DropdownMenuItem<String>(
                  value: unit,
                  child: Text(unit),
                );
              },
            ).toList(),
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  selectedUnit = value;
                });
              }
            },
          ),

          const SizedBox(height: 20),

          // REASON
          DropdownButtonFormField<String>(
            initialValue: selectedReason,
            decoration: const InputDecoration(
              labelText: 'Waste Reason',
              prefixIcon: Icon(
                Icons.warning_amber_outlined,
              ),
              border: OutlineInputBorder(),
            ),
            items: reasons.map(
              (String reason) {
                return DropdownMenuItem<String>(
                  value: reason,
                  child: Text(reason),
                );
              },
            ).toList(),
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  selectedReason = value;
                });
              }
            },
          ),

          const SizedBox(height: 20),

          // DATE
          InkWell(
            onTap: selectDate,
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Waste Date',
                prefixIcon: Icon(
                  Icons.calendar_today_outlined,
                ),
                border: OutlineInputBorder(),
              ),
              child: Text(
                formatDate(selectedDate),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // MONEY
          TextField(
            controller: moneyController,
            keyboardType:
                const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: const InputDecoration(
              labelText: 'Money Wasted',
              hintText: 'Enter amount',
              prefixIcon: Icon(
                Icons.currency_rupee,
              ),
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          // NOTES
          TextField(
            controller: notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Notes',
              hintText: 'Optional notes',
              prefixIcon: Icon(
                Icons.notes_outlined,
              ),
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 30),

          // BUTTON
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton.icon(
              onPressed:
                  isSaving ? null : recordWaste,
              icon: isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(
                      Icons.delete_outline,
                    ),
              label: Text(
                isSaving
                    ? 'Recording...'
                    : 'Record Waste',
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}