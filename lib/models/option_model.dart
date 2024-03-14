/// Option Model (Tomato, Cheese, etc...)
library;

/// Takes Label
/// image path is recommended, price is optional
/// default level is optional, its default values = 2
class Option {
  final int id;
  final int itemId;
  final String label;
  final String? imagePath;
  final double? price;
  final int defaultLevel;

  Option({
    required this.id,
    required this.itemId,
    required this.label,
    this.imagePath,
    this.price,
    this.defaultLevel = 2,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'itemId': itemId,
      'label': label,
      'imagePath': imagePath,
      'price': price,
      'defaultLevel': defaultLevel,
    };
  }
}