class WasteRecord {
  final String id;
  final String foodName;
  final double quantity;
  final String unit;
  final String reason;
  final DateTime wasteDate;
  final double moneyWasted;
  final String notes;

  WasteRecord({
    required this.id,
    required this.foodName,
    required this.quantity,
    required this.unit,
    required this.reason,
    required this.wasteDate,
    required this.moneyWasted,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'foodName': foodName,
      'quantity': quantity,
      'unit': unit,
      'reason': reason,
      'wasteDate': wasteDate.toIso8601String(),
      'moneyWasted': moneyWasted,
      'notes': notes,
    };
  }

  factory WasteRecord.fromMap(Map<String, dynamic> map) {
    return WasteRecord(
      id: map['id'] as String,
      foodName: map['foodName'] as String,
      quantity: (map['quantity'] as num).toDouble(),
      unit: map['unit'] as String,
      reason: map['reason'] as String,
      wasteDate: DateTime.parse(map['wasteDate'] as String),
      moneyWasted: (map['moneyWasted'] as num).toDouble(),
      notes: map['notes'] as String,
    );
  }
}