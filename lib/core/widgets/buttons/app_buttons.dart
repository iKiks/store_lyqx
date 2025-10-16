import 'package:store_lyqx/lyqx_core.dart';
import 'package:flutter/material.dart';

class AppButtons extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? buttonColor;
  final Color? textColor;
  final double? textSize;
  final Widget? child;
  final double? buttonWidth;
  final double? buttonHeight;
  final ButtonStyle? customButtonStyle;

  const AppButtons({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.isLoading = false,
    this.buttonColor,
    this.textColor,
    this.textSize,
    this.child,
    this.buttonWidth,
    this.buttonHeight,
    this.customButtonStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonWidth ?? double.infinity,
      height: buttonHeight ?? 48.0,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style:
            customButtonStyle ??
            ElevatedButton.styleFrom(
              backgroundColor: buttonColor ?? Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
            ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              )
            : AppTexts(
                buttonText,
                fontSize: textSize ?? ResponsiveSize.fontSize(16),
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
      ),
    );
  }
}
