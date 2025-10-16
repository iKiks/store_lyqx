import 'package:store_lyqx/lyqx_core.dart';
import 'package:fpdart/fpdart.dart';

class ProductRepositoryImpl implements ProductRepository {
  final RemoteDataSource _remoteDataSource;

  ProductRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<ProductModel>>> fetchAllProducts({
    int limit = 15,
    int offset = 0,
  }) async {
    try {
      final products = await _remoteDataSource.getAllProducts(
        limit: limit,
        offset: offset,
      );
      return Right(products);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductModel>> fetchProductById(int id) async {
    try {
      final product = await _remoteDataSource.getProductById(id);
      return Right(product);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
