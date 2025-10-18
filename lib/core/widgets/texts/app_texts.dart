import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_lyqx/lyqx_core.dart';

/// Reusable text widget with responsive font size and multiple font styles.
class AppTexts extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final bool softWrap;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final double? letterSpacing;
  final double? height;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextStyle Function({TextStyle? textStyle}) _fontBuilder;

  /// Default uses **Urbanist**
  const AppTexts(
    this.text, {
    super.key,
    required this.fontSize,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.letterSpacing,
    this.height,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
  }) : _fontBuilder = GoogleFonts.urbanist;

  /// Use **Inter**
  const AppTexts.inter(
    this.text, {
    super.key,
    required this.fontSize,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.letterSpacing,
    this.height,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
  }) : _fontBuilder = GoogleFonts.inter;

  /// Use **Lora**
  const AppTexts.lora(
    this.text, {
    super.key,
    required this.fontSize,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.letterSpacing,
    this.height,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
  }) : _fontBuilder = GoogleFonts.lora;

  @override
  Widget build(BuildContext context) {
    final double scaledFontSize = ResponsiveSize.fontSize(fontSize);

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      style: _fontBuilder(
        textStyle: TextStyle(
          fontSize: scaledFontSize,
          color: color,
          fontWeight: fontWeight,
          letterSpacing: letterSpacing,
          height: height,
        ),
      ),
    );
  }
}
