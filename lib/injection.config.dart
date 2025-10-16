// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:store_lyqx/injection_module.dart' as _i334;
import 'package:store_lyqx/lyqx_core.dart' as _i10;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i10.ApiClient>(() => registerModule.apiClient);
    gh.lazySingleton<_i10.RemoteDataSource>(
      () => registerModule.remoteDataSource,
    );
    gh.lazySingleton<_i10.ProductRepositoryImpl>(
      () => registerModule.productRepository,
    );
    gh.lazySingleton<_i10.GetAllProducts>(() => registerModule.getAllProducts);
    gh.lazySingleton<_i10.GetProductsById>(
      () => registerModule.getProductsById,
    );
    gh.lazySingleton<_i10.GetCartByUser>(() => registerModule.getCartByUser);
    gh.lazySingleton<_i10.CreateCart>(() => registerModule.createCart);
    gh.lazySingleton<_i10.UpdateCart>(() => registerModule.updateCart);
    gh.lazySingleton<_i10.DeleteCart>(() => registerModule.deleteCart);
    gh.lazySingleton<_i10.CartRemoteDataSource>(
      () => registerModule.cartRemote,
    );
    gh.lazySingleton<_i10.CartRepositoryImpl>(
      () => registerModule.cartRepository,
    );
    gh.factory<_i10.CartBloc>(
      () => registerModule.cartBloc(
        gh<_i10.GetCartByUser>(),
        gh<_i10.CreateCart>(),
        gh<_i10.UpdateCart>(),
        gh<_i10.DeleteCart>(),
        gh<_i10.GetProductsById>(),
      ),
    );
    gh.factory<_i10.ProductBloc>(
      () => registerModule.productBloc(
        gh<_i10.GetAllProducts>(),
        gh<_i10.GetProductsById>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i334.RegisterModule {}
