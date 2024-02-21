import 'line_item_model.dart';

/// Order Model (For a Single Order)

/// Takes id, and lineItems (Mini Orders)
class Order {
  final String id;
  final List<LineItem> lineItems;

  Order({
    required this.id,
    required this.lineItems,
  });

  double calculateTotalPrice() {
    return lineItems.fold(0, (previousValue, element) => previousValue + element.totalPrice);
  }

  double calculateBeforeVATPrice() {
    return lineItems.fold(0, (previousValue, element) => previousValue + element.beforeVATPrice);
  }

  double calculateVATPrice() {
    return lineItems.fold(0, (previousValue, element) => previousValue + element.VATPrice);
  }
}