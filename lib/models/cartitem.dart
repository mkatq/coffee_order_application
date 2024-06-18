// Define the CartItem class
class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final int size;
  final String image;
  final itemid;

  CartItem(
    this.itemid, {
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.size,
    required this.image,
  });
}
