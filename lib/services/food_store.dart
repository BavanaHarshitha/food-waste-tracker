import '../models/food_model.dart';

class FoodStore {
  FoodStore._privateConstructor();

  static final FoodStore _instance =
      FoodStore._privateConstructor();

  factory FoodStore() {
    return _instance;
  }

  final List<FoodItem> foodItems = [
    FoodItem(
      id: 'food001',
      name: 'Milk',
      category: 'Dairy',
      quantity: 2,
      unit: 'Litres',
      purchaseDate: DateTime(2026, 8, 19),
      expiryDate: DateTime(2026, 9, 8),
      price: 60,
      storageLocation: 'Refrigerator',
    ),
    FoodItem(
      id: 'food002',
      name: 'Bread',
      category: 'Bakery',
      quantity: 1,
      unit: 'Packets',
      purchaseDate: DateTime(2026, 8, 19),
      expiryDate: DateTime(2026, 9, 7),
      price: 40,
      storageLocation: 'Kitchen Shelf',
    ),
    FoodItem(
      id: 'food003',
      name: 'Apples',
      category: 'Fruits',
      quantity: 5,
      unit: 'Pieces',
      purchaseDate: DateTime(2026, 8, 18),
      expiryDate: DateTime(2026, 9, 10),
      price: 120,
      storageLocation: 'Refrigerator',
    ),
    FoodItem(
      id: 'food004',
      name: 'Rice',
      category: 'Grains',
      quantity: 5,
      unit: 'Kg',
      purchaseDate: DateTime(2026, 8, 10),
      expiryDate: DateTime(2026, 9, 30),
      price: 350,
      storageLocation: 'Pantry',
    ),
  ];

  void addFood(FoodItem food) {
    foodItems.add(food);
  }

 

void updateFood(FoodItem updatedFood) {
  final int index = foodItems.indexWhere(
    (item) => item.id == updatedFood.id,
  );

  print('EDIT ID: ${updatedFood.id}');
  print('FOUND INDEX: $index');
  print('NEW NAME: ${updatedFood.name}');
  print('NEW QUANTITY: ${updatedFood.quantity}');
  print('NEW PRICE: ${updatedFood.price}');

  if (index != -1) {
    foodItems[index] = updatedFood;

    print('UPDATED SUCCESSFULLY');
    print('STORE NAME: ${foodItems[index].name}');
    print('STORE QUANTITY: ${foodItems[index].quantity}');
    print('STORE PRICE: ${foodItems[index].price}');
  } else {
    print('ERROR: FOOD ID NOT FOUND');
  }
}



  void deleteFood(String id) {
    foodItems.removeWhere(
      (item) => item.id == id,
    );
  }
}