import 'package:flutter/material.dart';
import 'package:hotel_real_merced/pages/navegation/views/navegacion.dart';
import 'package:hotel_real_merced/pages/reservations/view/reservas.dart';
import 'package:hotel_real_merced/core/services/supabase_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Supabase
  await SupabaseService.initialize();
  
  runApp(const MyApp());
}

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
