import 'package:store_lyqx/lyqx_core.dart';
import 'package:fpdart/fpdart.dart';

class GetCart {
  final CartRepository repository;

  GetCart(this.repository);

  Future<Either<dynamic, CartModel>> call(int id) async {
    return repository.getCart(id);
  }
}
