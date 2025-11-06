import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Termsrow extends StatelessWidget {
  final bool checked;
  final ValueChanged<bool?> onChanged;
  const Termsrow({super.key,required this.checked, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: checked,
          onChanged: onChanged,
          activeColor: const Color(0xFF667eea),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                children: [
                  const TextSpan(text: "Acepto los "),
                  TextSpan(
                    text: "términos y condiciones",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF667eea),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: " y la "),
                  TextSpan(
                    text: "política de privacidad",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF667eea),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}