/// Unit Model (Large, Medium, Small, etc...)

/// Takes Label & Price
/// image path & filled image path are optional, but recommended
class Unit {
  final String label;
  final double price;
  final String? imagePath;
  final String? filledImagePath;

  Unit({
    required this.label,
    required this.price,
    this.imagePath,
    this.filledImagePath,
  });
}
