import 'package:flutter/material.dart';
import 'package:hotel_real_merced/core/utils/validation_utils.dart';
import 'package:hotel_real_merced/pages/auth/widget/textformfieldauth.dart';

class Passwordfield extends StatelessWidget {
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggleObscure;
  final String texto;
  const Passwordfield({
    super.key,
    required this.controller,
    required this.obscure,
    required this.onToggleObscure,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Textformfieldauth(
        obscureText: obscure,
        controlador: controller,
        prefixicon: const Icon(Icons.lock_outline, color: Color(0xFF667eea)),
        hintText: texto,
        suffixIcon: IconButton(
          onPressed: onToggleObscure,
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[400],
          ),
        ),
        colorhint: const Color.fromARGB(255, 189, 189, 189),
        validator: ValidationUtils.validatePassword,
      ),
    );
  }
}
