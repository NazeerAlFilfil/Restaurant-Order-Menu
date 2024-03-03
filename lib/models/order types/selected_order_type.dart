import 'package:restaurant_order_menu/models/order%20types/local%20models/restaurant_table.dart';
import 'package:restaurant_order_menu/models/order_type.dart';

class SelectedOrderType {
  OrderType? orderType;
  RestaurantTable? localTable;
  String? deliveryLocation;
  DateTime? scheduledDateTime;

  SelectedOrderType({
    this.orderType,
    this.localTable,
    this.deliveryLocation,
    this.scheduledDateTime,
  });
}
