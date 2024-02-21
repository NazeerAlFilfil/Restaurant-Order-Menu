import 'item_model.dart';

/// Item Model (Burger, Soda, Water, etc...)

/// Takes Label, image path, list of items
class Category {
  final String label;
  final String imagePath;
  final List<Item> items;

  Category({
    required this.label,
    required this.imagePath,
    required this.items,
  });
}