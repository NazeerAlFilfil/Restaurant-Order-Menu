/// Unit Model (Large, Medium, Small, etc...)
library;

/// Takes Label & Price
/// image path & filled image path are optional, but recommended
class Unit {
  final int id;
  final int itemId;
  final String label;
  final double price;
  final String? imagePath;
  final String? filledImagePath;

  Unit({
    required this.id,
    required this.itemId,
    required this.label,
    required this.price,
    this.imagePath,
    this.filledImagePath,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'itemId': itemId,
      'label': label,
      'price': price,
      'imagePath': imagePath,
      'filledImagePath': filledImagePath,
    };
  }
}
