import 'package:fpdart/fpdart.dart';
import 'package:store_lyqx/lyqx_core.dart';

abstract interface class CartRepository {
  Future<Either<Failure, CartModel>> getCart(int id);
  Future<Either<Failure, CartModel>> getCartByUser(int userId);
  Future<Either<Failure, CartModel>> createCart(CartModel cart);
  Future<Either<Failure, CartModel>> updateCart(CartModel cart);
  Future<Either<Failure, void>> deleteCart(int id);
}
