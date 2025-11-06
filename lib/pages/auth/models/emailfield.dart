import 'package:flutter/material.dart';
import 'package:hotel_real_merced/core/utils/validation_utils.dart';
import 'package:hotel_real_merced/pages/auth/widget/textformfieldauth.dart';

class Emailfield extends StatelessWidget {
  final TextEditingController controller;
  const Emailfield({super.key,required this.controller});

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
        controlador: controller,
        prefixicon: const Icon(
          Icons.email_outlined,
          color: Color(0xFF667eea),
        ),
        hintText: "tu@email.com",
        colorhint: const Color.fromARGB(255, 189, 189, 189),
        keyboardType: TextInputType.emailAddress,
        validator: ValidationUtils.validateEmail,
      ),
    );
  }
}