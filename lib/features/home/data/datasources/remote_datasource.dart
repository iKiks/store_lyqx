import 'package:store_lyqx/lyqx_core.dart';
import 'package:flutter/material.dart';

abstract interface class RemoteDataSource {
  Future<List<ProductModel>> getAllProducts({int limit = 15, int offset = 0});
  Future<ProductModel> getProductById(int id);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final ApiClient _apiClient;

  RemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<ProductModel>> getAllProducts({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await _apiClient.get(
        '/products',
        queryParameters: {'limit': limit, 'offset': offset},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data
            .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load products');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e, stack) {
      debugPrintStack(label: 'Error fetching products', stackTrace: stack);
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await _apiClient.get('/products/$id');
      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load product');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e, stack) {
      debugPrintStack(label: 'Error fetching products', stackTrace: stack);
      throw Exception('Unexpected error: $e');
    }
  }
}
