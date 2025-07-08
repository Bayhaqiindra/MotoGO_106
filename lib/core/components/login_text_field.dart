import 'package:flutter/material.dart';

class LoginTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String? validatorText;
  final TextInputType keyboardType;
  final IconData prefixIcon;

  const LoginTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.validatorText,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  late bool isObscured;

  @override
  void initState() {
    super.initState();
    isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: isObscured,
      keyboardType: widget.keyboardType,
      validator: widget.validatorText != null
          ? (value) {
              if (value == null || value.isEmpty) {
                return widget.validatorText;
              }
              return null;
            }
          : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF5F7FA),
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        prefixIcon: Icon(widget.prefixIcon, color: Colors.grey),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  isObscured ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    isObscured = !isObscured;
                  });
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
