import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_real_merced/pages/auth/auth-log-in/view/login.dart';

class Loginlink extends StatelessWidget {
  const Loginlink({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "¿Ya tienes cuenta? ",
            style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 16),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: Text(
              "Inicia sesión aquí",
              style: GoogleFonts.poppins(
                color: const Color(0xFF667eea),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}