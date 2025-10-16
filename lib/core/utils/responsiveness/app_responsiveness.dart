import 'package:flutter/material.dart';

/// Reference size is a common phone screen; values are scaled.
class ResponsiveSize {
  static late double screenWidth;
  static late double screenHeight;

  /// Initialize with current screen size (call once at app start)
  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }

  /// Scale height by screen height
  static double height(double size) {
    // Reference height (e.g., iPhone 11 Pro)
    const double referenceHeight = 812.0;
    return size * (screenHeight / referenceHeight);
  }

  /// Scale width by screen width
  static double width(double size) {
    // Reference width (e.g., iPhone 11 Pro)
    const double referenceWidth = 375.0;
    return size * (screenWidth / referenceWidth);
  }

  /// Scale font by screen width
  static double fontSize(double size) {
    // Use width to avoid huge fonts on tall screens
    const double referenceWidth = 375.0;
    return size * (screenWidth / referenceWidth);
  }
}
