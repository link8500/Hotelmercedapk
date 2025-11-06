import 'package:flutter/material.dart';
import 'package:hotel_real_merced/shared/widget/text.dart';

class Loginbutton extends StatelessWidget {
   final VoidCallback onPressed;
   final String text;
  const Loginbutton({super.key,required this.onPressed,required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Textutils(
          fontSize: 18,
          selectcolor: Colors.white,
          texto: "Iniciar Sesión",
        ),
      ),
    );
  }
}