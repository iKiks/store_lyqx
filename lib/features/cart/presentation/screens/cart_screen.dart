import 'package:store_lyqx/lyqx_core.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Trigger CartBloc load
      try {
        context.read<CartBloc>().add(LoadCart(-1));
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppTexts(
                    'Cart',
                    fontSize: ResponsiveSize.fontSize(24),
                    fontWeight: FontWeight.w600,
                  ),
                  const LogoutButton(clearCart: true),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state is CartLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is CartLoaded) {
                    return ListView.builder(
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return CartItemCard(
                          item: item,
                          onDelete: () => context.read<CartBloc>().add(
                            RemoveItem(item.productId),
                          ),
                          onQuantityChanged: (q) =>
                              context.read<CartBloc>().add(
                                UpdateQuantity(item.productId, q.clamp(1, 999)),
                              ),
                        );
                      },
                    );
                  }
                  if (state is CartError) {
                    // Log error
                    // ignore: avoid_print
                    print('CartScreen: CartError -> ${state.message}');
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                double total = 0.0;
                if (state is CartLoaded) total = state.total;
                return CartTotalBar(total: total, onCheckout: () {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
