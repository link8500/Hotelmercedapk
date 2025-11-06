import 'package:flutter/material.dart';
import 'package:hotel_real_merced/shared/widget/text.dart';

class Registerlink extends StatelessWidget {
  final Widget Function(BuildContext) builder1;
  final String text1;
  final String text2;
  const Registerlink({super.key,required this.builder1,required this.text1,required this.text2});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Textutils(
            fontSize: 16,
            selectcolor: Color.fromARGB(255, 117, 117, 117),
            texto: text1,
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: builder1,
                ),
              );
            },
            child: Textutils(
              fontSize: 16,
              selectcolor: Color(0xFF667eea),
              texto: text2,
            ),
          ),
        ],
      ),
    );
  }
}