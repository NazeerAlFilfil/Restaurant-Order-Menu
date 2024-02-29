/// Option Model (Tomato, Cheese, etc...)
library;

/// Takes Label
/// image path is recommended, price is optional
/// default level is optional, its default values = 2
class Option {
  final String label;
  final String? imagePath;
  final double? price;
  final int defaultLevel;

  Option({
    required this.label,
    this.imagePath,
    this.price,
    this.defaultLevel = 2,
  });
}