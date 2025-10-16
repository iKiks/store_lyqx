import 'package:store_lyqx/lyqx_core.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUser loginUser;

  LoginBloc({required this.loginUser}) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    final result = await loginUser(event.email, event.password);
    await result.match(
      (l) async {
        emit(LoginFailure(l.toString()));
      },
      (user) async {
        // save user to storage (as JSON)
        final model = UserModel.fromEntity(user);
        await AppStorage.saveUser(model.toJson());
        emit(LoginSuccess());
      },
    );
  }
}
