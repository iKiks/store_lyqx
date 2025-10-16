import 'package:store_lyqx/lyqx_core.dart';

abstract class CartEvent {}

class LoadCart extends CartEvent {
  final int cartId;
  LoadCart(this.cartId);
}

class AddItem extends CartEvent {
  final CartItem item;
  AddItem(this.item);
}

class RemoveItem extends CartEvent {
  final int productId;
  RemoveItem(this.productId);
}

class UpdateQuantity extends CartEvent {
  final int productId;
  final int quantity;
  UpdateQuantity(this.productId, this.quantity);
}

class ClearCart extends CartEvent {}
