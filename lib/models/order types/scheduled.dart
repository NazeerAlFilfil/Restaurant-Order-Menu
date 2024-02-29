import 'package:restaurant_order_menu/models/order_type.dart';

class Scheduled extends OrderType {
  DateTime dateTime;

  Scheduled({
    required super.type,
    required this.dateTime,
  });
}
