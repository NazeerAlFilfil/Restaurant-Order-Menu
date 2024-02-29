
import '../constants.dart';
import 'item_model.dart';
import 'option_model.dart';
import 'unit_model.dart';

/// Line Item Model (Mini Orders)

/// Takes item, quantity, picked unit, list of picked options
/// total price, before VAT price, VAT price, unit price are self calculated
class LineItem {
  final Item item;
  int quantity;
  Unit pickedUnit;
  final Map<Option, int> pickedOptions;

  late double totalPrice;
  late double beforeVATPrice;
  late double VATPrice;
  late double unitPrice;


  LineItem({
    required this.item,
    required this.quantity,
    required this.pickedUnit,
    required this.pickedOptions,
  }) {
    totalPrice = 0.0;
    beforeVATPrice = 0.0;
    VATPrice = 0.0;
    unitPrice = 0.0;

    updatePrices();
  }

  /// Call to update all prices automatically
  // Ensure values are update in order, as some depend on others in calculations
  void updatePrices() {
    _updateUnitPrice();
    _updateTotalPrice();
    _updateBeforeVATPrice();
    _updateVATPrice();
  }

  void _updateTotalPrice() {
    totalPrice = quantity * unitPrice;
  }

  void _updateBeforeVATPrice() {
    beforeVATPrice = totalPrice / (1.0 + VAT);
  }

  void _updateVATPrice() {
    VATPrice = totalPrice - beforeVATPrice;
  }

  void _updateUnitPrice() {
    unitPrice = pickedUnit.price + _getPickedOptionsPrice();
  }

  double _getPickedOptionsPrice() {
    double optionsPrice = 0.0;

    // For each picked option, we compare its default level with the level we picked
    // If the level we picked is higher, then we get the option price (if it is null, meaning free, we get 0)
    // Otherwise we get 0 (in case we got lower level than default)
    for (Option option in pickedOptions.keys) {
      optionsPrice += option.defaultLevel < pickedOptions[option]! ? (option.price ?? 0.0) : 0.0;
    }

    return optionsPrice;
  }
}