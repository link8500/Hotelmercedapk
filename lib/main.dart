import 'package:flutter/material.dart';
import 'package:hotel_real_merced/pages/navegation/views/navegacion.dart';
import 'package:hotel_real_merced/pages/reservations/view/reservas.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Navegacion(),
      title: 'Hotel Real Merced app',
      debugShowCheckedModeBanner: false,
      routes: {
        '/reservas': (_) => const Reservas(),
      },
    );
  }
}
