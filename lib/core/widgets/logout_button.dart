import 'package:store_lyqx/lyqx_core.dart';
import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final bool clearCart;
  final bool clearFavorites;
  final Color? backgroundColor;

  const LogoutButton({
    super.key,
    this.clearCart = true,
    this.clearFavorites = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await AppStorage.logout(
          clearCart: clearCart,
          clearFavorites: clearFavorites,
        );
        if (!context.mounted) return;
        context.goNamed('splash');
      },
      child: Column(
        children: [
          Container(
            height: ResponsiveSize.height(32),
            width: ResponsiveSize.width(32),
            decoration: BoxDecoration(
              color: backgroundColor ?? AppColors.secondaryColor,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.extraLightColor),
            ),
            child: Icon(Icons.logout, size: ResponsiveSize.height(20)),
          ),
          AppTexts(
            'Logout',
            fontSize: ResponsiveSize.fontSize(12),
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}
