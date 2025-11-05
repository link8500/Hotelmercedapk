import 'package:flutter/material.dart';
import 'package:hotel_real_merced/pages/home/view/home.dart';
import 'package:hotel_real_merced/pages/habitaciones/views/habitaciones.dart';
import 'package:hotel_real_merced/pages/Servicios/views/servicios.dart';
import 'package:hotel_real_merced/pages/profile/views/profile.dart';

class Navegacion extends StatefulWidget {
  const Navegacion({super.key});

  @override
  State<Navegacion> createState() => _NavegacionState();
}

class _NavegacionState extends State<Navegacion> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    Habitaciones(),
    Servicios(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.meeting_room_outlined), selectedIcon: Icon(Icons.meeting_room), label: 'Habitaciones'),
          NavigationDestination(icon: Icon(Icons.room_service_outlined), selectedIcon: Icon(Icons.room_service), label: 'Servicios'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}