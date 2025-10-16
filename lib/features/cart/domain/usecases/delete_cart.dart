import 'package:store_lyqx/lyqx_core.dart';
import 'package:fpdart/fpdart.dart';

class DeleteCart {
  final CartRepository repository;

  DeleteCart(this.repository);

  Future<Either<dynamic, void>> call(int id) async {
    return repository.deleteCart(id);
  }
}
