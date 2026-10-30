import 'package:flutter_test/flutter_test.dart';
import 'package:food_waste_tracker/models/food_model.dart';

void main() {
  test('FoodItem should store food details correctly', () {
    final food = FoodItem(
      id: '1',
      name: 'Milk',
      category: 'Dairy',
      quantity: 2,
      unit: 'Litres',
      purchaseDate: DateTime(2026, 10, 1),
      expiryDate: DateTime(2026, 10, 5),
      price: 100,
      storageLocation: 'Refrigerator',
    );

    expect(food.name, 'Milk');
    expect(food.category, 'Dairy');
    expect(food.quantity, 2);
    expect(food.unit, 'Litres');
    expect(food.price, 100);
    expect(food.storageLocation, 'Refrigerator');
  });
}