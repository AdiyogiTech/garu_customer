import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garu_customer/screens/constant/colors.dart';

class AuthTextField extends StatelessWidget {
  final String? hintText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final List<String>? autofillHints;
  final String? Function(String?)? validator;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscure;
  final int? length;
  final String? IconImage;
  final double? Imagescale;
  final double? Imageheight;
  final Widget? suffixIcon;
  final Color? hoverColor;

  // New parameters for enhanced styling
  final Color? containerColor;
  final double? borderRadius;
  final Color? iconBackgroundColor;
  final double? elevation;
  final EdgeInsets? contentPadding;
  final bool showPrefixIcon;
  final double? prefixIconSize;
  final Color? prefixIconColor;
  final String? prefixIcon;
  final Widget? prefix;

  // ADD THESE MISSING PARAMETERS
  final Color? borderColor;
  final Color? fillColor;

  const AuthTextField({
    super.key,
    this.hintText,
    this.controller,
    this.textInputAction,
    this.autofillHints,
    this.validator,
    this.length,
    this.obscure = false,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType,
    this.IconImage,
    this.Imagescale = 4,
    this.Imageheight = 30,
    this.suffixIcon,
    this.hoverColor,

    // Initialize new parameters with defaults
    this.containerColor,
    this.borderRadius,
    this.iconBackgroundColor,
    this.elevation = 0,
    this.contentPadding,
    this.showPrefixIcon = true,
    this.prefixIconSize,
    this.prefixIconColor,
    this.prefixIcon,
    this.prefix,

    // Initialize missing parameters
    this.borderColor,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.008,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: fillColor ?? containerColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius ?? 18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 14,
              spreadRadius: 1,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: TextFormField(
          autofillHints: autofillHints,
          keyboardType: keyboardType,
          controller: controller,
          validator: validator,
          textCapitalization: textCapitalization,
          textInputAction: textInputAction,
          cursorColor: primary,
          cursorWidth: 1.5,
          cursorRadius: const Radius.circular(2),
          enableInteractiveSelection: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: obscure,
          inputFormatters: inputFormatters,
          maxLength: length,
          maxLines: 1,
          style: TextStyle(
            fontSize: size.width * 0.038,
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
          decoration: InputDecoration(
            fillColor: fillColor ?? containerColor ?? Colors.white,
            filled: true,

            // Border configurations - clean and minimal
            border: _OutlineInputBorder(
              borderColor ??const Color(0xffE7EAF0),
              borderRadius ?? 16,
            ),
            focusedBorder: _OutlineInputBorder(
              borderColor ?? primarylogin,
              borderRadius ?? 16,
              width: 1.5,
            ),
            errorBorder: _OutlineInputBorder(
              Colors.red.shade300,
              borderRadius ?? 16,
            ),
            enabledBorder: _OutlineInputBorder(
              borderColor ?? const Color(0xffE7EAF0),
              borderRadius ?? 16,
            ),
            focusedErrorBorder: _OutlineInputBorder(
              Colors.red,
              borderRadius ?? 16,
              width: 1.5,
            ),
            disabledBorder: _OutlineInputBorder(
              borderColor ?? const Color(0xffE7EAF0),
              borderRadius ?? 16,
            ),

            isDense: true,
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: size.width * 0.035,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.2,
            ),
            counterText: "",
            contentPadding: contentPadding ?? EdgeInsets.symmetric(
              horizontal: size.width * 0.04,
              vertical: size.height * 0.016,
            ),

            // Prefix Icon with minimalist design
            prefixIcon: showPrefixIcon
                ? (prefix ?? _buildPrefixIcon(size))
                : null,

            // Suffix Icon
            suffixIcon: suffixIcon != null
                ? Padding(
              padding: const EdgeInsets.only(right: 12),
              child: suffixIcon,
            )
                : null,

            // Additional styling
            suffixIconConstraints: BoxConstraints(
              minWidth: size.width * 0.1,
              minHeight: size.height * 0.05,
            ),

            hoverColor: hoverColor ?? primary.withOpacity(0.02),
            focusColor: primary.withOpacity(0.02),
          ),
        ),
      ),
    );
  }

  Widget _buildPrefixIcon(Size size) {
    // Determine which icon to show
    String iconToShow = prefixIcon ?? IconImage ?? '';

    if (iconToShow.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.only(right: size.width * 0.02),
      width: size.width * 0.12,
      child: Row(
        children: [
          Container(
            width: size.width * 0.12,
            height: size.width * 0.12,
            decoration: BoxDecoration(
              color: (iconBackgroundColor ?? primary).withOpacity(0.1),
              borderRadius: BorderRadius.circular(borderRadius ?? 12),
            ),
            child: Center(
              child: iconToShow.contains('assets/')
                  ? Image.asset(
                iconToShow,
                scale: Imagescale ?? 3.5,
                height: Imageheight ?? size.width * 0.05,
                width: size.width * 0.05,
                color: prefixIconColor ?? (iconBackgroundColor ?? primarylogin),
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.person_outline,
                    color: prefixIconColor ?? (iconBackgroundColor ?? primarylogin),
                    size: prefixIconSize ?? size.width * 0.05,
                  );
                },
              )
                  : Icon(
                Icons.person_outline,
                color: prefixIconColor ?? (iconBackgroundColor ?? primarylogin),
                size: prefixIconSize ?? size.width * 0.05,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

OutlineInputBorder _OutlineInputBorder(
    Color borderColor,
    double borderRadius, {
      double width = 1,
    }) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius),
    borderSide: BorderSide(
      color: borderColor,
      width: width,
    ),
  );
}