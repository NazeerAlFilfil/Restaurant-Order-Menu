import 'package:restaurant_order_menu/models/order%20types/local%20models/restaurant_table.dart';
import 'package:restaurant_order_menu/models/order_type.dart';

// TODO: Add String status which tracks the, well, status of the order, (ready) (prepared) (on the way) etc...
// TODO: Add customer here, if no such customer exist in the customers list, then add them to the list, and update the customer database
class OrderInformation {
  OrderType? orderType;
  RestaurantTable? localTable;
  String? deliveryLocation;
  DateTime? scheduledDateTime;

  OrderInformation({
    this.orderType,
    this.localTable,
    this.deliveryLocation,
    this.scheduledDateTime,
  });
}
