import 'package:store_lyqx/lyqx_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable text with responsive font size (Google Fonts)
class AppTexts extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final bool? softWrap;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final double? letterSpacing;
  final double? height;
  final int? maxLines;
  final TextOverflow? overflow;
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
  });

  @override
  Widget build(BuildContext context) {
    // Responsive font size
    final double scaledFontSize = ResponsiveSize.fontSize(fontSize);

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      // GoogleFonts.urbanist styling
      style: GoogleFonts.urbanist(
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
