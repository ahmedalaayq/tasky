import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.hintText,
    this.validator,
    this.maxLines,
    this.hintStyle,
    this.maxLength,
    this.controller,
  });

  final String? hintText;
  final String? Function(String?)? validator;
  final int? maxLines;
  final TextStyle? hintStyle;
  final int? maxLength;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fillColor = isDark ? Color(0xFF282828) : Colors.grey.shade200;
    final textColor = isDark ? Colors.white : Colors.black87;
    final hintTextColor = isDark ? Colors.grey.shade400 : Colors.black38;

    return TextFormField(
      controller: controller ?? TextEditingController(),
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      validator: validator,
      maxLength: maxLength ?? 100,
      maxLines: maxLines ?? 1,
      cursorColor: theme.primaryColor,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        errorStyle: TextStyle(
          color: Color(0xFFF44336),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        hintText: hintText ?? 'e.g. Sarah Khalid',
        hintStyle: hintStyle ??
            TextStyle(
              color: hintTextColor,
              fontWeight: FontWeight.w400,
            ),
        filled: true,
        fillColor: fillColor,
        contentPadding: EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
