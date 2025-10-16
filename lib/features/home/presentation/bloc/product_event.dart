part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

class FetchProducts extends ProductEvent {
  final int limit;
  final int offset;

  FetchProducts({this.limit = 15, this.offset = 0});
}

class FetchProductById extends ProductEvent {
  final int id;

  FetchProductById(this.id);
}

class RefreshProducts extends ProductEvent {}
