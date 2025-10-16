import 'package:store_lyqx/lyqx_core.dart';

abstract class CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;

  CartLoaded(this.items);

  double get total =>
      items.fold(0.0, (prev, item) => prev + item.price * item.quantity);
}

class CartError extends CartState {
  final String message;
  CartError(this.message);
}
