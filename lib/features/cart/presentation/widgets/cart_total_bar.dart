import 'package:store_lyqx/lyqx_core.dart';
import 'package:flutter/material.dart';

class CartTotalBar extends StatelessWidget {
  final double total;
  final VoidCallback? onCheckout;

  const CartTotalBar({super.key, required this.total, this.onCheckout});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveSize.height(80),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(20),
        vertical: ResponsiveSize.height(12),
      ),
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
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
                  'Cart total',
                  fontSize: ResponsiveSize.fontSize(12),
                  color: AppColors.textColor,
                ),
                AppTexts.lora(
                  '\$ ${total.toStringAsFixed(2)}',
                  fontSize: ResponsiveSize.fontSize(20),
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),

          // Checkout button
          AppButtons(
            buttonText: 'Checkout',
            onPressed: onCheckout,
            buttonColor: AppColors.blackColor,
            textColor: AppColors.whiteColor,
            buttonHeight: ResponsiveSize.height(48),
            buttonWidth: ResponsiveSize.width(220),
          ),
        ],
      ),
    );
  }
}
