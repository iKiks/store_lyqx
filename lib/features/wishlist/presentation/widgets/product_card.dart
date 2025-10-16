import 'package:store_lyqx/lyqx_core.dart';
import 'package:flutter/material.dart';

class WishlistProductCard extends StatelessWidget {
  final String title;
  final String category;
  final String rating;
  final String price;
  final int id;
  final String? imageUrl;

  const WishlistProductCard({
    super.key,
    required this.title,
    required this.category,
    required this.rating,
    required this.price,
    required this.id,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: ResponsiveSize.height(121),
          width: ResponsiveSize.width(342),
          decoration: BoxDecoration(
            color: AppColors.extraLightColor,
            borderRadius: BorderRadius.circular(ResponsiveSize.width(12)),
          ),
          padding: EdgeInsets.only(
            left: ResponsiveSize.width(16),
            right: ResponsiveSize.width(16),
            top: ResponsiveSize.height(14),
            bottom: ResponsiveSize.height(14),
          ),
          child: Row(
            children: [
              Container(
                height: ResponsiveSize.height(70),
                width: ResponsiveSize.width(70),
                decoration: BoxDecoration(
                  color: AppColors.darkGreyColor,
                  borderRadius: BorderRadius.circular(ResponsiveSize.width(8)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(ResponsiveSize.width(8)),
                  child: imageUrl != null && imageUrl!.isNotEmpty
                      ? Image.network(
                          imageUrl!,
                          width: ResponsiveSize.width(70),
                          height: ResponsiveSize.height(70),
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Icon(
                            Icons.broken_image,
                            size: ResponsiveSize.height(24),
                          ),
                        )
                      : Icon(Icons.image, size: ResponsiveSize.height(24)),
                ),
              ),
              SizedBox(width: ResponsiveSize.width(20)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTexts(
                      title,
                      fontSize: ResponsiveSize.fontSize(16),
                      fontWeight: FontWeight.w600,
                      maxLines: 1,
                    ),
                    // Spacing
                    AppTexts(
                      price,
                      fontSize: ResponsiveSize.fontSize(12),
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: ResponsiveSize.height(8)),
                    AppButtons(
                      buttonText: 'Add to cart',
                      onPressed: () {
                        // Parse price "$12.34" -> double
                        final parsedPrice =
                            double.tryParse(
                              price.replaceAll(RegExp(r'[^0-9\.]'), ''),
                            ) ??
                            0.0;
                        final item = CartItem(
                          productId: id,
                          title: title,
                          image: imageUrl ?? '',
                          price: parsedPrice,
                          quantity: 1,
                        );
                        // Dispatch to shared CartBloc
                        context.read<CartBloc>().add(AddItem(item));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to cart')),
                        );
                      },
                      buttonHeight: ResponsiveSize.height(36),
                      buttonWidth: ResponsiveSize.width(214),
                      buttonColor: AppColors.whiteColor,
                      textColor: AppColors.blackColor,
                      textSize: ResponsiveSize.fontSize(14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: ResponsiveSize.width(0),
          top: ResponsiveSize.height(0),
          child: FavouritesIcon(productId: id),
        ),
      ],
    );
  }
}
