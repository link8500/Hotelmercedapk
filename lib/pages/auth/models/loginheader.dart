import 'package:flutter/material.dart';
import 'package:hotel_real_merced/shared/widget/text.dart';

class Loginheader extends StatelessWidget {
  final String texto1;
  final String texto2;
  const Loginheader({super.key,required this.texto1,required this.texto2});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Textutils(
          fontSize: 28,
          selectcolor: Color(0xFF2D3748),
          texto: texto1,
        ),
        SizedBox(height: 8),
        Textutils(
          fontSize: 16,
          selectcolor: Color.fromARGB(255, 117, 117, 117),
          texto: texto2,
        ),
      ],
    );
  }
}