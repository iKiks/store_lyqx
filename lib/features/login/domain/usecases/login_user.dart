import 'package:store_lyqx/lyqx_core.dart';
import 'package:fpdart/fpdart.dart';

class LoginUser {
  final AuthRepository repository;
  LoginUser(this.repository);

  Future<Either<dynamic, UserEntity>> call(
    String email,
    String password,
  ) async {
    return repository.loginWithEmail(email, password);
  }
}
