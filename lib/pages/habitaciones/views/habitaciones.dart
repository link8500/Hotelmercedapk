import 'package:flutter/material.dart';

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
          return _RoomCard(
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

class _RoomCard extends StatelessWidget {
  const _RoomCard({
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    required this.amenities,
  });

  final String title;
  final String description;
  final int price;
  final String image;
  final List<String> amenities;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(image, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(
                      '\$${price.toString()}/noche',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF667eea)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: amenities
                      .map((a) => Chip(
                            label: Text(a),
                            backgroundColor: const Color(0xFFF3F4F6),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/reservas');
                    },
                    icon: const Icon(Icons.calendar_today_outlined),
                    label: const Text('Reservar'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}