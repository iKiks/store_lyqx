import 'package:store_lyqx/lyqx_core.dart';
import 'package:fpdart/fpdart.dart';

class GetProductsById implements UseCase<ProductModel, GetProductsByIdParams> {
  final ProductRepository repository;

  GetProductsById(this.repository);

  @override
  Future<Either<Failure, ProductModel>> call(
    GetProductsByIdParams params,
  ) async {
    return await repository.fetchProductById(params.id);
  }
}

class GetProductsByIdParams {
  final int id;

  GetProductsByIdParams({required this.id});
}
