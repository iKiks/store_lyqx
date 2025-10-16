import 'package:store_lyqx/lyqx_core.dart';
import 'package:flutter/material.dart';

// `CartModel` and `CartItem` are exposed via the central barrel `lyqx_core.dart`.

abstract interface class CartRemoteDataSource {
  Future<CartModel> getCart(int id);
  Future<CartModel> getCartByUser(int userId);
  Future<CartModel> createCart(CartModel cart);
  Future<CartModel> updateCart(CartModel cart);
  Future<void> deleteCart(int id);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiClient _apiClient;

  CartRemoteDataSourceImpl(this._apiClient);

  @override
  Future<CartModel> getCart(int id) async {
    try {
      final response = await _apiClient.get('/carts/$id');
      // debug: inspect response type and data for tracing issues
      // ignore: avoid_print
      print(
        'CartRemoteDataSource.getCart: status=${response.statusCode}, dataType=${response.data.runtimeType}',
      );
      // ignore: avoid_print
      print('CartRemoteDataSource.getCart: data=${response.data}');

      if (response.statusCode == 200) {
        // Some endpoints may return a List with a single map; tolerate that.
        final dynamic raw = response.data;
        final Map<String, dynamic> data = (raw is List && raw.isNotEmpty)
            ? (raw.first as Map<String, dynamic>)
            : (raw as Map<String, dynamic>);
        // fakestoreapi returns {id, userId, date, products: [{productId, quantity}]}
        final products = <CartItem>[];
        final List<dynamic> rawProducts = (data['products'] is List)
            ? data['products'] as List<dynamic>
            : <dynamic>[];
        for (final p in rawProducts) {
          products.add(
            CartItem(
              productId: p['productId'] as int,
              title: '',
              image: '',
              price: 0.0,
              quantity: p['quantity'] as int,
            ),
          );
        }
        return CartModel(
          id: data['id'] as int,
          userId: data['userId'] as int,
          products: products,
        );
      }
      throw Exception('Failed to load cart');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e, stack) {
      debugPrintStack(label: 'Error fetching cart', stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<CartModel> getCartByUser(int userId) async {
    try {
      final response = await _apiClient.get('/carts/user/$userId');
      // debug: inspect response
      // ignore: avoid_print
      print(
        'CartRemoteDataSource.getCartByUser: status=${response.statusCode}, dataType=${response.data.runtimeType}',
      );
      // ignore: avoid_print
      print('CartRemoteDataSource.getCartByUser: data=${response.data}');

      if (response.statusCode == 200) {
        final dynamic raw = response.data;
        final Map<String, dynamic> data = (raw is List && raw.isNotEmpty)
            ? (raw.first as Map<String, dynamic>)
            : (raw as Map<String, dynamic>);
        final products = <CartItem>[];
        final List<dynamic> rawProducts = (data['products'] is List)
            ? data['products'] as List<dynamic>
            : <dynamic>[];
        for (final p in rawProducts) {
          products.add(
            CartItem(
              productId: p['productId'] as int,
              title: '',
              image: '',
              price: 0.0,
              quantity: p['quantity'] as int,
            ),
          );
        }
        return CartModel(
          id: data['id'] as int,
          userId: data['userId'] as int,
          products: products,
        );
      }
      throw Exception('Failed to load cart for user $userId');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e, stack) {
      debugPrintStack(label: 'Error fetching cart by user', stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<CartModel> createCart(CartModel cart) async {
    try {
      final body = {
        'userId': cart.userId,
        'date': DateTime.now().toIso8601String(),
        'products': cart.products
            .map((p) => {'productId': p.productId, 'quantity': p.quantity})
            .toList(),
      };
      final response = await _apiClient.post('/carts', data: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        final List<CartItem> products = (data['products'] as List<dynamic>)
            .map(
              (p) => CartItem(
                productId: p['productId'] as int,
                title: '',
                image: '',
                price: 0.0,
                quantity: p['quantity'] as int,
              ),
            )
            .toList();
        return CartModel(
          id: data['id'] as int,
          userId: data['userId'] as int,
          products: products,
        );
      }
      throw Exception('Failed to create cart');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<CartModel> updateCart(CartModel cart) async {
    try {
      final body = {
        'userId': cart.userId,
        'date': DateTime.now().toIso8601String(),
        'products': cart.products
            .map((p) => {'productId': p.productId, 'quantity': p.quantity})
            .toList(),
      };
      final response = await _apiClient.put('/carts/${cart.id}', data: body);
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final products = (data['products'] as List<dynamic>)
            .map(
              (p) => CartItem(
                productId: p['productId'] as int,
                title: '',
                image: '',
                price: 0.0,
                quantity: p['quantity'] as int,
              ),
            )
            .toList();
        return CartModel(
          id: data['id'] as int,
          userId: data['userId'] as int,
          products: products,
        );
      }
      throw Exception('Failed to update cart');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<void> deleteCart(int id) async {
    try {
      final response = await _apiClient.delete('/carts/$id');
      if (response.statusCode == 200) {
        return;
      }
      throw Exception('Failed to delete cart');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}
