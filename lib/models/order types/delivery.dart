import 'package:restaurant_order_menu/models/order_type.dart';

class Delivery extends OrderType {
  String location;

  Delivery({
    required super.type,
    required this.location,
  });
}
