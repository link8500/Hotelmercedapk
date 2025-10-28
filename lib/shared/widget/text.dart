import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Textutils extends StatelessWidget {
  final Color selectcolor;
  final String texto;
  final double fontSize;
  const Textutils({
    super.key,
    required this.fontSize,
    required this.selectcolor,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "${texto}",
      style: GoogleFonts.poppins(
        color: selectcolor,
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
