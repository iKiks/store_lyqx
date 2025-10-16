import 'package:store_lyqx/lyqx_core.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ProductRepository {
  Future<Either<Failure, List<ProductModel>>> fetchAllProducts({
    int limit = 15,
    int offset = 0,
    // CancellationToken? cancelToken,
  });
  Future<Either<Failure, ProductModel>> fetchProductById(
    int id,
    // CancellationToken? cancelToken,
  );
}
