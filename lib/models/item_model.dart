import 'option_model.dart';
import 'unit_model.dart';

/// Item Model (Burger, Soda, Water, etc...)

/// Takes Label, image path, list of units, list of options
/// description is optional
class Item {
  final int id;
  final String label;
  final String? description;
  final String imagePath;
  final List<Unit> units;
  final List<Option> options;

  Item({
    required this.id,
    required this.label,
    this.description,
    required this.imagePath,
    required this.units,
    required this.options,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'label': label,
      'description': description,
      'imagePath': imagePath,
      //'units': units,
      //'options': options,
    };
  }
}