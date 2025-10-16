import 'package:store_lyqx/lyqx_core.dart';
import 'package:fpdart/fpdart.dart';

class CreateCart {
  final CartRepository repository;

  CreateCart(this.repository);

  Future<Either<dynamic, CartModel>> call(CartModel cart) async {
    return repository.createCart(cart);
  }
}
