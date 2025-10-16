import 'package:store_lyqx/lyqx_core.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool emailError = false;
  bool passwordError = false;

  late final LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    final api = ApiClient();
    final remote = AuthRemoteDataSourceImpl(api);
    final repo = AuthRepositoryImpl(remote);
    final usecase = LoginUser(repo);
    loginBloc = LoginBloc(loginUser: usecase);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocProvider.value(
            value: loginBloc,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: ResponsiveSize.height(41),
                  width: ResponsiveSize.width(41),
                  decoration: BoxDecoration(
                    color: AppColors.transparentColor,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: AppColors.extraLightColor),
                  ),
                  child: Center(
                    child: IconButton(
                      padding: EdgeInsets.only(left: 6.0),
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.arrow_back_ios, size: 16),
                      color: AppColors.blackColor,
                      onPressed: () {
                        context.pop();
                      },
                    ),
                  ),
                ),

                SizedBox(height: ResponsiveSize.height(30)),

                AppTexts(
                  'Welcome back! Glad \nto see you, Again!',
                  fontSize: ResponsiveSize.fontSize(30),
                  fontWeight: FontWeight.w700,
                ),

                SizedBox(height: ResponsiveSize.height(32)),

                AuthField(
                  label: 'Email',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  error: emailError,
                ),

                SizedBox(height: ResponsiveSize.height(16)),

                AuthField(
                  label: 'Password',
                  controller: passwordController,
                  obscureText: true,
                  isPassword: true,
                  error: passwordError,
                ),

                SizedBox(height: ResponsiveSize.height(40)),

                BlocConsumer<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state is LoginSuccess) {
                      context.pushNamed('home');
                    }
                    if (state is LoginFailure) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  builder: (context, state) {
                    return AppButtons(
                      buttonText: state is LoginLoading
                          ? 'Loading...'
                          : 'Login',
                      onPressed: () {
                        final email = emailController.text.trim();
                        final pwd = passwordController.text;
                        setState(() {
                          emailError = email.isEmpty || !email.contains('@');
                          passwordError = pwd.isEmpty;
                        });
                        if (!emailError && !passwordError) {
                          context.read<LoginBloc>().add(
                            LoginSubmitted(email, pwd),
                          );
                        }
                      },
                      buttonColor: AppColors.primaryColor,
                      textColor: AppColors.whiteColor,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
