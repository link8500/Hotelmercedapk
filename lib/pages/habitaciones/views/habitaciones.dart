import 'package:flutter/material.dart';
import 'package:hotel_real_merced/pages/habitaciones/widgets/romcard.dart';

class Habitaciones extends StatelessWidget {
  const Habitaciones({super.key});

  List<Map<String, dynamic>> _buildRooms() {
    return [
      {
        'titulo': 'Suite Deluxe',
        'descripcion': 'Amplia suite con vista a la ciudad, cama king y balcón.',
        'precio': 120,
        'imagen': 'images/fondo.jpg',
        'amenidades': ['Wi‑Fi', 'Desayuno', 'A/C', 'TV'],
      },
      {
        'titulo': 'Doble Superior',
        'descripcion': 'Habitación doble cómoda, ideal para familias o amigos.',
        'precio': 89,
        'imagen': 'images/hotelmierda.jpg',
        'amenidades': ['Wi‑Fi', 'A/C', 'TV'],
      },
      {
        'titulo': 'Estándar',
        'descripcion': 'Opción económica y práctica con todo lo esencial.',
        'precio': 65,
        'imagen': 'images/GNF2MI2WkAAazNS.png',
        'amenidades': ['Wi‑Fi', 'TV'],
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final rooms = _buildRooms();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habitaciones'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final room = rooms[index];
          return Romcard(
            title: room['titulo'],
            description: room['descripcion'],
            price: room['precio'],
            image: room['imagen'],
            amenities: List<String>.from(room['amenidades'] as List),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemCount: rooms.length,
      ),
    );
  }
}
