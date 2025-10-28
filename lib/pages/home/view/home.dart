import 'package:flutter/material.dart';
import 'package:hotel_real_merced/pages/home/models/Imageheder.dart';
import 'package:hotel_real_merced/pages/home/widget/buildcategorycard.dart';
import 'package:hotel_real_merced/pages/home/widget/buildhotelcard.dart';
import 'package:hotel_real_merced/pages/home/widget/floatingbutton.dart';
import 'package:google_fonts/google_fonts.dart';

class home extends StatefulWidget {
  const home({super.key});
  @override
  State<home> createState() => _nameState();
}
class _nameState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      floatingActionButton: Floatingbutton(),
      body: SafeArea(child:  SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con imagen de fondo mejorado
            Imageheder(),
            const SizedBox(height: 30),
            // Sección de contenido mejorada
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título de sección con icono
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Lo más relevante",
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF2D3748),
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Lista horizontal mejorada
                  SizedBox(
                    height: 260,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        BuildHotelCard(
                          title: "Hotel Real Merced",
                          location: "Granada, Nicaragua",
                          imagePath: "images/hotelmierda.jpg",
                          rating: "★★★★★",
                          price: "\$89/noche",
                        ),
                        const SizedBox(width: 15),
                        BuildHotelCard(
                          title: "Hotel Colonial",
                          location: "Granada, Nicaragua",
                          imagePath: "images/GNF2MI2WkAAazNS.png",
                          rating: "★★★★☆",
                          price: "\$75/noche",
                        ),
                        const SizedBox(width: 15),
                        BuildHotelCard(
                          title: "Hotel Boutique",
                          location: "Granada, Nicaragua",
                          imagePath: "images/fondo.jpg",
                          rating: "★★★★★",
                          price: "\$120/noche",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Sección de categorías
                  Text(
                    "Categorías",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF2D3748),
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: const BuildCategoryCard(
                          title: "Hoteles",
                          icon: Icons.hotel,
                          color: Color(0xFF667eea),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: const BuildCategoryCard(
                          title: "Resorts",
                          icon: Icons.pool,
                          color: Color(0xFF764ba2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100), // Espacio para el FAB
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
