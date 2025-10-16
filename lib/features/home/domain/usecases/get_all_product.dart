import 'package:store_lyqx/lyqx_core.dart';
import 'package:fpdart/fpdart.dart';

class GetAllProducts
    implements UseCase<List<ProductModel>, GetAllProductsParams> {
  final ProductRepository _repository;

  GetAllProducts(this._repository);

  @override
  Future<Either<Failure, List<ProductModel>>> call(
    GetAllProductsParams params,
  ) {
    return _repository.fetchAllProducts(
      limit: params.limit,
      offset: params.offset,
    );
  }
}

class GetAllProductsParams {
  final int limit;
  final int offset;
  // Optional: CancellationToken

  GetAllProductsParams({
    this.limit = 15,
    this.offset = 0,
    // this.cancelToken,
  });
}
