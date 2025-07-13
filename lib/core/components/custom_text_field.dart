import 'package:flutter/material.dart';
import 'package:tugas_akhir/core/components/spaces.dart'; // Pastikan path ini benar

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Function(String value)? onChanged;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool showLabel;
  final Widget? prefixIcon; // Sudah ada
  final Widget? suffixIcon; // Sudah ada
  final bool readOnly;
  final int maxLines;
  final String? Function(String?)? validator;
  final String? hintText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.onChanged,
    this.obscureText = false,
    this.keyboardType,
    this.showLabel = true,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.maxLines = 1,
    this.validator,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: colors.onSurface,
            ),
          ),
          const SpaceHeight(12.0),
        ],
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          controller: controller,
          onChanged: onChanged,
          obscureText: obscureText,
          keyboardType: keyboardType,
          readOnly: readOnly,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: prefixIcon, // Menggunakan prefixIcon yang diberikan
            suffixIcon: suffixIcon, // Menggunakan suffixIcon yang diberikan
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(color: colors.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(color: colors.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(color: colors.primary, width: 2.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(color: colors.error, width: 2.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(color: colors.error, width: 2.0),
            ),
            hintText: hintText ?? (showLabel ? null : label),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            filled: true,
            fillColor: colors.surfaceVariant.withOpacity(0.2),
          ),
        ),
      ],
    );
  }
}