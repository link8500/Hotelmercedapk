import 'package:flutter/material.dart';
import 'package:hotel_real_merced/shared/widget/text.dart';

class Ordivider extends StatelessWidget {
  const Ordivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Textutils(
            fontSize: 14,
            selectcolor: Color.fromARGB(255, 158, 158, 158),
            texto: "O continúa con",
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
      ],
    );
  }
}
