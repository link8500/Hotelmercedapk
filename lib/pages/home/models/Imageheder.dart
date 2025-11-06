import 'package:flutter/material.dart';
import 'package:hotel_real_merced/pages/home/widget/greting.dart';
import 'package:hotel_real_merced/pages/home/widget/searchbar.dart';
import 'package:hotel_real_merced/pages/home/widget/tobar.dart';

class Imageheder extends StatelessWidget {
  const Imageheder({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(40),
        bottomRight: Radius.circular(40),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 380,
        child: Stack(
          children: [
            // Imagen de fondo
            Image.asset(
              'images/fondo.jpg',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            // Ícono principal
            const Center(
              child: Icon(Icons.hotel, color: Colors.white, size: 80),
            ),
            // Gradiente overlay + contenido
            Positioned.fill(
              child: Container(
                padding: const EdgeInsets.only(
                  top: 50.0,
                  left: 25.0,
                  right: 25.0,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Tobar(),
                    SizedBox(height: 40),
                    Greting(),
                    SizedBox(height: 30),
                    Searchbar(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
