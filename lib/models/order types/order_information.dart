import 'package:restaurant_order_menu/models/customer.dart';
import 'package:restaurant_order_menu/models/order%20types/local%20models/restaurant_table.dart';
import 'package:restaurant_order_menu/models/order_type.dart';

class OrderInformation {
  OrderType? orderType;

  String? orderStatus;
  String? paymentStatus;

  RestaurantTable? localTable;
  String? deliveryLocation;
  DateTime? scheduledDateTime;

  Customer? customer;

  DateTime? timeStamp;

  OrderInformation({
    this.orderType,
    this.orderStatus,
    this.paymentStatus,
    this.localTable,
    this.deliveryLocation,
    this.scheduledDateTime,
    this.customer,
    this.timeStamp,
  });
}
