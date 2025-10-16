import 'package:store_lyqx/lyqx_core.dart';
import 'package:flutter/material.dart';
// Presentation-only card

class ProductCard extends StatelessWidget {
  final String title;
  final String category;
  final double rating;
  final String imageUrl;
  final String price;
  final VoidCallback? onAdd;
  final int id;

  const ProductCard({
    super.key,
    required this.id,
    required this.title,
    required this.category,
    required this.rating,
    required this.imageUrl,
    required this.price,
    this.onAdd,
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
                  borderRadius: BorderRadius.circular(ResponsiveSize.width(8)),
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.lightGreyColor,
                      child: Icon(
                        Icons.image_not_supported,
                        size: ResponsiveSize.height(70),
                        color: AppColors.greyColor,
                      ),
                    );
                  },
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
                      softWrap: false,
                    ),
                    // Spacing
                    AppTexts(
                      category,
                      fontSize: ResponsiveSize.fontSize(12),
                      fontWeight: FontWeight.w600,
                      color: AppColors.greyColor,
                    ),
                    SizedBox(height: ResponsiveSize.height(4)),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: ResponsiveSize.height(10),
                          color: Colors.black,
                        ),
                        SizedBox(width: ResponsiveSize.width(6)),
                        AppTexts(
                          rating.toString(),
                          fontSize: ResponsiveSize.fontSize(12),
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveSize.height(4)),

                    AppTexts(
                      price,
                      fontSize: ResponsiveSize.fontSize(14),
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox.shrink(),
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
