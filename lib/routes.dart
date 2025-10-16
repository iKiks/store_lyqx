import 'package:store_lyqx/lyqx_core.dart';

class AppRouter {
  /// Routes
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      ShellRoute(
        builder: (context, state, child) => RootShell(child: child),
        routes: [
          GoRoute(
            name: 'home',
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            name: 'wishlist',
            path: '/wishlist',
            builder: (context, state) => const WishlistScreen(),
          ),
          GoRoute(
            name: 'cart',
            path: '/cart',
            builder: (context, state) => const CartScreen(),
          ),
        ],
      ),

      GoRoute(
        name: 'splash',
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        name: 'productDetails',
        path: '/product/:id',
        builder: (context, state) {
          final productId = int.parse(state.pathParameters['id']!);
          return ProductDetailsScreen(productId: productId);
        },
      ),
    ],
  );
}
