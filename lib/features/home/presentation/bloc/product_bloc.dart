import 'package:store_lyqx/lyqx_core.dart';
import 'package:flutter/material.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetAllProducts _getAllProductsUseCase;
  final GetProductsById _getProductById;

  ProductBloc({
    required GetAllProducts getAllProductsUseCase,
    required GetProductsById getProductById,
  }) : _getAllProductsUseCase = getAllProductsUseCase,
       _getProductById = getProductById,
       super(ProductInitial()) {
    on<FetchProducts>(_onFetchProducts);
    on<FetchProductById>(_onFetchProductById);
  }

  Future<void> _onFetchProductById(
    FetchProductById event,
    Emitter<ProductState> emit,
  ) async {
    // Debug
    // ignore: avoid_print
    print('ProductBloc: FetchProductById(${event.id})');
    emit(ProductLoading());

    final result = await _getProductById(GetProductsByIdParams(id: event.id));

    result.fold((failure) => emit(ProductError(failure.toString())), (product) {
      // Debug
      // ignore: avoid_print
      print('ProductBloc: ProductDetailsLoaded id=${product.id}');
      emit(ProductDetailsLoaded(product));
    });
  }

  _onFetchProducts(FetchProducts event, Emitter<ProductState> emit) async {
    // If loading more, preserve list and set isLoadingMore
    // Debug
    // ignore: avoid_print
    print(
      'ProductBloc: FetchProducts(limit=${event.limit}, offset=${event.offset})',
    );
    if (event.offset > 0 && state is ProductLoaded) {
      final current = state as ProductLoaded;
      emit(
        ProductLoaded(
          products: current.products,
          hasMore: current.hasMore,
          isLoadingMore: true,
        ),
      );
    } else {
      emit(ProductLoading());
    }

    final result = await _getAllProductsUseCase(
      GetAllProductsParams(limit: event.limit, offset: event.offset),
    );

    result.fold((failure) => emit(ProductError(failure.toString())), (
      products,
    ) {
      // Debug
      // ignore: avoid_print
      print('ProductBloc: FetchProducts result count=${products.length}');
      if (event.offset > 0 && state is ProductLoaded) {
        // Append
        final current = state as ProductLoaded;
        final combined = List<ProductModel>.from(current.products)
          ..addAll(products);
        emit(
          ProductLoaded(
            products: combined,
            hasMore: products.isNotEmpty,
            isLoadingMore: false,
          ),
        );
      } else {
        emit(
          ProductLoaded(
            products: products,
            hasMore: products.isNotEmpty,
            isLoadingMore: false,
          ),
        );
      }
    });
  }
}
