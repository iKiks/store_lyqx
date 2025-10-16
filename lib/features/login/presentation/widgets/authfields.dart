import 'package:store_lyqx/lyqx_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthField extends StatefulWidget {
  final String label;
  final TextEditingController controller;

  /// initial obscure state for the field (useful for password fields)
  final bool obscureText;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool error;

  const AuthField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.error = false,
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  void _toggleObscure() {
    setState(() {
      _obscure = !_obscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscure : false,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        suffixIcon: widget.isPassword
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: GestureDetector(
                  onTap: _toggleObscure,
                  child: SvgPicture.asset(
                    'assets/fluent_eye-20-filled.svg',
                    width: 22,
                    height: 22,
                    colorFilter: ColorFilter.mode(
                      AppColors.hintTextColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              )
            : null,
        filled: true,
        fillColor: AppColors.inputFieldColor,
        labelText: widget.label,
        labelStyle: TextStyle(color: AppColors.hintTextColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: widget.error
                ? AppColors.errorColor
                : AppColors.extraLightColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: widget.error
                ? AppColors.errorColor
                : AppColors.extraLightColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: widget.error
                ? AppColors.errorColor
                : AppColors.extraLightColor,
          ),
        ),
      ),
    );
  }
}
