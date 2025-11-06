import 'package:flutter/material.dart';
import 'package:hotel_real_merced/pages/Servicios/widgets/servicecard.dart';

class Servicios extends StatelessWidget {
  const Servicios({super.key});

  List<Map<String, dynamic>> _services() => [
    {
      'icon': Icons.pool,
      'title': 'Piscina',
      'desc': 'Piscina al aire libre con toallas',
    },
    {
      'icon': Icons.restaurant,
      'title': 'Restaurante',
      'desc': 'Desayuno incluido y menú a la carta',
    },
    {
      'icon': Icons.local_parking,
      'title': 'Parqueo',
      'desc': 'Estacionamiento privado gratuito',
    },
    {
      'icon': Icons.spa,
      'title': 'Spa',
      'desc': 'Masajes y tratamientos relajantes',
    },
    {
      'icon': Icons.wifi,
      'title': 'Wi‑Fi',
      'desc': 'Internet de alta velocidad',
    },
    {
      'icon': Icons.local_laundry_service,
      'title': 'Lavandería',
      'desc': 'Servicio de lavado y planchado',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final items = _services();
    return Scaffold(
      appBar: AppBar(title: const Text('Servicios')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 4 / 3,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final s = items[index];
          return Servicecard(
            icon: s['icon'] as IconData,
            title: s['title'] as String,
            description: s['desc'] as String,
          );
        },
      ),
    );
  }
}

