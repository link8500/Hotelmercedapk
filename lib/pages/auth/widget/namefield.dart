import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_real_merced/pages/auth/widget/inputdecorator.dart';

class Namefield extends StatelessWidget {
  final TextEditingController controller;
  final String texto2;
  final String texto;
  final String texto3;
  const Namefield({
    super.key,
    required this.controller,
    required this.texto,
    required this.texto2,
    required this.texto3
  });

  @override
  Widget build(BuildContext context) {
    return Inputdecorator(
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(
            Icons.person_outline,
            color: Color(0xFF667eea),
          ),
          hintText: texto,
          hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
        style: GoogleFonts.poppins(fontSize: 16),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return texto2;
          }
          if (value.length < 2) {
            return texto3;
          }
          return null;
        },
      ),
    );
  }
}
