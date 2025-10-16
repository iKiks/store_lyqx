import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:store_lyqx/lyqx_core.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  ApiClient get apiClient => ApiClient();

  @lazySingleton
  RemoteDataSource get remoteDataSource => RemoteDataSourceImpl(apiClient);

  @lazySingleton
  ProductRepositoryImpl get productRepository =>
      ProductRepositoryImpl(remoteDataSource);

  @lazySingleton
  GetAllProducts get getAllProducts => GetAllProducts(productRepository);

  @lazySingleton
  GetProductsById get getProductsById => GetProductsById(productRepository);

  // Cart usecases
  @lazySingleton
  GetCartByUser get getCartByUser => GetCartByUser(cartRepository);

  @lazySingleton
  CreateCart get createCart => CreateCart(cartRepository);

  @lazySingleton
  UpdateCart get updateCart => UpdateCart(cartRepository);

  @lazySingleton
  DeleteCart get deleteCart => DeleteCart(cartRepository);

  // Blocs
  @factory
  ProductBloc productBloc(GetAllProducts getAll, GetProductsById getById) =>
      ProductBloc(getAllProductsUseCase: getAll, getProductById: getById);

  @factory
  CartBloc cartBloc(
    GetCartByUser getCartByUser,
    CreateCart createCart,
    UpdateCart updateCart,
    DeleteCart deleteCart,
    GetProductsById getProductsById,
  ) => CartBloc(
    getCartByUser: getCartByUser,
    createCart: createCart,
    updateCart: updateCart,
    deleteCart: deleteCart,
    getProductById: getProductsById,
  );

  @lazySingleton
  CartRemoteDataSource get cartRemote => CartRemoteDataSourceImpl(apiClient);

  @lazySingleton
  CartRepositoryImpl get cartRepository => CartRepositoryImpl(cartRemote);
}
