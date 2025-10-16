import 'package:store_lyqx/lyqx_core.dart';

abstract class AuthRemoteDataSource {
  Future<UserEntity> fetchUserById(int id);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;
  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<UserEntity> fetchUserById(int id) async {
    final response = await _apiClient.get('/users/$id');
    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      return UserEntity(
        id: data['id'] as int,
        username: data['username'] as String,
        email: data['email'] as String,
        password: data['password'] as String,
      );
    }
    throw Exception('Failed to fetch user');
  }
}
