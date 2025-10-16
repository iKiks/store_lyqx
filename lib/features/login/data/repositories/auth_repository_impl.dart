import 'package:store_lyqx/lyqx_core.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  AuthRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, UserEntity>> loginWithEmail(
    String email,
    String password,
  ) async {
    try {
      // For now validate against user id 1 (sample user provided)
      final user = await _remote.fetchUserById(1);
      if (user.email == email && user.password == password) {
        return Right(user);
      } else {
        return Left(Failure('Invalid credentials'));
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
