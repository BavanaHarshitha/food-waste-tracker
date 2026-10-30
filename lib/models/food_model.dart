class FoodItem {
  final String id;
  final String name;
  final String category;
  final double quantity;
  final String unit;
  final DateTime purchaseDate;
  final DateTime expiryDate;
  final double price;
  final String storageLocation;

  FoodItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.purchaseDate,
    required this.expiryDate,
    required this.price,
    required this.storageLocation,
  });

  // Number of days remaining until expiry
  int get daysRemaining {
    final DateTime today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    final DateTime expiry = DateTime(
      expiryDate.year,
      expiryDate.month,
      expiryDate.day,
    );

    return expiry.difference(today).inDays;
  }

  // Expiry status
  String get expiryStatus {
    if (daysRemaining < 0) {
      return 'Expired';
    }

    if (daysRemaining == 0) {
      return 'Expires Today';
    }

    if (daysRemaining <= 3) {
      return 'Expiring Soon';
    }

    return 'Fresh';
  }

  // Convert FoodItem to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'quantity': quantity,
      'unit': unit,
      'purchaseDate': purchaseDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
      'price': price,
      'storageLocation': storageLocation,
    };
  }

  // Convert Map to FoodItem
  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'] as String,
      name: map['name'] as String,
      category: map['category'] as String,
      quantity: (map['quantity'] as num).toDouble(),
      unit: map['unit'] as String,
      purchaseDate: DateTime.parse(
        map['purchaseDate'] as String,
      ),
      expiryDate: DateTime.parse(
        map['expiryDate'] as String,
      ),
      price: (map['price'] as num).toDouble(),
      storageLocation:
          map['storageLocation'] as String,
    );
  }
}