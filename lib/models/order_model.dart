import 'line_item_model.dart';
import 'order types/order_information.dart';

/// Order Model (For a Single Order)

/// Takes id, and lineItems (Mini Orders)
// TODO: change id => order number, add id for database?
class Order {
  final String id;
  final List<LineItem> lineItems;
  final OrderInformation orderInformation;

  Order({
    required this.id,
    required this.lineItems,
    required this.orderInformation,
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