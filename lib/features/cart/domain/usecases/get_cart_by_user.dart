import 'package:store_lyqx/lyqx_core.dart';
import 'package:fpdart/fpdart.dart';

class GetCartByUser {
  final CartRepository repository;

  GetCartByUser(this.repository);

  Future<Either<dynamic, CartModel>> call(int userId) async {
    return repository.getCartByUser(userId);
  }
}
