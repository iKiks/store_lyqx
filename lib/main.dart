// Barrel import at top
import 'package:store_lyqx/lyqx_core.dart';
import 'package:store_lyqx/injection.dart';
import 'package:store_lyqx/routes.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup DI (injectable + GetIt)
  configureDependencies();

  // Resolve blocs from GetIt
  final ProductBloc productBloc = getIt<ProductBloc>();
  final CartBloc cartBloc = getIt<CartBloc>();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => productBloc),
        BlocProvider(create: (context) => cartBloc),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // App root
  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);

    return MaterialApp.router(
      routerConfig: AppRouter.router,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
    );
  }
}
