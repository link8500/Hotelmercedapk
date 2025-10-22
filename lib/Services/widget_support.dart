import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Appwidget{
  static TextStyle whitetextstyle(double size){
    return GoogleFonts.poppins(
      color: const Color.fromARGB(255, 248, 248, 248), 
      fontSize: size, 
      fontWeight: FontWeight.w500,
    );
  }
  
  static TextStyle headlinetextstyle(double size){
    return GoogleFonts.poppins(
      color: const Color(0xFF2D3748),
      fontSize: size, 
      fontWeight: FontWeight.w700,
    );
  }
  
  static TextStyle bodytextstyle(double size){
    return GoogleFonts.poppins(
      color: const Color(0xFF4A5568),
      fontSize: size,
      fontWeight: FontWeight.w400,
    );
  }
  
  static TextStyle accenttextstyle(double size){
    return GoogleFonts.poppins(
      color: const Color(0xFF667eea),
      fontSize: size,
      fontWeight: FontWeight.w600,
    );
  }
}