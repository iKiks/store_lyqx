part of 'product_bloc.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductModel> products;
  final bool hasMore;
  final bool isLoadingMore;

  ProductLoaded({
    required this.products,
    this.hasMore = true,
    this.isLoadingMore = false,
  });
}

class ProductDetailsLoaded extends ProductState {
  final ProductModel product;

  ProductDetailsLoaded(this.product);
}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);
}
