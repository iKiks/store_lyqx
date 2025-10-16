import 'package:store_lyqx/lyqx_core.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _username = 'Username';
  List<ProductModel>? _cachedProducts;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load saved username once
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    try {
      final user = await AppStorage.getUserModel();
      if (user != null && user.username.isNotEmpty) {
        setState(() => _username = user.username);
      }
    } catch (_) {
      // ignore error
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(FetchProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreyColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: BlocConsumer<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state is ProductError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              if (state is ProductLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ProductDetailsLoaded && _cachedProducts != null) {
                final products = _cachedProducts!;
                if (products.isEmpty) {
                  return const Center(child: Text("No products available."));
                }

                return _buildProductList(context, products);
              }

              if (state is ProductLoaded) {
                // update cache
                _cachedProducts = state.products;
                if (state.products.isEmpty) {
                  return const Center(child: Text("No products available."));
                }

                return BlocListener<CartBloc, CartState>(
                  listener: (context, cartState) {
                    if (cartState is CartError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Cart error: ${cartState.message}'),
                        ),
                      );
                    } else if (cartState is CartLoaded) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cart updated')),
                      );
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppTexts(
                                'Welcome,',
                                fontSize: ResponsiveSize.fontSize(24),
                                fontWeight: FontWeight.w600,
                              ),
                              AppTexts(
                                _username,
                                fontSize: ResponsiveSize.fontSize(24),
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                          const LogoutButton(clearCart: true),
                        ],
                      ),
                      SizedBox(height: ResponsiveSize.height(18)),
                      AppTexts(
                        'Fake Store',
                        fontSize: ResponsiveSize.fontSize(28),
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: ResponsiveSize.height(16)),

                      // Products
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.products.length,
                          itemBuilder: (context, index) {
                            final product = state.products[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: ResponsiveSize.height(8),
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                  await context.pushNamed(
                                    'productDetails',
                                    pathParameters: {
                                      'id': product.id.toString(),
                                    },
                                  );
                                  context.read<ProductBloc>().add(
                                    FetchProducts(),
                                  );
                                },
                                child: ProductCard(
                                  id: product.id,
                                  title: product.title,
                                  category: product.category,
                                  rating: product.rating,
                                  price: '\$${product.price}',
                                  imageUrl: product.image,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (state is ProductError) {
                return Center(child: Text("Error: ${state.message}"));
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProductList(BuildContext context, List<ProductModel> products) {
    return BlocListener<CartBloc, CartState>(
      listener: (context, cartState) {
        if (cartState is CartError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cart error: ${cartState.message}')),
          );
        } else if (cartState is CartLoaded) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Cart updated')));
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTexts(
                    'Welcome,',
                    fontSize: ResponsiveSize.fontSize(24),
                    fontWeight: FontWeight.w600,
                  ),
                  AppTexts(
                    _username,
                    fontSize: ResponsiveSize.fontSize(24),
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              const LogoutButton(clearCart: true),
            ],
          ),
          SizedBox(height: ResponsiveSize.height(18)),
          AppTexts(
            'Fake Store',
            fontSize: ResponsiveSize.fontSize(28),
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: ResponsiveSize.height(16)),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveSize.height(8),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      await context.pushNamed(
                        'productDetails',
                        pathParameters: {'id': product.id.toString()},
                      );
                      context.read<ProductBloc>().add(FetchProducts());
                    },
                    child: ProductCard(
                      id: product.id,
                      title: product.title,
                      category: product.category,
                      rating: product.rating,
                      price: '\$${product.price}',
                      imageUrl: product.image,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
