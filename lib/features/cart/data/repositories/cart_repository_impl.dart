import 'package:store_lyqx/lyqx_core.dart';
import 'package:fpdart/fpdart.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource _remoteDataSource;

  CartRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, CartModel>> getCart(int id) async {
    try {
      // Debug
      // ignore: avoid_print
      print('CartRepositoryImpl.getCart: calling remote for id=$id');
      final cart = await _remoteDataSource.getCart(id);
      // ignore: avoid_print
      print(
        'CartRepositoryImpl.getCart: remote returned cart with ${cart.products.length} products',
      );
      return Right(cart);
    } catch (e) {
      // ignore: avoid_print
      print('CartRepositoryImpl.getCart error: $e');
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartModel>> getCartByUser(int userId) async {
    try {
      // Debug
      // ignore: avoid_print
      print(
        'CartRepositoryImpl.getCartByUser: calling remote for userId=$userId',
      );
      final cart = await _remoteDataSource.getCartByUser(userId);
      // ignore: avoid_print
      print(
        'CartRepositoryImpl.getCartByUser: remote returned cart with ${cart.products.length} products',
      );
      return Right(cart);
    } catch (e) {
      // ignore: avoid_print
      print('CartRepositoryImpl.getCartByUser error: $e');
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartModel>> createCart(CartModel cart) async {
    try {
      final created = await _remoteDataSource.createCart(cart);
      return Right(created);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartModel>> updateCart(CartModel cart) async {
    try {
      final updated = await _remoteDataSource.updateCart(cart);
      return Right(updated);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCart(int id) async {
    try {
      await _remoteDataSource.deleteCart(id);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
