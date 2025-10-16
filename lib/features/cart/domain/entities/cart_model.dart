import 'cart_item.dart';

class CartModel {
  final int id;
  final int userId;
  final List<CartItem> products;

  CartModel({required this.id, required this.userId, required this.products});
}
