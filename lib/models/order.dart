class Order {
  int id;
  int userId;
  int shopId;
  List<String> items;
  double totalPrice;
  String orderStatus;
  DateTime createdAt;

  Order({
    required this.id,
    required this.userId,
    required this.shopId,
    required this.items,
    required this.totalPrice,
    required this.orderStatus,
    required this.createdAt,
  });
}
