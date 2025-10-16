import 'package:store_lyqx/lyqx_core.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;
  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductBloc>().add(FetchProductById(widget.productId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.extraLightColor,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading || state is ProductInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProductError) {
              return Center(
                child: AppTexts(
                  state.message,
                  fontSize: ResponsiveSize.fontSize(16),
                ),
              );
            }

            if (state is ProductDetailsLoaded) {
              final product = state.product;
              // Debug: building ProductDetailsScreen
              // ignore: avoid_print
              print(
                'ProductDetailsScreen: building details for product ${product.id}',
              );

              // Responsive bottom bar height
              final double bottomBarHeight = ResponsiveSize.height(84);

              return Stack(
                children: [
                  // Image top, details below
                  Column(
                    children: [
                      // Top image area
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.extraLightColor,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(16),
                          ),
                        ),
                        alignment: Alignment.center,
                        height: ResponsiveSize.height(520),
                        child: SizedBox(
                          width: ResponsiveSize.width(267),
                          height: ResponsiveSize.height(204),
                          child: Image.network(
                            product.image,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      // Scrollable details panel
                      Expanded(
                        child: Container(
                          height: ResponsiveSize.height(360),
                          width: double.infinity,
                          padding: EdgeInsets.fromLTRB(
                            ResponsiveSize.width(20),
                            ResponsiveSize.height(20),
                            ResponsiveSize.width(20),
                            ResponsiveSize.height(20) + bottomBarHeight,
                          ),
                          decoration: const BoxDecoration(
                            color: AppColors.whiteColor,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppTexts(
                                  product.title,
                                  fontSize: ResponsiveSize.fontSize(20),
                                  fontWeight: FontWeight.w700,
                                ),
                                SizedBox(height: ResponsiveSize.height(8)),
                                AppTexts(
                                  product.category,
                                  fontSize: ResponsiveSize.fontSize(14),
                                  color: AppColors.greyColor,
                                ),
                                SizedBox(height: ResponsiveSize.height(12)),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: AppColors.blackColor,
                                      size: ResponsiveSize.fontSize(12),
                                    ),
                                    SizedBox(width: ResponsiveSize.width(4)),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppTexts(
                                          product.rating.toStringAsFixed(2),
                                          fontSize: ResponsiveSize.fontSize(14),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: ResponsiveSize.width(4)),
                                    AppTexts(
                                      '${product.ratingCount.toString()} reviews',
                                      fontSize: ResponsiveSize.fontSize(14),
                                    ),
                                    const SizedBox.shrink(),
                                  ],
                                ),

                                SizedBox(height: ResponsiveSize.height(12)),

                                // Description (optional)
                                SizedBox(height: ResponsiveSize.height(24)),

                                // More content (rating/specs)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Back button
                  Positioned(
                    left: ResponsiveSize.width(12),
                    top: ResponsiveSize.height(26),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.transparentColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                  // Favourite icon
                  Positioned(
                    right: ResponsiveSize.width(12),
                    top: ResponsiveSize.height(26),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.transparentColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: FavouritesIcon(productId: widget.productId),
                      ),
                    ),
                  ),

                  // Bottom bar with price and Add to cart
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: bottomBarHeight,
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveSize.width(20),
                        vertical: ResponsiveSize.height(12),
                      ),
                      decoration: const BoxDecoration(
                        color: AppColors.secondaryColor,
                      ),
                      child: Row(
                        children: [
                          // Price
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppTexts(
                                  'Price',
                                  fontSize: ResponsiveSize.fontSize(12),
                                  color: AppColors.textColor,
                                ),
                                SizedBox(height: ResponsiveSize.height(6)),
                                AppTexts(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  fontSize: ResponsiveSize.fontSize(20),
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),
                          ),

                          // Add to cart
                          AppButtons(
                            onPressed: () {
                              final item = CartItem(
                                productId: product.id,
                                title: product.title,
                                image: product.image,
                                price: product.price,
                                quantity: 1,
                              );
                              // Dispatch to shared CartBloc
                              context.read<CartBloc>().add(AddItem(item));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Added to cart')),
                              );
                            },

                            buttonText: 'Add to cart',
                            buttonColor: AppColors.blackColor,
                            textColor: AppColors.whiteColor,
                            buttonWidth: ResponsiveSize.width(220),
                            child: AppTexts(
                              'Add to cart',
                              fontSize: ResponsiveSize.fontSize(16),
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            // Fallback
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
