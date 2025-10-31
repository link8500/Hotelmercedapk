import 'package:flutter/material.dart';

class Reservas extends StatelessWidget {
  const Reservas ({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: const Text('Reservaciones y Disponibilidad'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Próximamente: Gestión de reservaciones',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                IconButton(icon: const Icon(Icons.favorite), onPressed: () {})
              ],
            ),
          ),
        )
      );
  }
}

