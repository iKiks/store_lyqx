import 'package:store_lyqx/lyqx_core.dart';
import 'package:fpdart/fpdart.dart';

class UpdateCart {
  final CartRepository repository;

  UpdateCart(this.repository);

  Future<Either<dynamic, CartModel>> call(CartModel cart) async {
    return repository.updateCart(cart);
  }
}
