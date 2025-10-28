import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Textformfieldauth extends StatelessWidget {
  final TextEditingController controlador;
  final Icon prefixicon;
  final String hintText;
  final Color colorhint;
  final TextInputType? keyboardType;
  final String? Function(String?) validator;
  final Widget? suffixIcon;
  final bool obscureText;
  const Textformfieldauth({
    super.key,
    required this.controlador,
    required this.prefixicon,
    required this.hintText,
    required this.colorhint,
    this.keyboardType,
    required this.validator,
    this.suffixIcon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: prefixicon,
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(color: colorhint),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
      ),
      style: GoogleFonts.poppins(fontSize: 16),
      validator: validator,
    );
  }
}
