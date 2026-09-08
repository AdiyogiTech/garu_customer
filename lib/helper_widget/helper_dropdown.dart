import 'package:flutter/material.dart';
import 'package:garu_customer/screens/constant/colors.dart';
import 'package:garu_customer/screens/constant/style.dart';

class DropTextField extends StatelessWidget {
  final String? hintText;
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;

  const DropTextField({
    Key? key,
    this.hintText,
    required this.items,
    this.value,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      menuMaxHeight: 300, // Dropdown Height
      elevation: 8,
      borderRadius: BorderRadius.circular(14),
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Colors.grey,
        size: 24,
      ),
      dropdownColor: Colors.white,
      hint: Text(
        hintText ?? "",
        style: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 14,
        ),
      ),

      style: const TextStyle(
        fontSize: 15,
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),

      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,

        prefixIcon: Padding(
          padding: const EdgeInsets.all(12),
          child: Image.asset(
            'assets/images/icon_home.png',
           scale: 2.0,
            color: primarylogin,
          ),
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: primarylogin,
            width: 1.5,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
      ),

      validator: validator,
      onChanged: onChanged,
      items: items,
    );
  }
}