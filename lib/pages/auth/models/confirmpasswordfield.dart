import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_real_merced/core/utils/validation_utils.dart';
import 'package:hotel_real_merced/pages/auth/widget/inputdecorator.dart';

class Confirmpasswordfield extends StatelessWidget {
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggleObscure;
  final String Function() getPassword;
  const Confirmpasswordfield({
    super.key,
    required this.controller,
    required this.obscure,
    required this.onToggleObscure,
    required this.getPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Inputdecorator(
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF667eea)),
          suffixIcon: IconButton(
            onPressed: onToggleObscure,
            icon: Icon(
              obscure ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey[400],
            ),
          ),
          hintText: "Repite tu contraseña",
          hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
        style: GoogleFonts.poppins(fontSize: 16),
        validator: (value) =>
            ValidationUtils.validateConfirmPassword(value, getPassword()),
      ),
    );
  }
}
