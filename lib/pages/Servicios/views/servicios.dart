import 'package:flutter/material.dart';

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
          return _ServiceCard(
            icon: s['icon'] as IconData,
            title: s['title'] as String,
            description: s['desc'] as String,
          );
        },
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.description,
  });
  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFeef2ff), Color(0xFFf5f3ff)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xFF667eea), size: 28),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Text(
                  description,
                  style: TextStyle(color: Colors.grey[700], fontSize: 12),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
