import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garu_customer/screens/constant/colors.dart';
class ReviewField extends StatelessWidget {
  final String? hintText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscure;
  final int? length;
  const ReviewField({
    super.key,
    this.hintText,
    this.controller,
    this.textInputAction,
    this.validator,
    this.length,
    this.obscure = false,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 8),
      child: TextFormField(
        keyboardType: keyboardType,
        controller: controller,
        validator: validator,
        textCapitalization: textCapitalization,
        textInputAction: textInputAction,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: obscure,
        inputFormatters: inputFormatters,
        maxLength: length,
        maxLines: 1,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          border: _OutlineInputBorder(Colors.grey.shade400),
          focusedBorder: _OutlineInputBorder(primary),
          errorBorder: _OutlineInputBorder(Colors.red),
          enabledBorder: _OutlineInputBorder(Colors.grey.shade400),
          focusedErrorBorder: _OutlineInputBorder(red),
          disabledBorder: _OutlineInputBorder(Colors.grey.shade400),
          isDense: true,
          hintText: hintText,
          counterText: "",
          contentPadding: EdgeInsets.symmetric(vertical: -4),
          prefixIconConstraints: BoxConstraints(maxWidth: 60),
          prefixIcon: Padding(
            padding:  EdgeInsets.only(right: 10),
            child: Container(
              padding: EdgeInsets.all(8),
              width: 10,
              height: 40,
            ),
          ),
          // suffixIcon: suffixIcon,
          // hoverColor:hoverColor,
        ),
      ),
    );
  }
}
OutlineInputBorder _OutlineInputBorder (Color borderColor){
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: borderColor),
  );
}