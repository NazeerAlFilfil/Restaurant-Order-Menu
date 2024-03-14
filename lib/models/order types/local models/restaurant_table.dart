class RestaurantTable {
  final String id;
  final String? tableName;
  final String? numberOfSeats;
  bool occupied;

  RestaurantTable({
    required this.id,
    this.tableName,
    this.numberOfSeats,
    this.occupied = false,
  });
}
