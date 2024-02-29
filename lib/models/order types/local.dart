import 'package:restaurant_order_menu/models/order_type.dart';
import 'local models/restaurant_table.dart';

class Local extends OrderType {
  RestaurantTable table;

  Local({
    required super.type,
    required this.table,
  });
}
