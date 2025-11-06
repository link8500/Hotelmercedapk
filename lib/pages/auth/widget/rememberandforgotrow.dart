import 'package:flutter/material.dart';
import 'package:hotel_real_merced/shared/widget/text.dart';

class Rememberandforgotrow extends StatelessWidget {
  final bool rememberMe;
  final ValueChanged<bool?> onChanged;
  const Rememberandforgotrow({super.key,required this.rememberMe,
    required this.onChanged,});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: rememberMe,
              onChanged: onChanged,
              activeColor: const Color(0xFF667eea),
            ),
            const Textutils(
              fontSize: 14,
              selectcolor: Color.fromARGB(255, 117, 117, 117),
              texto: "Recordarme",
            ),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: const Textutils(
            fontSize: 14,
            selectcolor: Color(0xFF667eea),
            texto: "¿Olvidaste tu contraseña?",
          ),
        ),
      ],
    );
  }
}